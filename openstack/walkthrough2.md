# Walkthrough: Network Import and Optional Security Groups

I have updated the OpenStack Terraform configuration to allow using an existing network (import) and to make the creation and assignment of security groups optional.

## Changes Made

### 1. Network Module (Import Support)
The `network` module now supports an optional `network_id`. If provided, the module skips the creation of all networking resources (network, subnet, router, interface) and instead outputs the provided ID.

- **Resources**: Added `count = var.network_id == null ? 1 : 0` to all resources.
- **Variables**: Added `network_id` and made `cidr`, `gateway_ip`, and `external_network_id` optional.
- **Outputs**: Updated `network_id` output to return the imported ID if available.

### 2. Security Group Module (Optional Creation)
The `security_group` module now has an `enabled` flag.

- **Resources**: Added `count = var.enabled ? 1 : 0` to the security group and its rules.
- **Outputs**: Updated `sg_name` and `sg_id` outputs to return `null` if the module is disabled.

### 3. VM Module (Optional SG Assignment)
The VM module now handles cases where no security group is provided.

- **Variables**: Made `security_group_name` optional (defaults to `null`).
- **Logic**: Updated the `security_groups` list to be empty if `security_group_name` is `null`.

### 4. Root Module Updates
- Added `create_security_group` variable (defaults to `true`).
- Updated `network_config` object to include an optional `id` field.
- Updated module calls to pass these new parameters.

## Verification Results

### Terraform Validation
Ran `terraform validate` successfully:
```text
Success! The configuration is valid.
```

## How to use

### To import an existing network:
In your `terraform.tfvars`:
```hcl
network_config = {
  name = "existing-net"
  id   = "uuid-of-existing-network"
  # cidr, gateway_ip, external_net can be omitted
}
```

### To skip security group creation:
```hcl
create_security_group = false
```
