# Implementation Plan - Modular OpenStack Terraform Infrastructure

This plan outlines the creation of a modular Terraform setup to manage multiple OpenStack virtual machines, following the directory structure requested by the user.

## Proposed Changes

### Core Infrastructure Files
These files set up the root configuration and orchestrate the modules.

#### [NEW] [providers.tf](file:///d:/code/vietanhtwdk-terraform/providers.tf)
Defines the OpenStack provider and required versions.

#### [NEW] [variables.tf](file:///d:/code/vietanhtwdk-terraform/variables.tf)
Defines root-level variables like `auth_url`, `region`, and configuration for VMs.

#### [NEW] [main.tf](file:///d:/code/vietanhtwdk-terraform/main.tf)
Calls the network, security group, and VM modules.

#### [NEW] [outputs.tf](file:///d:/code/vietanhtwdk-terraform/outputs.tf)
Aggregates outputs from modules (e.g., VM IP addresses).

### Network Module
Handles the creation of the virtual network environment.

#### [NEW] [modules/network/main.tf](file:///d:/code/vietanhtwdk-terraform/modules/network/main.tf)
Creates `openstack_networking_network_v2`, `openstack_networking_subnet_v2`, and `openstack_networking_router_v2`.

#### [NEW] [modules/network/variables.tf](file:///d:/code/vietanhtwdk-terraform/modules/network/variables.tf)
#### [NEW] [modules/network/outputs.tf](file:///d:/code/vietanhtwdk-terraform/modules/network/outputs.tf)

### Security Group Module
Manages access rules.

#### [NEW] [modules/security_group/main.tf](file:///d:/code/vietanhtwdk-terraform/modules/security_group/main.tf)
Creates `openstack_compute_secgroup_v2` with basic rules (SSH, HTTP/HTTPS).

#### [NEW] [modules/security_group/variables.tf](file:///d:/code/vietanhtwdk-terraform/modules/security_group/variables.tf)
#### [NEW] [modules/security_group/outputs.tf](file:///d:/code/vietanhtwdk-terraform/modules/security_group/outputs.tf)

### VM Module
Handles instance creation.

#### [NEW] [modules/vm/main.tf](file:///d:/code/vietanhtwdk-terraform/modules/vm/main.tf)
Uses `count` or `for_each` to create multiple `openstack_compute_instance_v2` resources.

#### [NEW] [modules/vm/variables.tf](file:///d:/code/vietanhtwdk-terraform/modules/vm/variables.tf)
#### [NEW] [modules/vm/outputs.tf](file:///d:/code/vietanhtwdk-terraform/modules/vm/outputs.tf)

### Environment Configurations
Specific values for different environments.

#### [NEW] [envs/dev.tfvars](file:///d:/code/vietanhtwdk-terraform/envs/dev.tfvars)
#### [NEW] [envs/staging.tfvars](file:///d:/code/vietanhtwdk-terraform/envs/staging.tfvars)
#### [NEW] [envs/prod.tfvars](file:///d:/code/vietanhtwdk-terraform/envs/prod.tfvars)

## Verification Plan

### Automated Tests
- Run `terraform init` to verify provider and module connectivity.
- Run `terraform validate` to check for syntax and logic errors.
- Run `terraform plan -var-file=envs/dev.tfvars` to simulate creation.

### Manual Verification
- Review the generated plan to ensure the correct number of VMs and networking components are scheduled for creation.
