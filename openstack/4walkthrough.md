# Walkthrough: Volume Management and Boot from Volume

I have implemented a new `volume` module, added support for booting VMs from existing volumes, and created an integration test to verify the setup.

## Changes Made

### 1. New Volume Module
I created a dedicated module in `modules/volume` to manage OpenStack block storage.
- **Independence**: Volumes can now be created separately from VMs, allowing for persistent storage lifecycles.
- **Image Integration**: Volumes can be initialized from an image name, which is looked up automatically using a data source.
- **Configurable Size**: Users can specify the size of each volume.

### 2. VM Module: Boot from Volume
The `vm` module now supports the `volume_id` attribute.
- **Block Device Support**: If a `volume_id` is provided, the VM uses a `block_device` block with `source_type = "volume"` to boot.
- **Conditional Logic**: The `image_name` attribute is automatically disabled when a `volume_id` is used to prevent configuration conflicts.

### 3. Root Module Updates
- Added a `volumes` map to the root configuration.
- Integrated the `volume` module call in the root `main.tf`.

### 4. Integration Tests
Created a `tests/integration_test.tf` file that demonstrates:
- Creating a volume from an image.
- Creating a VM that boots from that volume.

## Verification Results

### Terraform Validation
After initializing the new module, I ran `terraform validate` successfully:
```text
Success! The configuration is valid.
```

## How to use

### 1. Create a Volume and Boot from it
In your `terraform.tfvars`:
```hcl
volumes = {
  "my-boot-vol" = {
    size       = 20
    image_name = "ubuntu-22.04"
  }
}

vms = {
  "my-vm" = {
    flavor_name = "m1.medium"
    # Link to the volume (manually or via variable)
    volume_id   = "uuid-of-the-created-volume" 
  }
}
```

### 2. Boot from an Existing Volume
Simply provide the UUID of any existing volume in the `volume_id` field of the VM configuration.
