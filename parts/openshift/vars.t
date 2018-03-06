    "gituser" : "kargakis",
    "branch" : "master",
    "version" : "3.7",
    "baseTemplateUrl" : "[concat('https://raw.githubusercontent.com/',variables('gituser'),'/acs-engine/',variables('branch'),'/parts/openshift/',variables('version'),'/')]",
    "baseVMachineTemplateUriInfranode" : "[concat(variables('baseTemplateUrl'), 'infranode.json')]",
    "baseVMachineTemplateUriNode" : "[concat(variables('baseTemplateUrl'), 'node.json')]",
    "baseVMachineTemplateUriMaster" : "[concat(variables('baseTemplateUrl'), 'master.json')]",
    "location" : "[resourceGroup().location]",
    "virtualNetworkName" : "openshiftVnet",
    "addressPrefix" : "10.0.0.0/16",
    "infranodesubnetName" : "infranodeSubnet",
    "infranodesubnetPrefix" : "10.0.2.0/24",
    "nodesubnetName" : "nodeSubnet",
    "nodesubnetPrefix" : "10.0.1.0/24",
    "mastersubnetName" : "masterSubnet",
    "mastersubnetPrefix" : "10.0.0.0/24",
    "infranodeStorageName" : "[concat('sainf', resourceGroup().name)]",
    "nodeStorageName" : "[concat('sanod', resourceGroup().name)]",
    "masterStorageName" : "[concat('samas', resourceGroup().name)]",
    "vhdStorageType" : "Premium_LRS",
    "vnetId" : "[resourceId('Microsoft.Network/virtualNetworks', variables('virtualNetworkName'))]",
    "infranodeSubnetRef" : "[concat(variables('vnetId'), '/subnets/', variables('infranodesubnetName'))]",
    "nodeSubnetRef" : "[concat(variables('vnetId'), '/subnets/', variables('nodesubnetName'))]",
    "masterSubnetRef" : "[concat(variables('vnetId'), '/subnets/', variables('mastersubnetName'))]",
    "rhel" : {
      "publisher" : "Redhat",
      "offer" : "RHEL",
      "sku" : "7-RAW",
      "version" : "latest"
    },
    "baseVMachineTemplateUriBastion" : "[concat(variables('baseTemplateUrl'), 'bastion.json')]",
    "vmSizesMap" : {
      "Standard_A2" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_A3" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_A4" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_A5" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_A6" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_A7" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_A8" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_A9" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_A10" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_A11" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_D1" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_D2" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_D3" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_D4" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_D11" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_D12" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_D13" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_D14" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_D1_v2" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_D2_v2" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_D3_v2" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_D4_v2" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_D5_v2" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_D11_v2" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_D12_v2" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_D13_v2" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_D14_v2" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_E2_v3" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_E4_v3" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_E8_v3" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_E16_v3" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_E32_v3" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_E64_v3" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_E2s_v3" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_E4s_v3" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_E8s_v3" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_E16s_v3" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_E32s_v3" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_E64s_v3" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_G1" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_G2" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_G3" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_G4" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_G5" : {
        "storageAccountType" : "Standard_LRS"
      },
      "Standard_DS1" : {
        "storageAccountType" : "Premium_LRS"
      },
      "Standard_DS2" : {
        "storageAccountType" : "Premium_LRS"
      },
      "Standard_DS3" : {
        "storageAccountType" : "Premium_LRS"
      },
      "Standard_DS4" : {
        "storageAccountType" : "Premium_LRS"
      },
      "Standard_DS11" : {
        "storageAccountType" : "Premium_LRS"
      },
      "Standard_DS12" : {
        "storageAccountType" : "Premium_LRS"
      },
      "Standard_DS13" : {
        "storageAccountType" : "Premium_LRS"
      },
      "Standard_DS14" : {
        "storageAccountType" : "Premium_LRS"
      },
      "Standard_DS1_v2" : {
        "storageAccountType" : "Premium_LRS"
      },
      "Standard_DS2_v2" : {
        "storageAccountType" : "Premium_LRS"
      },
      "Standard_DS3_v2" : {
        "storageAccountType" : "Premium_LRS"
      },
      "Standard_DS4_v2" : {
        "storageAccountType" : "Premium_LRS"
      },
      "Standard_DS5_v2" : {
        "storageAccountType" : "Premium_LRS"
      },
      "Standard_DS11_v2" : {
        "storageAccountType" : "Premium_LRS"
      },
      "Standard_DS12_v2" : {
        "storageAccountType" : "Premium_LRS"
      },
      "Standard_DS13_v2" : {
        "storageAccountType" : "Premium_LRS"
      },
      "Standard_DS14_v2" : {
        "storageAccountType" : "Premium_LRS"
      },
      "Standard_DS15_v2" : {
        "storageAccountType" : "Premium_LRS"
      },
      "Standard_GS1" : {
        "storageAccountType" : "Premium_LRS"
      },
      "Standard_GS2" : {
        "storageAccountType" : "Premium_LRS"
      },
      "Standard_GS3" : {
        "storageAccountType" : "Premium_LRS"
      },
      "Standard_GS4" : {
        "storageAccountType" : "Premium_LRS"
      },
      "Standard_GS5" : {
        "storageAccountType" : "Premium_LRS"
      }
    },
    "tenantId" : "[subscription().tenantId]",
    "bastionVMSize" : "Standard_DS1_v2",
    "masterLoadBalancerName" : "[concat('MasterLb',resourceGroup().name)]",
    "masterPublicIpAddressId" : "[resourceId('Microsoft.Network/publicIPAddresses', resourceGroup().name)]",
    "masterLbId" : "[resourceId('Microsoft.Network/loadBalancers', variables('masterLoadBalancerName'))]",
    "masterLbFrontEndConfigId" : "[concat(variables('masterLbId'), '/frontendIPConfigurations/loadBalancerFrontEnd')]",
    "masterLbBackendPoolId" : "[concat(variables('masterLbId'),'/backendAddressPools/loadBalancerBackend')]",
    "masterLbHttpProbeId" : "[concat(variables('masterLbId'),'/probes/httpProbe')]",
    "masterLb8443ProbeId" : "[concat(variables('masterLbId'),'/probes/8443Probe')]",
    "infraLoadBalancerName" : "[concat(parameters('WildcardZone'), 'lb')]",
    "infraPublicIpAddressId" : "[resourceId('Microsoft.Network/publicIPAddresses', parameters('WildcardZone'))]",
    "infraLbId" : "[resourceId('Microsoft.Network/loadBalancers', variables('infraLoadBalancerName'))]",
    "infraLbFrontEndConfigId" : "[concat(variables('infraLbId'), '/frontendIPConfigurations/loadBalancerFrontEnd')]",
    "infraLbBackendPoolId" : "[concat(variables('infraLbId'),'/backendAddressPools/loadBalancerBackend')]",
    "infraLbHttpProbeId" : "[concat(variables('infraLbId'),'/probes/httpProbe')]",
    "infraLbHttpsProbeId" : "[concat(variables('infraLbId'),'/probes/httpsProbe')]",
    "infraLbCockpitProbeId" : "[concat(variables('infraLbId'),'/probes/cockpitProbe')]",
    "StorageAccountPersistentVolume" : "[concat('sapv', resourceGroup().name)]",
    "StorageAccountLoggingMetricsVolumes" : "[concat('sapvlm', resourceGroup().name)]",
    "registryStorageName" : "[concat('sareg', resourceGroup().name)]",
    "subscriptionId" : "[subscription().subscriptionId]",
    "StorageAccountLoggingMetricsVolumesVolumeType" : "Premium_LRS",
    "apiVersion" : "2015-06-15",
    "apiVersionCompute" : "2015-06-15",
    "apiVersionNetwork" : "2016-03-30",
    "tmApiVersion" : "2015-11-01",
    "apiVersionStorage" : "2015-06-15",
    "apiVersionLinkTemplate" : "2015-01-01"
