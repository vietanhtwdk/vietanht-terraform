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
├── variables.tf     # Root inputs: auth, networks map, security_groups map, vms map, volumes map
├── outputs.tf       # vm_ips, network_ids
├── providers.tf     # OpenStack provider v3.4.0, requires Terraform >= 1.0.0
├── terraform.tfvars # Non-secret defaults: region=RegionOne, domain_name=Default
├── envs/            # Per-environment overrides: dev.tfvars, staging.tfvars, prod.tfvars
├── modules/
│   ├── network/        # Creates or references an existing OpenStack network+subnet+router
│   ├── security_group/ # Creates security groups with configurable rules; can reference existing SGs by ID
│   ├── volume/         # Creates Cinder volumes, resolves image names to IDs dynamically
│   └── vm/             # Creates ports and compute instances; all SG assignment is port-level
└── tests/
    └── integration_test.tf   # Sample config pointing at localhost:5000 mock endpoint
```

### Module Relationships

The root `main.tf` chains modules in this order:

1. **networks** (for_each) → produces `network_ids` map (label → ID)
2. **security_group** → produces `security_group_ids` map (label → ID)
3. Root locals resolve `network_ids` and `security_group_ids` into each VM's `ports` and `security_group_ids`
4. **volume** → produces `volume_ids` map (name → ID)
5. **vm** → consumes fully-resolved VM objects (ports with network_id, security_group_ids)

### Multi-Network Support

`var.networks` is a map; the root calls `module "networks"` with `for_each`. Each network entry can either create a new network or reference an existing one (`id` provided). VMs reference networks by label via their `ports[*].network_name`.

### Multi-Security-Group Support

`var.security_groups` is a map of SGs, each with a `rules` list. SGs are created unless `id` is set (pre-existing SG — rules are ignored for those). VMs list which SGs to attach via `security_group_names`. All SG assignment happens at the port level (`security_group_ids` on `openstack_networking_port_v2`), not at the instance level.

### Smart Volume Handling (root main.tf locals)

Two locals merge volume sources before passing to the `volume` module:
- `auto_volumes`: synthesized from VMs that declare `volume_size` inline (shorthand)
- `all_volumes`: merges `var.volumes` with `auto_volumes`

### VM Port Strategies

Each VM has a `ports` list (required, at least one). Each port entry supports three modes (evaluated in order):
1. **`port_id`** provided — uses a pre-created port, no new port resource created
2. **`ip`** provided — creates a port with that fixed IP on `network_id`
3. **Neither** — creates a port with DHCP-assigned IP on `network_id`

Port resources always receive `security_group_ids` from the VM's `security_group_names` resolution.

## Key Variable Shapes

### `networks` map (root variable)

```hcl
networks = {
  "frontend" = {
    name         = "frontend-net"   # required
    cidr         = "10.0.1.0/24"   # optional; needed when creating
    gateway_ip   = "10.0.1.1"      # optional
    external_net = "ext-net-id"    # optional; for router gateway
    id           = "uuid..."       # optional; use existing network
  }
}
```

### `security_groups` map (root variable)

```hcl
security_groups = {
  "web-sg" = {
    description = "Web tier"        # optional
    id          = "uuid..."         # optional; reference existing SG (rules ignored)
    rules = [
      { direction = "ingress", protocol = "tcp", port_min = 443, port_max = 443, remote_ip_prefix = "0.0.0.0/0" },
      { direction = "ingress", ethertype = "IPv6", protocol = "tcp", port_min = 443, port_max = 443 },
    ]
  }
}
```

### `vms` map (root variable)

```hcl
vms = {
  "my-vm" = {
    flavor_name          = "m1.small"        # required
    image_name           = "Ubuntu-20.04"    # optional; mutually exclusive with volume_id
    key_pair             = "my-key"          # optional
    volume_id            = "uuid..."         # optional; boot from existing volume
    volume_size          = 20                # optional shorthand; auto-creates a boot volume
    security_group_names = ["web-sg"]        # optional; keys from var.security_groups
    ports = [                                # required; at least one entry
      { network_name = "frontend" },         # DHCP IP on named network
      { network_name = "backend", ip = "10.0.2.5" },  # fixed IP
      { port_id = "uuid..." },               # pre-existing port
    ]
    extra_volumes = [                        # optional; additional block devices
      { volume_name = "data-vol" }
    ]
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
