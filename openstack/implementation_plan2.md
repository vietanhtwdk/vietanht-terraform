# Network Import and Optional Security Groups

This plan enables the use of existing OpenStack networks instead of creating new ones and makes the creation and assignment of security groups optional.

## Proposed Changes

### Root Module

#### [MODIFY] [variables.tf](file:///d:/code/vietanhtwdk-terraform/openstack/variables.tf)
- Update `network_config` to include an optional `id` field.
- Add `create_security_group` (optional bool) to the root variables.

#### [MODIFY] [main.tf](file:///d:/code/vietanhtwdk-terraform/openstack/main.tf)
- Pass `id` from `network_config` to the network module.
- Pass `create_security_group` to the security group module.

### Network Module

#### [MODIFY] [variables.tf](file:///d:/code/vietanhtwdk-terraform/openstack/modules/network/variables.tf)
- Add `network_id` (optional string).
- Make `cidr`, `gateway_ip`, and `external_network_id` optional.

#### [MODIFY] [main.tf](file:///d:/code/vietanhtwdk-terraform/openstack/modules/network/main.tf)
- Add `count = var.network_id == null ? 1 : 0` to all resources.

#### [MODIFY] [outputs.tf](file:///d:/code/vietanhtwdk-terraform/openstack/modules/network/outputs.tf)
- Update `network_id` and `subnet_id` outputs to use conditional logic (returning null for subnet if network is imported).

### Security Group Module

#### [MODIFY] [variables.tf](file:///d:/code/vietanhtwdk-terraform/openstack/modules/security_group/variables.tf)
- Add `enabled` (optional bool).

#### [MODIFY] [main.tf](file:///d:/code/vietanhtwdk-terraform/openstack/modules/security_group/main.tf)
- Add `count = var.enabled ? 1 : 0` to all resources.

#### [MODIFY] [outputs.tf](file:///d:/code/vietanhtwdk-terraform/openstack/modules/security_group/outputs.tf)
- Update `sg_name` output to return `null` if disabled.

### VM Module

#### [MODIFY] [variables.tf](file:///d:/code/vietanhtwdk-terraform/openstack/modules/vm/variables.tf)
- Make `security_group_name` optional.

#### [MODIFY] [main.tf](file:///d:/code/vietanhtwdk-terraform/openstack/modules/vm/main.tf)
- Update `security_groups` attribute to handle `null` values by using an empty list.

## Verification Plan

### Automated Tests
- Run `terraform validate` to ensure syntax is correct.
- Test case 1: Create everything (default behavior).
- Test case 2: Provide `network_id` and set `create_security_group = false`.

### Manual Verification
- Verify `terraform plan` output for both test cases.
