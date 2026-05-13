# Walkthrough: Fixed IP Support via Dedicated Ports

I have updated the OpenStack Terraform configuration to support fixed IP addresses and direct port assignments for virtual machines. This is achieved by managing `openstack_networking_port_v2` resources for VMs that require a specific IP.

## Changes Made

### 1. VM Module: Managed Port Support
The `vm` module now conditionally creates `openstack_networking_port_v2` resources.

- **Port Creation**: A new `openstack_networking_port_v2` resource is created for any VM that has an `ip` field defined.
- **Security Groups**: Security groups are assigned directly to the port if a port is created/managed.
- **Instance Networking**: The `openstack_compute_instance_v2` resource now intelligently chooses how to connect to the network:
    - If `ip` is set: Uses the newly created `openstack_networking_port_v2` ID.
    - If `port_id` is set: Uses that existing port ID.
    - Otherwise: Fallback to the default `network_id` (uuid).

### 2. Module Communication
- Updated the root `main.tf` to pass the `security_group_id` output from the `security_group` module to the `vm` module. This allows the VM module to assign SGs to the managed ports.

### 3. Root Variables
- Added `ip` and `port_id` fields to the `vms` variable map.

## Verification Results

### Terraform Validation
Ran `terraform validate` successfully:
```text
Success! The configuration is valid.
```

## How to use

### To assign a fixed IP to a VM:
In your `terraform.tfvars`:
```hcl
vms = {
  "fixed-ip-vm" = {
    image_name  = "ubuntu-22.04"
    flavor_name = "m1.small"
    ip          = "192.168.1.50" # This will trigger port creation
  }
}
```

### To use an existing port:
```hcl
vms = {
  "existing-port-vm" = {
    image_name  = "ubuntu-22.04"
    flavor_name = "m1.small"
    port_id     = "uuid-of-existing-port"
  }
}
```
