    {
      "type" : "Microsoft.Storage/storageAccounts",
      "name" : "[variables('infranodeStorageName')]",
      "apiVersion" : "[variables('apiVersion')]",
      "location" : "[variables('location')]",
      "tags" : {
        "displayName" : "StorageAccount"
      },
      "properties" : {
        "accountType" : "[variables('vmSizesMap')[parameters('infranodeVMSize')].storageAccountType]"
      }
    },
    {
      "type" : "Microsoft.Storage/storageAccounts",
      "name" : "[variables('nodeStorageName')]",
      "apiVersion" : "[variables('apiVersion')]",
      "location" : "[variables('location')]",
      "tags" : {
        "displayName" : "StorageAccount"
      },
      "properties" : {
        "accountType" : "[variables('vmSizesMap')[parameters('nodeVmSize')].storageAccountType]"
      }
    },
    {
      "type" : "Microsoft.Storage/storageAccounts",
      "name" : "[variables('masterStorageName')]",
      "apiVersion" : "[variables('apiVersion')]",
      "location" : "[variables('location')]",
      "tags" : {
        "displayName" : "StorageAccount"
      },
      "properties" : {
        "accountType" : "[variables('vmSizesMap')[parameters('masterVMSize')].storageAccountType]"
      }
    },
    {
      "apiVersion" : "[variables('apiVersion')]",
      "type" : "Microsoft.Network/virtualNetworks",
      "name" : "[variables('virtualNetworkName')]",
      "location" : "[variables('location')]",
      "tags" : {
        "displayName" : "VirtualNetwork"
      },
      "properties" : {
        "addressSpace" : {
          "addressPrefixes" : [
            "[variables('addressPrefix')]"
          ]
        },
        "subnets" : [
          {
            "name" : "[variables('infranodesubnetName')]",
            "properties" : {
              "addressPrefix" : "[variables('infranodesubnetPrefix')]"
            }
          },
          {
            "name" : "[variables('nodesubnetName')]",
            "properties" : {
              "addressPrefix" : "[variables('nodesubnetPrefix')]"
            }
          },
          {
            "name" : "[variables('mastersubnetName')]",
            "properties" : {
              "addressPrefix" : "[variables('mastersubnetPrefix')]"
            }
          }
        ]
      }
    },
    {
      "name" : "[concat('nodeSet', copyindex())]",
      "type" : "Microsoft.Resources/deployments",
      "apiVersion" : "2015-01-01",
      "copy" : {
        "name" : "nodeSet",
        "count" : "[parameters('numberOfNodes')]"
      },
      "dependsOn" : [
        "[concat('Microsoft.Network/virtualNetworks/', variables('virtualNetworkName'))]",
        "[concat('Microsoft.Storage/storageAccounts/', variables('nodeStorageName'))]"
      ],
      "properties" : {
        "mode" : "Incremental",
        "templateLink" : {
          "uri" : "[variables('baseVMachineTemplateUriNode')]",
          "contentVersion" : "1.0.0.0"
        },
        "parameters" : {
          "vmName" : {
            "value" : "[concat('node', padLeft(add(copyindex(), 1), 2, '0'))]"
          },
          "sa" : {
            "value" : "[variables('nodeStorageName')]"
          },
          "subnetRef" : {
            "value" : "[variables('nodeSubnetRef')]"
          },
          "vmSize" : {
            "value" : "[parameters('nodeVMSize')]"
          },
          "adminUsername" : {
            "value" : "[parameters('adminUsername')]"
          },
          "sshKeyData" : {
            "value" : "[parameters('sshKeyData')]"
          },
          "baseTemplateUrl" : {
            "value" : "[variables('baseTemplateUrl')]"
          },
          "imageReference" : {
            "value" : "[variables(parameters('image'))]"
          },
          "availabilitySet" : {
            "value" : "['nodeavailabilityset']"
          }
        }
      }
    },
    {
      "name" : "bastion",
      "type" : "Microsoft.Resources/deployments",
      "apiVersion" : "2015-01-01",
      "dependsOn" : [
        "[concat('Microsoft.Network/virtualNetworks/', variables('virtualNetworkName'))]",
        "[concat('Microsoft.Storage/storageAccounts/', variables('masterStorageName'))]",
        "[concat('Microsoft.Storage/storageAccounts/', variables('registryStorageName'))]"
      ],
      "properties" : {
        "mode" : "Incremental",
        "templateLink" : {
          "uri" : "[variables('baseVMachineTemplateUriBastion')]",
          "contentVersion" : "1.0.0.0"
        },
        "parameters" : {
          "vmName" : {
            "value" : "bastion"
          },
          "dnsName" : {
            "value" : "[concat(resourceGroup().name,'b')]"
          },
          "sa" : {
            "value" : "[variables('masterStorageName')]"
          },
          "subnetRef" : {
            "value" : "[variables('masterSubnetRef')]"
          },
          "vmSize" : {
            "value" : "[variables('bastionVMSize')]"
          },
          "adminUsername" : {
            "value" : "[parameters('adminUsername')]"
          },
          "adminPassword" : {
            "value" : "[parameters('adminPassword')]"
          },
          "sshKeyData" : {
            "value" : "[parameters('sshKeyData')]"
          },
          "numberOfNodes" : {
            "value" : "[parameters('numberOfNodes')]"
          },
          "baseTemplateUrl" : {
            "value" : "[variables('baseTemplateUrl')]"
          },
          "routerExtIP" : {
            "value" : "[reference(parameters('WildcardZone')).ipAddress]"
          },
          "imageReference" : {
            "value" : "[variables(parameters('image'))]"
          },
          "RHNUserName" : {
            "value" : "[parameters('RHNUserName')]"
          },
          "RHNPassword" : {
            "value" : "[parameters('RHNPassword')]"
          },
          "SubscriptionPoolId" : {
            "value" : "[parameters('SubscriptionPoolId')]"
          },
          "sshPrivateData" : {
            "value" : "[parameters('sshPrivateData')]"
          },
          "wildcardZone" : {
            "value" : "[parameters('WildcardZone')]"
          },
          "registrystoragename" : {
            "value" : "[variables('registryStorageName')]"
          },
          "registrykey" : {
            "value" : "[listKeys(resourceId('Microsoft.Storage/storageAccounts',variables('registryStorageName')),'2015-06-15').key1]"
          },
          "location" : {
            "value" : "[variables('location')]"
          },
          "subscriptionid" : {
            "value" : "[variables('subscriptionId')]"
          },
          "tenantid" : {
            "value" : "[variables('tenantId')]"
          },
          "aadclientid" : {
            "value" : "[parameters('aadClientId')]"
          },
          "aadclientsecret" : {
            "value" : "[parameters('aadClientSecret')]"
          },
          "rhsmmode" : {
            "value" : "[parameters('rhsmUsernamePasswordOrActivationKey')]"
          },
          "openshiftsdn" : {
            "value" : "[parameters('OpenShiftSDN')]"
          },
          "metrics" : {
            "value" : "[parameters('metrics')]"
          },
          "logging" : {
            "value" : "[parameters('logging')]"
          },
          "opslogging" : {
            "value" : "[parameters('opslogging')]"
          }
        }
      }
    },
    {
      "name" : "master1",
      "type" : "Microsoft.Resources/deployments",
      "apiVersion" : "2015-01-01",
      "dependsOn" : [
        "[concat('Microsoft.Network/virtualNetworks/', variables('virtualNetworkName'))]",
        "[concat('Microsoft.Storage/storageAccounts/', variables('masterStorageName'))]"
      ],
      "properties" : {
        "mode" : "Incremental",
        "templateLink" : {
          "uri" : "[variables('baseVMachineTemplateUriMaster')]",
          "contentVersion" : "1.0.0.0"
        },
        "parameters" : {
          "vmName" : {
            "value" : "master1"
          },
          "dnsName" : {
            "value" : "[concat(resourceGroup().name,'m1')]"
          },
          "sa" : {
            "value" : "[variables('masterStorageName')]"
          },
          "subnetRef" : {
            "value" : "[variables('masterSubnetRef')]"
          },
          "vmSize" : {
            "value" : "[parameters('masterVMSize')]"
          },
          "adminUsername" : {
            "value" : "[parameters('adminUsername')]"
          },
          "sshKeyData" : {
            "value" : "[parameters('sshKeyData')]"
          },
          "baseTemplateUrl" : {
            "value" : "[variables('baseTemplateUrl')]"
          },
          "imageReference" : {
            "value" : "[variables(parameters('image'))]"
          },
          "sshPrivateData" : {
            "value" : "[parameters('sshPrivateData')]"
          },
          "masterLoadBalancerName" : {
            "value" : "[variables('masterLoadBalancerName')]"
          },
          "availabilitySet" : {
            "value" : "['masteravailabilityset']"
          }
        }
      }
    },
    {
      "name" : "infranode1",
      "type" : "Microsoft.Resources/deployments",
      "apiVersion" : "2015-01-01",
      "dependsOn" : [
        "[concat('Microsoft.Network/virtualNetworks/', variables('virtualNetworkName'))]",
        "[concat('Microsoft.Storage/storageAccounts/', variables('infranodeStorageName'))]"
      ],
      "properties" : {
        "mode" : "Incremental",
        "templateLink" : {
          "uri" : "[variables('baseVMachineTemplateUriInfranode')]",
          "contentVersion" : "1.0.0.0"
        },
        "parameters" : {
          "vmName" : {
            "value" : "infranode1"
          },
          "sa" : {
            "value" : "[variables('infranodeStorageName')]"
          },
          "subnetRef" : {
            "value" : "[variables('infranodeSubnetRef')]"
          },
          "vmSize" : {
            "value" : "[parameters('infranodeVMSize')]"
          },
          "adminUsername" : {
            "value" : "[parameters('adminUsername')]"
          },
          "sshKeyData" : {
            "value" : "[parameters('sshKeyData')]"
          },
          "baseTemplateUrl" : {
            "value" : "[variables('baseTemplateUrl')]"
          },
          "imageReference" : {
            "value" : "[variables(parameters('image'))]"
          },
          "dnsName" : {
            "value" : "[concat(resourceGroup().name,'i1')]"
          },
          "LoadBalancerName" : {
            "value" : "[variables('infraLoadBalancerName')]"
          },
          "availabilitySet" : {
            "value" : "['infranodeavailabilityset']"
          }
        }
      }
    },
    {
      "type" : "Microsoft.Storage/storageAccounts",
      "name" : "[variables('registryStorageName')]",
      "apiVersion" : "[variables('apiVersion')]",
      "location" : "[variables('location')]",
      "tags" : {
        "displayName" : "StorageAccount"
      },
      "properties" : {
        "accountType" : "['Standard_RAGRS']"
      }
    },
    {
      "type" : "Microsoft.Storage/storageAccounts",
      "name" : "[variables('StorageAccountPersistentVolume')]",
      "apiVersion" : "[variables('apiVersion')]",
      "location" : "[variables('location')]",
      "tags" : {
        "displayName" : "StorageAccountPersistentVolume"
      },
      "properties" : {
        "accountType" : "[variables('vmSizesMap')[parameters('nodeVmSize')].storageAccountType]"
      }
    },
    {
      "type" : "Microsoft.Storage/storageAccounts",
      "name" : "[variables('StorageAccountLoggingMetricsVolumes')]",
      "apiVersion" : "[variables('apiVersion')]",
      "location" : "[variables('location')]",
      "tags" : {
        "displayName" : "StorageAccountLoggingMetricsVolumes"
      },
      "properties" : {
        "accountType" : "[variables('StorageAccountLoggingMetricsVolumesVolumeType')]"
      }
    },
    {
      "type" : "Microsoft.Compute/availabilitySets",
      "name" : "masteravailabilityset",
      "location" : "[variables('location')]",
      "apiVersion" : "[variables('apiVersionCompute')]",
      "properties" : {}
    },
    {
      "type" : "Microsoft.Compute/availabilitySets",
      "name" : "infranodeavailabilityset",
      "location" : "[variables('location')]",
      "apiVersion" : "[variables('apiVersionCompute')]",
      "properties" : {}
    },
    {
      "type" : "Microsoft.Network/publicIPAddresses",
      "name" : "[parameters('WildcardZone')]",
      "location" : "[variables('location')]",
      "apiVersion" : "[variables('apiVersionNetwork')]",
      "tags" : {
        "displayName" : "OpenShiftInfraLBPublicIP"
      },
      "properties" : {
        "publicIPAllocationMethod" : "Static",
        "dnsSettings" : {
          "domainNameLabel" : "[parameters('WildcardZone')]"
        }
      }
    },
    {
      "type" : "Microsoft.Compute/availabilitySets",
      "name" : "nodeavailabilityset",
      "location" : "[variables('location')]",
      "apiVersion" : "[variables('apiVersionCompute')]",
      "properties" : {}
    },
    {
      "type" : "Microsoft.Network/publicIPAddresses",
      "name" : "[resourceGroup().name]",
      "location" : "[variables('location')]",
      "apiVersion" : "[variables('apiVersionNetwork')]",
      "tags" : {
        "displayName" : "OpenShiftMasterPublicIP"
      },
      "properties" : {
        "publicIPAllocationMethod" : "Static",
        "dnsSettings" : {
          "domainNameLabel" : "[resourceGroup().name]"
        }
      }
    },
    {
      "type" : "Microsoft.Network/loadBalancers",
      "name" : "[variables('masterLoadBalancerName')]",
      "location" : "[variables('location')]",
      "apiVersion" : "[variables('apiVersionNetwork')]",
      "tags" : {
        "displayName" : "OpenShiftMasterLB"
      },
      "dependsOn" : [
        "[concat('Microsoft.Network/publicIPAddresses/', resourceGroup().name)]"
      ],
      "properties" : {
        "frontendIPConfigurations" : [
          {
            "name" : "LoadBalancerFrontEnd",
            "properties" : {
              "publicIPAddress" : {
                "id" : "[variables('masterPublicIpAddressId')]"
              }
            }
          }
        ],
        "backendAddressPools" : [
          {
            "name" : "loadBalancerBackEnd"
          }
        ],
        "loadBalancingRules" : [
          {
            "name" : "OpenShiftAdminConsole",
            "properties" : {
              "frontendIPConfiguration" : {
                "id" : "[variables('masterLbFrontEndConfigId')]"
              },
              "backendAddressPool" : {
                "id" : "[variables('masterLbBackendPoolId')]"
              },
              "protocol" : "Tcp",
              "loadDistribution" : "SourceIP",
              "idleTimeoutInMinutes" : 30,
              "frontendPort" : 8443,
              "backendPort" : 8443,
              "probe" : {
                "id" : "[variables('masterLb8443ProbeId')]"
              }
            }
          }
        ],
        "probes" : [
          {
            "name" : "8443Probe",
            "properties" : {
              "protocol" : "Tcp",
              "port" : 8443,
              "intervalInSeconds" : 5,
              "numberOfProbes" : 2
            }
          }
        ]
      }
    },
    {
      "type" : "Microsoft.Network/loadBalancers",
      "name" : "[variables('infraLoadBalancerName')]",
      "location" : "[variables('location')]",
      "apiVersion" : "[variables('apiVersionNetwork')]",
      "tags" : {
        "displayName" : "OpenShiftMasterLB"
      },
      "dependsOn" : [
        "[concat('Microsoft.Network/publicIPAddresses/', parameters('WildcardZone'))]"
      ],
      "properties" : {
        "frontendIPConfigurations" : [
          {
            "name" : "LoadBalancerFrontEnd",
            "properties" : {
              "publicIPAddress" : {
                "id" : "[variables('infraPublicIpAddressId')]"
              }
            }
          }
        ],
        "backendAddressPools" : [
          {
            "name" : "loadBalancerBackEnd"
          }
        ],
        "loadBalancingRules" : [
          {
            "name" : "OpenShiftRouterHTTP",
            "properties" : {
              "frontendIPConfiguration" : {
                "id" : "[variables('infraLbFrontEndConfigId')]"
              },
              "backendAddressPool" : {
                "id" : "[variables('infraLbBackendPoolId')]"
              },
              "protocol" : "Tcp",
              "frontendPort" : 80,
              "backendPort" : 80,
              "probe" : {
                "id" : "[variables('infraLbHttpProbeId')]"
              }
            }
          },
          {
            "name" : "OpenShiftRouterHTTPS",
            "properties" : {
              "frontendIPConfiguration" : {
                "id" : "[variables('infraLbFrontEndConfigId')]"
              },
              "backendAddressPool" : {
                "id" : "[variables('infraLbBackendPoolId')]"
              },
              "protocol" : "Tcp",
              "frontendPort" : 443,
              "backendPort" : 443,
              "probe" : {
                "id" : "[variables('infraLbHttpsProbeId')]"
              }
            }
          }
        ],
        "probes" : [
          {
            "name" : "httpProbe",
            "properties" : {
              "protocol" : "Tcp",
              "port" : 80,
              "intervalInSeconds" : 5,
              "numberOfProbes" : 2
            }
          },
          {
            "name" : "httpsProbe",
            "properties" : {
              "protocol" : "Tcp",
              "port" : 443,
              "intervalInSeconds" : 5,
              "numberOfProbes" : 2
            }
          }
        ]
      }
    }
