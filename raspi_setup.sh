#!/bin/bash

# ======================
# User-configurable variables
# ======================
IMAGE_URL="https://cdimage.ubuntu.com/releases/24.04.1/release/ubuntu-24.04.1-preinstalled-server-arm64+raspi.img.xz"
IMAGE_NAME="os_image.img.xz"  # Name of the downloaded image file
USERNAME="your-desired-username-here"
HOSTNAME="yourhostname"
SSH_KEY="your public key for ssh"

# ======================
# Script Start
# ======================

# Check if the image file already exists
if [ -f "$IMAGE_NAME" ]; then
    read -p "The image file '$IMAGE_NAME' already exists. Do you want to overwrite it? (y/n): " REPLY
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        echo "Removing existing image file and downloading a new one..."
        rm $IMAGE_NAME && wget -O "$IMAGE_NAME" "$IMAGE_URL" || { echo "Failed to remove or download the image file."; exit 1; }
        echo "=== Decompressing the image file ==="
        xz -d "$IMAGE_NAME"
        IMAGE_FILE="${IMAGE_NAME%.xz}"  # Extracted image file name
    elif [[ "$REPLY" =~ ^[Nn]$ ]]; then
        read -p "Do you want to use the existing image file? (y/n): " USE_EXISTING
        if [[ "$USE_EXISTING" =~ ^[Yy]$ ]]; then
            IMAGE_FILE="${IMAGE_NAME%.xz}"  # Assume the file is already decompressed
            if [[ ! -f "$IMAGE_FILE" ]]; then
                echo "The decompressed image file does not exist. Please check your files."
                exit 1
            fi
            echo "Warning: Writing this image to a disk will erase all existing data on the target disk."
        else
            echo "Exiting script as no valid image file was selected."
            exit 1
        fi
    else
        echo "Invalid option. Exiting script."
        exit 1
    fi
else
    echo "Downloading the image file."
    wget -O "$IMAGE_NAME" "$IMAGE_URL" || { echo "Failed to download the image file."; exit 1; }
    echo "=== Decompressing the image file ==="
    xz -d "$IMAGE_NAME"
    IMAGE_FILE="${IMAGE_NAME%.xz}"  # Extracted image file name
fi

echo "=== Listing available disks ==="
lsblk
echo "Specify the target disk to write the image (e.g., /dev/sdX or /dev/nvmeX):"
read -p "Disk device name: " DISK_DEVICE

echo "Warning: Writing the image to $DISK_DEVICE will erase all existing data on the disk."
read -p "Are you sure you want to proceed? (y/n): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Exiting script to avoid data loss."
    exit 1
fi

echo "=== Writing the image file to the disk ==="
sudo dd if="$IMAGE_FILE" of="$DISK_DEVICE" bs=4M status=progress conv=fsync
if [ $? -ne 0 ]; then
    echo "Failed to write the image to the disk."
    exit 1
fi

echo "=== Mounting the boot partition ==="
BOOT_PART="${DISK_DEVICE}p1"  # First partition of the disk
sudo mount "$BOOT_PART" /mnt
if [ $? -ne 0 ]; then
    echo "Failed to mount the boot partition. Please check."
    exit 1
fi

echo "=== Enabling SSH ==="
sudo touch /mnt/ssh

echo "=== Creating cloud-init configuration file ==="
sudo bash -c "cat > /mnt/user-data <<EOF
#cloud-config
hostname: $HOSTNAME
users:
  - default
  - name: $USERNAME
    gecos: $USERNAME
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - $SSH_KEY
ssh_pwauth: false
disable_root: true
EOF"

echo "=== Unmounting the boot partition ==="
sudo umount /mnt

echo "=== Setup complete! You can now boot your Raspberry Pi with the configured SSD. ==="
