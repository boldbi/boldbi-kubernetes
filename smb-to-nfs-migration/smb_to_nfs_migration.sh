#!/bin/bash
# Copyright (c) Syncfusion Inc. All rights reserved.

# Set script options
set -euo pipefail

# Exposing stream 3 as a pipe to standard output of the script itself
exec 3>&1

# Setup some colors to use. These need to work in fairly limited shells, like the Ubuntu Docker container where there are only 8 colors.
# See if stdout is a terminal
if [ -t 1 ] && command -v tput > /dev/null; then
    # see if it supports colors
    ncolors=$(tput colors)
    if [ -n "$ncolors" ] && [ $ncolors -ge 8 ]; then
        bold="$(tput bold || echo)"
        normal="$(tput sgr0 || echo)"
        cyan="$(tput setaf 6 || echo)"
		red="$(tput setaf 1     || echo)"
        green="$(tput setaf 2   || echo)"
    fi
fi

# Use in the functions: eval $invocation
invocation='say_verbose "Calling: ${cyan:-}${FUNCNAME[0]} ${bold:-}$*${normal:-}"'

say() {
    # Using stream 3 (defined in the beginning) to not interfere with stdout of functions
    # which may be used as a return value
    printf "%b\n" "${cyan:-}Info: ${normal:-} $1" >&3
}

say_success() {
    printf "%b\n" "${green:-}Info: $1${normal:-}" >&3
}

say_err() {
    printf "%b\n" "${red:-}Info: $1${normal:-}" >&2
}

say_verbose() {
    say "$1"
}

# Check if a filename is provided as a command line argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

filename=$1

# Check if the file exists
if [ ! -f "$filename" ]; then
    say_err "File not found: $filename"
    exit 1
fi

install_req_packages() {
    
    eval $invocation
    
    # Check if the nfs-common package is already installed
    if dpkg -l | grep -q nfs-common; then
        say "nfs-common package is already installed."
    else
	
		say "Installing nfs-common package..."
		apt-get -qq update
		apt-get -qq install -y nfs-common

		# Check if the installation was successful
		if [ $? -ne 0 ]; then
			say_err"Error: Failed to install nfs-common package."
			exit 1
		fi
    fi

    # Check if the pv package is already installed
    if command -v pv > /dev/null; then
        say "pv package is already installed."
    else

		say "Installing pv package..."
		apt-get -qq update
		apt-get -qq install -y pv

		# Check if the installation was successful
		if [ $? -ne 0 ]; then
			say_err "Error: Failed to install pv package."
			exit 1
		fi
    fi
}

connect_nfsfileshare() {

    eval $invocation

    # Create mount directory
    say "Creating mount directory for NFS file share $nfsfileshare..."
    mkdir -p "/mount/$premiumstorageaccount/$nfsfileshare"

    # Mount NFS file share
    say "Mounting NFS file share $nfsfileshare..."
    mount -t nfs "$premiumstorageaccount.file.core.windows.net:/$premiumstorageaccount/$nfsfileshare" "/mount/$premiumstorageaccount/$nfsfileshare" -o vers=4,minorversion=1,sec=sys,nconnect=4

    # Check if the mount was successful
    if [ $? -ne 0 ]; then
        say_err "Error: Failed to mount NFS file share $nfsfileshare."
        exit 1
    fi

    say_success "NFS file share $nfsfileshare successfully mounted."
}

connect_smbfileshare() {

    eval $invocation

    # Create mount point if it doesn't exist
    say "Creating mount point for SMB file share $smbfileshare..."
    mkdir -p "/mnt/$smbfileshare"

    # Create smbcredentials directory if it doesn't exist
    if [ ! -d "/etc/smbcredentials" ]; then
        mkdir "/etc/smbcredentials"
    fi

    # Create credentials file (overwrite if it exists)
    say "Creating credentials file for SMB file share $smbfileshare..."
    echo "username=$standardstorageaccount" > "/etc/smbcredentials/$standardstorageaccount.cred"
    echo "password=$accesskey" >> "/etc/smbcredentials/$standardstorageaccount.cred"

    # Check if the credentials file was created successfully
    if [ $? -ne 0 ]; then
        say_err "Error: Failed to create credentials file for SMB file share $smbfileshare."
        exit 1
    fi

    # Secure permissions for the credentials file
    chmod 600 "/etc/smbcredentials/$standardstorageaccount.cred"

    # Add entry to /etc/fstab for persistent mount
    say "Configuring /etc/fstab for persistent SMB file share mount..."
    echo "//$standardstorageaccount.file.core.windows.net/$smbfileshare /mnt/$smbfileshare cifs nofail,credentials=/etc/smbcredentials/$standardstorageaccount.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30" >> "/etc/fstab"

    # Mount the Azure file share
    say "Mounting SMB file share $smbfileshare..."
    mount -t cifs "//$standardstorageaccount.file.core.windows.net/$smbfileshare" "/mnt/$smbfileshare" -o credentials="/etc/smbcredentials/$standardstorageaccount.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30"

    # Check if the mount was successful
    if [ $? -ne 0 ]; then
        say_err "Error: Failed to mount SMB file share$smbfileshare."
        exit 1
    fi

    say_success "SMB file share $smbfileshare successfully mounted ."
}

unmount_dir() {

    eval $invocation

    say "Unmounting SMB file share $smbfileshare..."
    umount "/mnt/$smbfileshare"

    say "Unmounting NFS file share $nfsfileshare..."
    umount "/mount/$premiumstorageaccount/$nfsfileshare"
}

SMB_NFS_Migration() {

    eval $invocation

    # Check for root privileges
    if [[ $EUID -ne 0 ]]; then
        say_err "Error: This script must be run as root."
        exit 1
    fi
	
	install_req_packages

    connect_smbfileshare
    connect_nfsfileshare

    # Copy files from SMB mounting directory to NFS mounting directory
    say "Copying files from SMB file share $smbfileshare to NFS file share $nfsfileshare..."

    # for copying files.
	cp -r "/mnt/$smbfileshare/"* "/mount/$premiumstorageaccount/$nfsfileshare/" | pv -lep -s $(du -sb "/mnt/$smbfileshare/" | awk '{print $1}') > /dev/null

    unmount_dir

    say_success "Files copied successfully from SMB file share "$smbfileshare" to NFS file share "$nfsfileshare"."
}

# Loop through each line in the file
while IFS= read -r line; do
    # Split the line into key-value pairs
    IFS=' ' read -ra elements <<< "$line"

    # Loop through key-value pairs and assign values to variables
    for element in "${elements[@]}"; do
        IFS='=' read -r key value <<< "$element"
        case $key in
        "premiumstorageaccount") premiumstorageaccount="$value" ;;
        "nfsfileshare") nfsfileshare="$value" ;;
        "standardstorageaccount") standardstorageaccount="$value" ;;
        "smbfileshare") smbfileshare="$value" ;;
        "accesskey") accesskey="$value" ;;
        esac
    done
    # Call the migration after getting values from the array.
    SMB_NFS_Migration
	
done < "$filename"
