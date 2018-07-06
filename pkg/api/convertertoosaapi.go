package api

import (
	"github.com/Azure/acs-engine/pkg/api/osa/vlabs"
)

// ConvertContainerServiceToVLabsOpenShiftCluster converts from a
// ContainerService to a vlabs.OpenShiftCluster.
func ConvertContainerServiceToVLabsOpenShiftCluster(cs *ContainerService) *vlabs.OpenShiftCluster {
	oc := &vlabs.OpenShiftCluster{
		ID:       cs.ID,
		Location: cs.Location,
		Name:     cs.Name,
		Tags:     cs.Tags,
		Type:     cs.Type,
	}

	if cs.Plan != nil {
		oc.Plan = &vlabs.ResourcePurchasePlan{
			Name:          cs.Plan.Name,
			Product:       cs.Plan.Product,
			PromotionCode: cs.Plan.PromotionCode,
			Publisher:     cs.Plan.Publisher,
		}
	}

	if cs.Properties != nil {
		oc.Properties = &vlabs.Properties{
			ProvisioningState: vlabs.ProvisioningState(cs.Properties.ProvisioningState),
		}

		if cs.Properties.OrchestratorProfile != nil {
			oc.Properties.OpenShiftVersion = cs.Properties.OrchestratorProfile.OrchestratorVersion

			if cs.Properties.OrchestratorProfile.OpenShiftConfig != nil {
				oc.Properties.PublicHostname = cs.Properties.OrchestratorProfile.OpenShiftConfig.PublicHostname
				oc.Properties.RoutingConfigSubdomain = cs.Properties.OrchestratorProfile.OpenShiftConfig.RoutingConfigSubdomain
				oc.Properties.RoutingConfigFQDN = cs.Properties.OrchestratorProfile.OpenShiftConfig.RoutingConfigFQDN
			}
		}

		if cs.Properties.MasterProfile != nil {
			oc.Properties.FQDN = cs.Properties.MasterProfile.FQDN
		}

		if cs.Properties.ServicePrincipalProfile != nil {
			oc.Properties.ServicePrincipalProfile = vlabs.ServicePrincipalProfile{
				ClientID: cs.Properties.ServicePrincipalProfile.ClientID,
				Secret:   cs.Properties.ServicePrincipalProfile.Secret,
			}
		}

		oc.Properties.AgentPoolProfiles = make([]vlabs.AgentPoolProfile, 0, len(cs.Properties.AgentPoolProfiles))
		for _, app := range cs.Properties.AgentPoolProfiles {
			oc.Properties.AgentPoolProfiles = append(oc.Properties.AgentPoolProfiles,
				vlabs.AgentPoolProfile{
					Name:         app.Name,
					Count:        app.Count,
					VMSize:       app.VMSize,
					OSType:       vlabs.OSType(app.OSType),
					VnetSubnetID: app.VnetSubnetID,
					Role:         vlabs.AgentPoolProfileRole(app.Role),
				},
			)
		}
	}

	return oc
}
