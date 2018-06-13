#!/bin/bash -ex

# TODO: /etc/dnsmasq.d/origin-upstream-dns.conf is currently hardcoded; it
# probably shouldn't be

if [ -f "/etc/sysconfig/atomic-openshift-node" ]; then
	SERVICE_TYPE=atomic-openshift
	IMAGE_TYPE=ose
	IMAGE_PREFIX="registry.access.redhat.com/openshift3"
else
	SERVICE_TYPE=origin
	IMAGE_TYPE=origin
	IMAGE_PREFIX=openshift
fi

# TODO: with WALinuxAgent>=v2.2.21 (https://github.com/Azure/WALinuxAgent/pull/1005)
# we should be able to append context=system_u:object_r:container_var_lib_t:s0
# to ResourceDisk.MountOptions in /etc/waagent.conf and remove this stanza.
systemctl stop docker.service
umount /mnt/resource
mkfs.xfs -f /dev/sdb1
mount -o rw,relatime,seclabel,attr2,inode64,grpquota /dev/sdb1 /var/lib/docker
restorecon -R /var/lib/docker
systemctl start docker.service

echo "BOOTSTRAP_CONFIG_NAME=node-config-master" >>/etc/sysconfig/${SERVICE_TYPE}-node

for dst in tcp,2379 tcp,2380 tcp,8443 tcp,8444 tcp,8053 udp,8053 tcp,9090; do
	proto=${dst%%,*}
	port=${dst##*,}
	iptables -A OS_FIREWALL_ALLOW -p $proto -m state --state NEW -m $proto --dport $port -j ACCEPT
done

iptables-save >/etc/sysconfig/iptables

rm -rf /etc/etcd/* /etc/origin/master/*

mkdir -p /etc/origin/master

oc adm create-bootstrap-policy-file --filename=/etc/origin/master/policy.json

( cd / && base64 -d <<< {{ .ConfigBundle }} | tar -xz)

cp /etc/origin/node/ca.crt /etc/pki/ca-trust/source/anchors/openshift-ca.crt
update-ca-trust

# FIXME: It is horrible that we're installing az.  Try to avoid adding
# additional functionality in this script that requires it.  One route to remove
# this code is to bake this script into the base image, then pass in parameters
# such as the registry storage account name and key direct from ARM.
rpm -i https://packages.microsoft.com/yumrepos/azure-cli/azure-cli-2.0.31-1.el7.x86_64.rpm

set +x
. <(sed -e 's/: */=/' /etc/origin/cloudprovider/azure.conf)
az login --service-principal -u "$aadClientId" -p "$aadClientSecret" --tenant "$aadTenantId" &>/dev/null
REGISTRY_STORAGE_AZURE_ACCOUNTNAME=$(az storage account list -g "$resourceGroup" --query "[?ends_with(name, 'registry')].name" -o tsv)
REGISTRY_STORAGE_AZURE_ACCOUNTKEY=$(az storage account keys list -g "$resourceGroup" -n "$REGISTRY_STORAGE_AZURE_ACCOUNTNAME" --query "[?keyName == 'key1'].value" -o tsv)
az logout
set -x

###
# retrieve the public ip via dns for the router public ip and sub it in for the routingConfig.subdomain
###
routerLBHost="{{ .RouterLBHostname }}"
routerLBIP=$(dig +short $routerLBHost)

sed -i "s/TEMPROUTERIP/$routerLBIP/; s|IMAGE_PREFIX|$IMAGE_PREFIX|g; s|IMAGE_TYPE|${IMAGE_TYPE}|g" /etc/origin/master/master-config.yaml

mkdir -p /root/.kube

for loc in /root/.kube/config /etc/origin/node/bootstrap.kubeconfig /etc/origin/node/node.kubeconfig; do
  cp /etc/origin/master/admin.kubeconfig "$loc"
done

# Patch the etcd_ip address placed inside of the static pod definition from the node install
sed -i "s/ETCD_IP_REPLACE/{{ .MasterIP }}/g" /etc/origin/node/disabled/etcd.yaml

export KUBECONFIG=/etc/origin/master/admin.kubeconfig

# Move each static pod into place so the kubelet will run it.
# Pods: [apiserver, controller, etcd]
oc set env --local -f /etc/origin/node/disabled/apiserver.yaml DEBUG_LOGLEVEL=4 -o yaml --dry-run > /etc/origin/node/pods/apiserver.yaml
oc set env --local -f /etc/origin/node/disabled/controller.yaml DEBUG_LOGLEVEL=4 -o yaml --dry-run > /etc/origin/node/pods/controller.yaml
mv /etc/origin/node/disabled/etcd.yaml /etc/origin/node/pods/etcd.yaml
rm -rf /etc/origin/node/disabled

systemctl start ${SERVICE_TYPE}-node

while ! curl -o /dev/null -m 2 -kfs https://localhost:8443/healthz; do
	sleep 1
done

while ! oc get svc kubernetes &>/dev/null; do
	sleep 1
done

cat >/tmp/rootconfig <<EOF
CACert: $(base64 -w0 </etc/origin/master/ca.crt)
CAKey: $(base64 -w0 </etc/origin/master/ca.key)
DNSPrefix: {{ .DNSPrefix }}
FrontProxyCACert: $(base64 -w0 </etc/origin/master/front-proxy-ca.crt)
Location: {{ .Location }}
MasterHostname: $(hostname)
RegistryAccountKey: $REGISTRY_STORAGE_AZURE_ACCOUNTKEY
RegistryStorageAccount: $REGISTRY_STORAGE_AZURE_ACCOUNTNAME
RouterIP: $routerLBIP
ServiceSignerCACert: $(base64 -w0 </etc/origin/master/service-signer.crt)
EOF

oc create -f - <<'EOF'
kind: Namespace
apiVersion: v1
metadata:
  name: openshift-impexp
EOF

oc create -f - <<EOF
kind: ConfigMap
apiVersion: v1
metadata:
  name: rootconfig
  namespace: openshift-impexp
data:
$(sed -e 's/^/  /' /tmp/rootconfig)
EOF

docker run --dns=8.8.8.8 -i -v /root/.kube:/.kube:z -e KUBECONFIG=/.kube/config docker.io/jimminter/import:latest || true
