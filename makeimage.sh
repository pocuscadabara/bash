#!/bin/bash

# Example script to create bootable Ubuntu drive from OS X
# Use 'diskutil list' to set appropriate target disk

sourceimage=~/Downloads/ubuntu-19.10-desktop-amd64.iso
target=/dev/device-you-want-to-use

hdiutil convert $sourceimage -format UDRW -o $sourceimage

diskutil unmountDisk $target

sudo dd if=$sourceimage.dmg of=$target bs=1m
