# Raspberry Pi Setup Script

This script automates the process of preparing a bootable Raspberry Pi image and writing it to a specified disk. It includes error handling, disk validation, and user-friendly prompts to ensure a smooth experience.

---

## Features
- Downloads and decompresses the Raspberry Pi image.
- Validates existing files and allows users to overwrite or reuse them.
- Lists available disks and validates user input.
- Cleans the target disk before writing the image.
- Configures SSH and `cloud-init` with user-defined parameters.
- Handles invalid input and offers retry options.

---

## Prerequisites
- A Linux system with `bash` shell.
- Root privileges to write to disks and mount partitions.
- Tools: `wget`, `xz-utils`, and `lsblk`.

---

## Usage
1. Clone this repository or download the script.
2. Make the script executable:
   ```bash
   chmod +x raspi_setup.sh
   ```
3. Run the script with root privileges:
   ```bash
   sudo ./raspi_setup.sh
   ```

---

## Configuration
Before running the script, customize the following variables at the top of the `raspi_setup.sh` file:
- `IMAGE_URL`: URL of the Raspberry Pi OS image to download.
- `USERNAME`: Desired username for the Raspberry Pi.
- `HOSTNAME`: Hostname for the Raspberry Pi.
- `SSH_KEY`: Your public SSH key for secure access.

---

## Example Run (Terminal Output)
Below is an example usage scenario. Replace this with your own terminal output.

```plaintext
kaandikec@pi5:~$ nano raspi_setup.sh
kaandikec@pi5:~$ chmod +x raspi_setup.sh
kaandikec@pi5:~$ sudo ./raspi_setup.sh 
The image file 'os_image.img.xz' already exists.
Do you want to overwrite it? (y/n): n
Using the existing image file.
=== Decompressing the image file ===
The decompressed image file already exists. Overwriting...
=== Listing available disks ===
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0         7:0    0  33.7M  1 loop /snap/snapd/21761
mmcblk0     179:0    0  59.5G  0 disk 
├─mmcblk0p1 179:1    0   512M  0 part 
└─mmcblk0p2 179:2    0    59G  0 part /
nvme0n1     259:0    0 931.5G  0 disk 
├─nvme0n1p1 259:3    0   512M  0 part 
└─nvme0n1p2 259:4    0   2.9G  0 part 
Specify the target disk to write the image (e.g., /dev/sdX or /dev/nvmeX): nvme0n1
Invalid disk device format. Please use a full path like /dev/sdX or /dev/nvmeX.
Invalid input. Would you like to try again? (y/n): 
y
=== Listing available disks ===
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0         7:0    0  33.7M  1 loop /snap/snapd/21761
mmcblk0     179:0    0  59.5G  0 disk 
├─mmcblk0p1 179:1    0   512M  0 part 
└─mmcblk0p2 179:2    0    59G  0 part /
nvme0n1     259:0    0 931.5G  0 disk 
├─nvme0n1p1 259:3    0   512M  0 part 
└─nvme0n1p2 259:4    0   2.9G  0 part 
Specify the target disk to write the image (e.g., /dev/sdX or /dev/nvmeX): /dev/nvme0n1
Warning: Writing the image to /dev/nvme0n1 will erase all existing data on the disk.
Are you sure you want to proceed? (y/n): y
=== Cleaning the target disk ===
100+0 records in
100+0 records out
104857600 bytes (105 MB, 100 MiB) copied, 0.412415 s, 254 MB/s
=== Writing the image file to the disk ===
3523215360 bytes (3.5 GB, 3.3 GiB) copied, 8 s, 440 MB/s3675607040 bytes (3.7 GB, 3.4 GiB) copied, 8.43806 s, 436 MB/s

876+1 records in
876+1 records out
3675607040 bytes (3.7 GB, 3.4 GiB) copied, 10.4239 s, 353 MB/s
=== Mounting the boot partition ===
=== Enabling SSH ===
=== Creating cloud-init configuration file ===
=== Unmounting the boot partition ===
=== Setup complete! You can now boot your Raspberry Pi with the configured SSD. ===
kaandikec@pi5:~$ ^C
kaandikec@pi5:~$ 
...
```

---

## Notes
- Ensure you specify the correct disk device to avoid accidental data loss.
- If you encounter issues, ensure all dependencies are installed and run the script with `sudo`.

