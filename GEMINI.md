# vietanht-terraform

A modular Terraform project for managing OpenStack infrastructure.

## Project Overview

This project provides Infrastructure as Code (IaC) to provision and manage resources on an OpenStack cloud. It uses a modular architecture to separate concerns like networking, security groups, block storage (volumes), and compute instances (VMs).

### Technologies
- **Terraform**: >= 1.0.0
- **OpenStack Provider**: ~> 3.4.0

## Architecture

The project follows a standard Terraform layout:
- **Root Module**: Located in the `openstack/` directory, it orchestrates the sub-modules.
- **Sub-modules**: Located in `openstack/modules/`, focusing on specific resource types:
    - `network`: Manages OpenStack networks, subnets, and routers.
    - `security_group`: Manages security groups and rules.
    - `volume`: Manages Cinder volumes.
    - `vm`: Manages Nova compute instances, including port and block device attachments.
- **Environments**: Environment-specific configurations are stored in `openstack/envs/` as `.tfvars` files.

## Building and Running

Commands should be executed from the `openstack/` directory.

### Initialization
```bash
terraform init
```

### Validation
```bash
terraform validate
```

### Planning
To preview changes for a specific environment (e.g., `dev`):
```bash
terraform plan -var-file=envs/dev.tfvars
```

### Applying
To apply changes for a specific environment:
```bash
terraform apply -var-file=envs/dev.tfvars
```

### Testing
The project includes a sample integration test in `openstack/tests/integration_test.tf`. This is a regular Terraform file that calls the root module with mock data.
```bash
cd openstack/tests
terraform init
terraform plan
```

## Development Conventions

- **Modularity**: Always use or create modules for resource groups. Each module should have its own `main.tf`, `variables.tf`, and `outputs.tf`.
- **Variables**: Define all input variables in `variables.tf` with clear descriptions. Use `sensitive = true` for secrets like passwords.
- **Environment Separation**: Do not hardcode environment-specific values. Use `.tfvars` files in the `envs/` directory.
- **Resource Naming**: Follow a consistent naming convention, often prefixing resources with the network name or environment.

## Key Files

- `openstack/main.tf`: The main entry point that calls all modules.
- `openstack/providers.tf`: Configures the OpenStack provider.
- `openstack/variables.tf`: Global variable definitions.
- `openstack/outputs.tf`: Global output definitions.
- `openstack/envs/`: Directory containing environment-specific variable files (e.g., `dev.tfvars`, `prod.tfvars`).
- `openstack/modules/`: Directory containing the reusable infrastructure components.
