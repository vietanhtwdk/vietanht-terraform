# Volume Module, Boot from Volume, and Integration Tests

This plan implements a separate volume module for better storage management, updates the VM module to support booting from existing volumes, and adds integration tests to verify these new features.

## Proposed Changes

### 1. Volume Module

#### [NEW] [variables.tf](file:///d:/code/vietanhtwdk-terraform/openstack/modules/volume/variables.tf)
- Define `volumes` variable (map of objects: `name`, `size`, `image_name` (optional)).

#### [NEW] [main.tf](file:///d:/code/vietanhtwdk-terraform/openstack/modules/volume/main.tf)
- Use `data "openstack_images_image_v2"` to look up image IDs if `image_name` is provided.
- Create `openstack_blockstorage_volume_v3` resources.

#### [NEW] [outputs.tf](file:///d:/code/vietanhtwdk-terraform/openstack/modules/volume/outputs.tf)
- Output a map of volume names to IDs.

### 2. VM Module

#### [MODIFY] [variables.tf](file:///d:/code/vietanhtwdk-terraform/openstack/modules/vm/variables.tf)
- Add `volume_id` (optional string) to the `vms` map.

#### [MODIFY] [main.tf](file:///d:/code/vietanhtwdk-terraform/openstack/modules/vm/main.tf)
- Update `openstack_compute_instance_v2` to support `block_device` when `volume_id` is provided.
- Ensure `image_name` is only used if `volume_id` is null.

### 3. Root Module

#### [MODIFY] [variables.tf](file:///d:/code/vietanhtwdk-terraform/openstack/variables.tf)
- Add `volumes` variable for independent volume creation.
- Update `vms` to include `volume_id`.

#### [MODIFY] [main.tf](file:///d:/code/vietanhtwdk-terraform/openstack/main.tf)
- Call the `volume` module.
- Pass volume IDs and updated VM config to the `vm` module.

### 4. Integration Tests

#### [NEW] [tests/integration.tftest.hcl](file:///d:/code/vietanhtwdk-terraform/openstack/tests/integration.tftest.hcl)
- Create a test file that defines a volume and a VM booting from that volume.
- Verify that the resources can be planned/applied correctly.

## Verification Plan

### Automated Tests
- Run `terraform validate`.
- Run `terraform test` (if supported) or manually verify the configuration in the `tests` directory.

### Manual Verification
- Review the `terraform plan` output for a configuration that uses both the `volume` module and the `vm` module with `volume_id`.
