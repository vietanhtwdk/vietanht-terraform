# Walkthrough - Modular OpenStack Terraform Infrastructure

I have successfully implemented the modular Terraform structure for managing multiple OpenStack VMs.

## Changes Made

### Root Configuration
- `providers.tf`: Configured the OpenStack provider.
- `variables.tf`: Defined input variables for authentication, networking, and VM configurations.
- `main.tf`: Orchestrated the calls to the network, security group, and VM modules.
- `outputs.tf`: Defined outputs for VM IPs and network IDs.
- `terraform.tfvars`: Provided a template for default variables.

### Modules
- **Network Module** (`modules/network/`): Creates a private network, subnet, router, and connects them to an external network.
- **Security Group Module** (`modules/security_group/`): Sets up a basic security group with SSH (22) and HTTP (80) access.
- **VM Module** (`modules/vm/`): Uses `for_each` to dynamically create multiple instances based on a map of VM configurations.

### Environment-Specific Settings
- Created three example `.tfvars` files in the `envs/` directory:
    - `dev.tfvars`
    - `staging.tfvars`
    - `prod.tfvars`

## Verification Results

### Automated Tests
- **Terraform Init**: Successfully initialized all modules and downloaded the OpenStack provider version **3.4.0**.
- **Terraform Validate**: Passed successfully, ensuring no syntax or logical errors in the configuration.

### Provider Upgrade (v3.4.0)
- Upgraded provider constraint to `~> 3.4.0`.
- Migrated security group resources from `openstack_compute_secgroup_v2` to `openstack_networking_secgroup_v2` and `openstack_networking_secgroup_rule_v2` for compatibility with the latest provider version.

### How to use
To plan or apply for a specific environment, use the following commands:

```powershell
# Dev environment
terraform plan -var-file="envs/dev.tfvars"
terraform apply -var-file="envs/dev.tfvars"

# Prod environment
terraform plan -var-file="envs/prod.tfvars"
```

> [!NOTE]
> Since Terraform was just installed, you may need to restart your terminal or use the full path to the executable if `terraform` is not recognized immediately in your PATH.
