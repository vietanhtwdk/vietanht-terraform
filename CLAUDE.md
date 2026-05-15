# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repository Is

Terraform modules for provisioning OpenStack infrastructure. All Terraform code lives under `openstack/`.

## Common Commands

```bash
# Initialize (run from openstack/ directory)
terraform init

# Plan against a specific environment
terraform plan -var-file=envs/dev.tfvars
terraform plan -var-file=envs/staging.tfvars
terraform plan -var-file=envs/prod.tfvars

# Apply
terraform apply -var-file=envs/dev.tfvars

# Validate syntax and configuration
terraform validate

# Format code (check only)
terraform fmt -check -recursive

# Format code (write)
terraform fmt -recursive
```

OpenStack credentials (auth_url, tenant_name, user_name, password, etc.) must be supplied at plan/apply time — they have no defaults in the repo and are not committed.

## Architecture

```
openstack/
├── main.tf          # Root module orchestration — wires the four modules together
├── variables.tf     # Root inputs: auth, network config, vms map, volumes map
├── outputs.tf       # vm_ips, network_id
├── providers.tf     # OpenStack provider v3.4.0, requires Terraform >= 1.0.0
├── terraform.tfvars # Non-secret defaults: region=RegionOne, domain_name=Default
├── envs/            # Per-environment overrides: dev.tfvars, staging.tfvars, prod.tfvars
├── modules/
│   ├── network/        # Creates or references an existing OpenStack network+subnet+router
│   ├── security_group/ # Creates a security group (SSH+HTTP ingress); can be disabled
│   ├── volume/         # Creates Cinder volumes, resolves image names to IDs dynamically
│   └── vm/             # Creates ports (for fixed IPs) and compute instances
└── tests/
    └── integration_test.tf   # Sample config pointing at localhost:5000 mock endpoint
```

### Module Relationships

The root `main.tf` chains modules in this order:

1. **network** → produces `network_id`, `subnet_id`
2. **security_group** → produces `sg_name`, `sg_id`
3. **volume** → produces `volume_ids` map (name → ID)
4. **vm** → consumes `network_id`, `sg_name`/`sg_id`, and resolved `volume_ids`

### Smart Volume Handling (root main.tf locals)

Two locals merge volume sources before passing to the `volume` module:
- `auto_volumes`: synthesized from VMs that declare `volume_size` inline (shorthand)
- `all_volumes`: merges `var.volumes` with `auto_volumes`

This means a VM entry can use `volume_size = 20` instead of defining a separate entry in `var.volumes`.

### VM Module Networking Strategies

A VM can attach to the network in three ways (mutually exclusive, evaluated in order by conditional `count`/`for_each` logic):
1. **`port_id`** provided directly — uses a pre-created port
2. **`ip`** provided — a dedicated port is created with that fixed IP, then attached
3. **Neither** — VM attaches directly to `network_id` with a dynamic IP

### Conditional Resource Creation

- **network module**: skips creation if `var.network_id` is already provided (uses existing network)
- **security_group module**: controlled by `var.enabled` boolean (default true)
- **volume module**: image lookup is conditional per-volume based on whether `image_name` is set

## Key Variable Shapes

### `vms` map (root variable)

```hcl
vms = {
  "my-vm" = {
    flavor_name      = "m1.small"        # required
    image_name       = "Ubuntu-20.04"    # optional; mutually exclusive with volume_id
    key_pair         = "my-key"          # optional
    ip               = "192.168.1.10"    # optional; triggers port creation
    port_id          = "uuid..."         # optional; bypasses port creation
    volume_id        = "uuid..."         # optional; boot from existing volume
    volume_size      = 20                # optional shorthand; auto-creates a boot volume
    extra_volume_ids = ["uuid..."]       # optional; additional block devices
  }
}
```

### `volumes` map (root variable)

```hcl
volumes = {
  "data-vol" = {
    size       = 50              # required (GB)
    image_name = "Ubuntu-20.04" # optional; initializes volume from image
  }
}
```
