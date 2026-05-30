#!/bin/bash
set -e

echo "========================================"
echo "Proxmox VE MAAS Image Builder (Docker)"
echo "========================================"
echo ""

# Check if /dev/kvm is accessible
if [ ! -r /dev/kvm ] || [ ! -w /dev/kvm ]; then
    echo "ERROR: Cannot access /dev/kvm"
    echo "Please ensure Docker has access to KVM device"
    exit 1
fi

echo "✓ KVM device accessible"
echo ""

# Navigate to debian directory
cd /build/debian

echo "Cleaning previous builds..."
rm -rf output-* debian-custom-*.gz debian-*-cloudimg.tar.gz proxmox-*.tar.gz seeds-cloudimg.iso

echo ""
echo "Initializing Packer..."
packer init .

echo ""
echo "Installing Packer Ansible plugin..."
packer plugins install github.com/hashicorp/ansible

echo ""
echo "Starting Proxmox VE image build..."
echo "This will take approximately 35-45 minutes..."
echo ""

# Run the build with the same parameters as the Makefile
PACKER_LOG=0 packer build \
    -var debian_series=trixie \
    -var debian_version=13 \
    -var architecture=amd64 \
    -var boot_mode=bios \
    -var host_is_arm=false \
    -var timeout=1h \
    -var install_proxmox=true \
    -var filename=proxmox-ve-13-cloudimg.tar.gz .

echo ""
echo "========================================"
echo "Build completed successfully!"
echo "========================================"
echo ""
echo "Output: debian/proxmox-ve-13-cloudimg.tar.gz"
ls -lh proxmox-ve-13-cloudimg.tar.gz 2>/dev/null || echo "Warning: Output file not found"
echo ""
