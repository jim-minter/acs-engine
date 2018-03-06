    "adminUsername" : {
      "type" : "string",
      "minLength" : 1,
      "metadata" : {
        "description" : "User name for the Virtual Machine and OpenShift Webconsole."
      }
    },
    "adminPassword" : {
      "type" : "securestring",
      "metadata" : {
        "description" : "User password for the OpenShift Webconsole"
      }
    },
    "sshKeyData" : {
      "type" : "securestring",
      "metadata" : {
        "description" : "SSH RSA public key file as a string."
      }
    },
    "WildcardZone" : {
      "type" : "string",
      "minLength" : 1,
      "metadata" : {
        "description" : "Globally unique wildcard DNS domain for app access."
      }
    },
    "numberOfNodes" : {
      "type" : "int",
      "defaultValue" : 1,
      "minValue" : 1,
      "maxValue" : 30,
      "metadata" : {
        "description" : "Number of OpenShift Nodes to deploy (max 30)"
      }
    },
    "image" : {
      "type" : "string",
      "allowedValues" : [
        "rhel"
      ],
      "defaultValue" : "rhel",
      "metadata" : {
        "description" : "OS to use.Red Hat Enterprise Linux"
      }
    },
    "masterVMSize" : {
      "type" : "string",
      "defaultValue" : "Standard_DS4_v2",
      "allowedValues" : [
        "Standard_A2",
        "Standard_A3",
        "Standard_A4",
        "Standard_A5",
        "Standard_A6",
        "Standard_A7",
        "Standard_A8",
        "Standard_A9",
        "Standard_A10",
        "Standard_A11",
        "Standard_D2",
        "Standard_D3",
        "Standard_D4",
        "Standard_D11",
        "Standard_D12",
        "Standard_D13",
        "Standard_D14",
        "Standard_D2_v2",
        "Standard_D3_v2",
        "Standard_D4_v2",
        "Standard_D5_v2",
        "Standard_D11_v2",
        "Standard_D12_v2",
        "Standard_D13_v2",
        "Standard_D14_v2",
        "Standard_E2_v3",
        "Standard_E4_v3",
        "Standard_E8_v3",
        "Standard_E16_v3",
        "Standard_E32_v3",
        "Standard_E64_v3",
        "Standard_E2s_v3",
        "Standard_E4s_v3",
        "Standard_E8s_v3",
        "Standard_E16s_v3",
        "Standard_E32s_v3",
        "Standard_E64s_v3",
        "Standard_G1",
        "Standard_G2",
        "Standard_G3",
        "Standard_G4",
        "Standard_G5",
        "Standard_DS2",
        "Standard_DS3",
        "Standard_DS4",
        "Standard_DS11",
        "Standard_DS12",
        "Standard_DS13",
        "Standard_DS14",
        "Standard_DS2_v2",
        "Standard_DS3_v2",
        "Standard_DS4_v2",
        "Standard_DS5_v2",
        "Standard_DS11_v2",
        "Standard_DS12_v2",
        "Standard_DS13_v2",
        "Standard_DS14_v2",
        "Standard_GS1",
        "Standard_GS2",
        "Standard_GS3",
        "Standard_GS4",
        "Standard_GS5"
      ],
      "metadata" : {
        "description" : "The size of the Master Virtual Machine."
      }
    },
    "infranodeVMSize" : {
      "type" : "string",
      "defaultValue" : "Standard_DS4_v2",
      "allowedValues" : [
        "Standard_A2",
        "Standard_A3",
        "Standard_A4",
        "Standard_A5",
        "Standard_A6",
        "Standard_A7",
        "Standard_A8",
        "Standard_A9",
        "Standard_A10",
        "Standard_A11",
        "Standard_D2",
        "Standard_D3",
        "Standard_D4",
        "Standard_D11",
        "Standard_D12",
        "Standard_D13",
        "Standard_D14",
        "Standard_D2_v2",
        "Standard_D3_v2",
        "Standard_D4_v2",
        "Standard_D5_v2",
        "Standard_D11_v2",
        "Standard_D12_v2",
        "Standard_D13_v2",
        "Standard_D14_v2",
        "Standard_E2_v3",
        "Standard_E4_v3",
        "Standard_E8_v3",
        "Standard_E16_v3",
        "Standard_E32_v3",
        "Standard_E64_v3",
        "Standard_E2s_v3",
        "Standard_E4s_v3",
        "Standard_E8s_v3",
        "Standard_E16s_v3",
        "Standard_E32s_v3",
        "Standard_E64s_v3",
        "Standard_G1",
        "Standard_G2",
        "Standard_G3",
        "Standard_G4",
        "Standard_G5",
        "Standard_DS2",
        "Standard_DS3",
        "Standard_DS4",
        "Standard_DS11",
        "Standard_DS12",
        "Standard_DS13",
        "Standard_DS14",
        "Standard_DS2_v2",
        "Standard_DS3_v2",
        "Standard_DS4_v2",
        "Standard_DS5_v2",
        "Standard_DS11_v2",
        "Standard_DS12_v2",
        "Standard_DS13_v2",
        "Standard_DS14_v2",
        "Standard_GS1",
        "Standard_GS2",
        "Standard_GS3",
        "Standard_GS4",
        "Standard_GS5"
      ],
      "metadata" : {
        "description" : "The size of the Infranode Virtual Machine."
      }
    },
    "nodeVMSize" : {
      "type" : "string",
      "defaultValue" : "Standard_DS4_v2",
      "allowedValues" : [
        "Standard_A2",
        "Standard_A3",
        "Standard_A4",
        "Standard_A5",
        "Standard_A6",
        "Standard_A7",
        "Standard_A8",
        "Standard_A9",
        "Standard_A10",
        "Standard_A11",
        "Standard_D2",
        "Standard_D3",
        "Standard_D4",
        "Standard_D11",
        "Standard_D12",
        "Standard_D13",
        "Standard_D14",
        "Standard_D2_v2",
        "Standard_D3_v2",
        "Standard_D4_v2",
        "Standard_D5_v2",
        "Standard_D11_v2",
        "Standard_D12_v2",
        "Standard_D13_v2",
        "Standard_D14_v2",
        "Standard_E2_v3",
        "Standard_E4_v3",
        "Standard_E8_v3",
        "Standard_E16_v3",
        "Standard_E32_v3",
        "Standard_E64_v3",
        "Standard_E2s_v3",
        "Standard_E4s_v3",
        "Standard_E8s_v3",
        "Standard_E16s_v3",
        "Standard_E32s_v3",
        "Standard_E64s_v3",
        "Standard_G1",
        "Standard_G2",
        "Standard_G3",
        "Standard_G4",
        "Standard_G5",
        "Standard_DS2",
        "Standard_DS3",
        "Standard_DS4",
        "Standard_DS11",
        "Standard_DS12",
        "Standard_DS13",
        "Standard_DS14",
        "Standard_DS2_v2",
        "Standard_DS3_v2",
        "Standard_DS4_v2",
        "Standard_DS5_v2",
        "Standard_DS11_v2",
        "Standard_DS12_v2",
        "Standard_DS13_v2",
        "Standard_DS14_v2",
        "Standard_GS1",
        "Standard_GS2",
        "Standard_GS3",
        "Standard_GS4",
        "Standard_GS5"
      ],
      "metadata" : {
        "description" : "The size of the each Node Virtual Machine."
      }
    },
    "rhsmUsernamePasswordOrActivationKey" : {
      "type" : "string",
      "minLength" : 1,
      "defaultValue" : "usernamepassword",
      "allowedValues" : [
        "usernamepassword",
        "activationkey"
      ],
      "metadata" : {
        "description" : "Select whether you want to use your Red Hat Subscription Manager Username and Password or Organization ID and Activation Key to register the RHEL instance to your Red Hat Subscription."
      }
    },
    "RHNUserName" : {
      "type" : "string",
      "minLength" : 1,
      "metadata" : {
        "description" : "Red Hat Subscription User Name or Email Address or Organization ID"
      }
    },
    "RHNPassword" : {
      "type" : "securestring",
      "metadata" : {
        "description" : "Red Hat Subscription Password or Activation Key"
      }
    },
    "SubscriptionPoolId" : {
      "type" : "string",
      "minLength" : 1,
      "metadata" : {
        "description" : "Pool ID of the Red Hat subscritpion to use"
      }
    },
    "sshPrivateData" : {
      "type" : "securestring",
      "metadata" : {
        "description" : "SSH RSA private key file as a base64 string."
      }
    },
    "aadClientId" : {
      "type" : "string",
      "metadata" : {
        "description" : "Azure AD Client Id"
      }
    },
    "aadClientSecret" : {
      "type" : "securestring",
      "metadata" : {
        "description" : "Azure AD Client Secret"
      }
    },
    "OpenShiftSDN" : {
      "type" : "string",
      "defaultValue" : "redhat/openshift-ovs-multitenant",
      "allowedValues" : [
        "redhat/openshift-ovs-subnet",
        "redhat/openshift-ovs-multitenant"
      ],
      "metadata" : {
        "description" : "The supported SDN plugin to be used in OCP."
      }
    },
    "metrics" : {
      "type" : "bool",
      "defaultValue" : true,
      "metadata" : {
        "description" : "Enable OCP metrics"
      }
    },
    "logging" : {
      "type" : "bool",
      "defaultValue" : true,
      "metadata" : {
        "description" : "Enable OCP aggregated logging"
      }
    },
    "opslogging" : {
      "type" : "bool",
      "defaultValue" : false,
      "metadata" : {
        "description" : "Enable OCP aggregated logging for ops"
      }
    }
