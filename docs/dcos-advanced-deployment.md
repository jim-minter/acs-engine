# Modification of acs-engine for advanced deployment technique
## Problem Definition:

The current method of deployment for dc/os uses a custom deployment process based on the generated cloud config. 
This has several limitations:
- The resulting cluster can not be updated
- The resulting cluster must use only the default bootstrap package. 

As a result of this, acs-engine's usefulness is severely limited in production or CI environments.

CI is hampered by the fact that the linux members of the cluster will be provisioned with the component packages
specified in the custom data compiled into acs-engine, so retargeting the installation to a test package set 
is not possible unless acs-engine is recompiled with new custom data. The config yaml differences recently introduced 
into dc/os 1.11 now also make that information incompatible with previous versions of dc/os. 

Production use of the cluster is hampered by the lack of updatability.  The arrangment used will fix the
configuration to using a single set of packages based on a predete4rmined build id.  There is no provision to 
change those packages, so the only way to update the cluster is to destroy it and build another,
creating a technical challenge to maintaining service continuity.

Mesosphere recommends a different deployment methodology described 
[here](https://docs.mesosphere.com/1.7/administration/installing/oss/custom/advanced/). This technique has a
bootstrap node which d 


