# Robust Networking with Ports and Fixed IPs

This plan implements support for fixed IP addresses by creating `openstack_networking_port_v2` resources. It also allows VMs to be directly attached to pre-existing ports.

## Proposed Changes

### Root Module

#### [MODIFY] [variables.tf](file:///d:/code/vietanhtwdk-terraform/openstack/variables.tf)
- Update the `vms` variable definition to include optional `port_id` and `ip` fields.

#### [MODIFY] [main.tf](file:///d:/code/vietanhtwdk-terraform/openstack/main.tf)
- Pass `security_group_id` to the `vm` module.

### VM Module

#### [MODIFY] [variables.tf](file:///d:/code/vietanhtwdk-terraform/openstack/modules/vm/variables.tf)
- Update the `vms` variable definition to include optional `port_id` and `ip` fields.
- Add a `security_group_id` variable.

#### [MODIFY] [main.tf](file:///d:/code/vietanhtwdk-terraform/openstack/modules/vm/main.tf)
- Add `resource "openstack_networking_port_v2" "vm_port"`:
    - Use `for_each` to create ports for VMs that have an `ip` specified.
    - Assign the `security_group_ids` if provided.
- Update `openstack_compute_instance_v2`:
    - Use a conditional `network` block configuration:
        - If `port_id` is provided, use that port.
        - If `ip` is provided, use the ID of the newly created `openstack_networking_port_v2`.
        - If neither is provided, use `uuid = var.network_id` and assign `security_groups` directly to the VM.

## Verification Plan

### Automated Tests
- Run `terraform validate`.
- Test case 1: VM with fixed `ip` (port should be created).
- Test case 2: VM with existing `port_id`.
- Test case 3: Standard VM (uses `network_id`).

### Manual Verification
- Review `terraform plan` to confirm `openstack_networking_port_v2` is created for fixed-IP VMs and that the VM resource points to the correct port or network.
