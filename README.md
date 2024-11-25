# Raspberry Pi OS Installation Script

## Overview

This script automates the process of downloading an operating system image, preparing it, and flashing it to a target disk (e.g., an SSD or an SD card) for Raspberry Pi. Additionally, it configures the system to enable SSH, create a custom user, set the hostname, and add an SSH key for authentication.

---

## Features

1. **Automatic OS Image Handling:**
   - Downloads the specified OS image from a URL.
   - Handles existing image files by allowing the user to overwrite or reuse them.
   - Decompresses `.xz` compressed image files.

2. **Disk Preparation:**
   - Prompts the user to select a target disk.
   - Warns about data loss before writing the image to the disk.

3. **Post-Installation Configuration:**
   - Enables SSH on boot.
   - Sets a custom hostname.
   - Creates a new user with sudo privileges.
   - Adds an SSH public key for passwordless authentication.

---

## Requirements

- A Linux-based system (e.g., Raspberry Pi, Ubuntu, etc.).
- `wget` and `xz-utils` installed. (Script will use `rm` and `dd` commands.)
- Root or sudo access to write the OS image to a disk.

---

## Usage

### 1. Download the Script

Save the script to a file, e.g., `raspi_setup.sh`:

```bash
nano raspi_setup.sh
```

Paste the script content into the file and save.

### 2. Make the Script Executable

```bash
chmod +x raspi_setup.sh
```

### 3. Run the Script

```bash
sudo ./raspi_setup.sh
```

---

## How It Works

### Step 1: OS Image Handling

1. The script checks if the OS image file (`os_image.img.xz`) already exists in the current directory:
   - If the file exists, the user is asked whether to overwrite it or reuse it.
   - If the user chooses to overwrite, the existing file is deleted, and the script downloads a fresh copy.
   - If the user chooses to reuse the file, the script ensures the decompressed `.img` file exists before proceeding.

2. The script decompresses the `.xz` file to an `.img` file using the `xz` utility.

---

### Step 2: Disk Selection and Writing

1. The script lists all available disks using `lsblk`, helping the user identify the correct target disk.
2. The user is prompted to specify the target disk (e.g., `/dev/sdX` or `/dev/nvmeX`).
3. A final warning about data loss is displayed before writing the image to the disk.
4. The `dd` command is used to write the image to the specified disk with a block size of 4MB, ensuring efficient performance.

---

### Step 3: Post-Installation Configuration

1. The script mounts the boot partition of the target disk to `/mnt`.
2. It enables SSH by creating an empty `ssh` file in the boot partition.
3. A `cloud-init` configuration file (`user-data`) is created in the boot partition to:
   - Set a custom hostname.
   - Create a new user with sudo privileges.
   - Add an SSH public key for passwordless login.

---

## Variables

You can customize the following variables in the script to fit your needs:

- `IMAGE_URL`: The URL of the OS image to download (default is Ubuntu Server for Raspberry Pi).
- `IMAGE_NAME`: The name of the downloaded image file (default is `os_image.img.xz`).
- `USERNAME`: The name of the user to create (default is `kaandikec`).
- `HOSTNAME`: The hostname of the system (default is `pi5`).
- `SSH_KEY`: The SSH public key to add for the created user.

---

## Example Usage

### Scenario 1: Fresh Download and Install

Run the script on a system without the image file. The script will:
- Download the image from the specified URL.
- Decompress it.
- Write it to the selected disk.

### Scenario 2: Reuse Existing Image File

If the image file (`os_image.img.xz`) already exists:
- The script asks if you want to overwrite or reuse the file.
- If reusing, it ensures the decompressed `.img` file exists.

---

## Notes

1. **Data Loss Warning:** Writing the OS image to a disk will erase all data on the target disk. Be sure to select the correct disk.
2. **Network Speed:** Download speed depends on your internet connection and the server hosting the OS image.
3. **Dependencies:** Ensure the following tools are installed on your system:
   - `wget` (for downloading files)
   - `xz-utils` (for decompressing files)
   - `lsblk` (for listing disks)

---

## Troubleshooting

1. **Slow Downloads:** If downloads are slow, try a different mirror for the `IMAGE_URL`.
2. **Permission Denied Errors:** Ensure the script is run with `sudo` to allow access to protected system files and disks.
3. **Image File Errors:** If the decompressed image file is missing, ensure there is enough disk space and no interruptions during decompression.

---

## Future Enhancements

- Support for additional compression formats (e.g., `.gz`).
- Auto-detection of the correct disk based on connected devices.
- Optional configuration of Wi-Fi credentials in the `cloud-init` file.

---

## License

This script is provided as-is with no warranties. Use at your own risk.
