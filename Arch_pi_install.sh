#!/bin/bash
#-------------------------------------------------------------------------------
# Basic Utilities forked from https://github.com/helmuthdu/aui/blob/master/ais
#-------------------------------------------------------------------------------
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.
#-------------------------------------------------------------------------------
# Run this script after your first boot with archlinux (as root)

if [[ -f `pwd`/sharedfuncs ]]; then
  source sharedfuncs
else
  echo "missing file: sharedfuncs"
  exit 1
fi



#ARCHLINUX INSTALL SCRIPTS MODE {{{
#SELECT KEYMAP {{{
select_keymap(){
  print_title "KEYMAP - https://wiki.archlinux.org/index.php/KEYMAP"
  print_info "The KEYMAP variable is specified in the /etc/rc.conf file. It defines what keymap the keyboard is in the virtual consoles. Keytable files are provided by the kbd package."
  OPTION=n
  while [[ $OPTION != y ]]; do
    getkeymap
    read_input_text "Confirm keymap: $KEYMAP"
  done
  loadkeys $KEYMAP
}
#}}}



#DEFAULT EDITOR {{{
select_editor(){
  print_title "DEFAULT EDITOR"
  editors_list=("emacs" "nano" "vi" "vim" "zile");
  PS3="$prompt1"
  echo -e "Select editor\n"
  select EDITOR in "${editors_list[@]}"; do
    if contains_element "$EDITOR" "${editors_list[@]}"; then
      package_install "$EDITOR"
      break
    else
      invalid_option
    fi
  done
}
#}}}



## Partition Manager


#UMOUNT PARTITIONS {{{
umount_partitions(){
  mounted_partitions=(`lsblk | grep ${MOUNTPOINT} | awk '{print $7}' | sort -r`)
  swapoff -a
  for i in ${mounted_partitions[@]}; do
    umount $i
  done
}
#}}}
#CREATE PARTITION SCHEME {{{
create_partition_scheme(){
  LUKS=0
  LVM=0
  select_device(){
    devices_list=(`lsblk -d | awk '{print "/dev/" $1}' | grep 'sd\|hd\|vd'`);
    PS3="$prompt1"
    echo -e "Select partition:\n"
    select device in "${devices_list[@]}"; do
      if contains_element "${device}" "${devices_list[@]}"; then
        break
      else
        invalid_option
      fi
    done
    BOOT_DISK=$device
  }
  print_title "https://wiki.archlinux.org/index.php/Partitioning"
  print_info "Partitioning a hard drive allows one to logically divide the available space into sections that can be accessed independently of one another."
  partition_layout=("Default" "LVM" "LVM+LUKS")
  PS3="$prompt1"
  echo -e "Select partition scheme:"
  select OPT in "${partition_layout[@]}"; do
    case "$REPLY" in
      1)
        create_partition
        ;;
      2)
        create_partition
        setup_lvm
        ;;
      3)
        create_partition
        setup_luks
        setup_lvm
        ;;
      *)
        invalid_option
        ;;
    esac
    [[ -n $OPT ]] && break
  done
}
#}}}
#SETUP PARTITION{{{
create_partition(){
  apps_list=("cfdisk" "cgdisk" "fdisk" "gdisk" "parted");
  PS3="$prompt1"
  echo -e "Select partition program:"
  select OPT in "${apps_list[@]}"; do
    if contains_element "$OPT" "${apps_list[@]}"; then
      select_device
      case $OPT in
        parted)
          parted -a opt ${device}
          ;;
        *)
          $OPT ${device}
          ;;
      esac
      break
    else
      invalid_option
    fi
  done
}
#}}}
#SETUP LUKS {{{
setup_luks(){
  print_title "LUKS - https://wiki.archlinux.org/index.php/LUKS"
  print_info "The Linux Unified Key Setup or LUKS is a disk-encryption specification created by Clemens Fruhwirth and originally intended for Linux."
  print_danger "\tDo not use this for boot partitions"
  block_list=(`lsblk | grep 'part' | awk '{print "/dev/" substr($1,3)}'`)
  PS3="$prompt1"
  echo -e "Select partition:"
  select OPT in "${block_list[@]}"; do
    if contains_element "$OPT" "${block_list[@]}"; then
      cryptsetup luksFormat $OPT
      cryptsetup open --type luks $OPT crypt
      LUKS=1
      LUKS_DISK=`echo ${OPT} | sed 's/\/dev\///'`
      break
    elif [[ $OPT == "Cancel" ]]; then
      break
    else
      invalid_option
    fi
  done
}
#}}}
#SETUP LVM {{{
setup_lvm(){
  print_title "LVM - https://wiki.archlinux.org/index.php/LVM"
  print_info "LVM is a logical volume manager for the Linux kernel; it manages disk drives and similar mass-storage devices. "
  print_warning "Last partition will take 100% of free space left"
  if [[ $LUKS -eq 1 ]]; then
    pvcreate /dev/mapper/crypt
    vgcreate lvm /dev/mapper/crypt
  else
    block_list=(`lsblk | grep 'part' | awk '{print "/dev/" substr($1,3)}'`)
    PS3="$prompt1"
    echo -e "Select partition:"
    select OPT in "${block_list[@]}"; do
      if contains_element "$OPT" "${block_list[@]}"; then
        pvcreate $OPT
        vgcreate lvm $OPT
        break
      else
        invalid_option
      fi
    done
  fi
  read -p "Enter number of partitions [ex: 2]: " number_partitions
  i=1
  while [[ $i -le $number_partitions ]]; do
    read -p "Enter $iª partition name [ex: home]: " partition_name
    if [[ $i -eq $number_partitions ]]; then
      lvcreate -l 100%FREE lvm -n ${partition_name}
    else
      read -p "Enter $iª partition size [ex: 25G, 200M]: " partition_size
      lvcreate -L ${partition_size} lvm -n ${partition_name}
    fi
    i=$(( i + 1 ))
  done
  LVM=1
}
#}}}
#SELECT|FORMAT PARTITIONS {{{
format_partitions(){
  print_title "https://wiki.archlinux.org/index.php/File_Systems"
  print_info "This step will select and format the selected partiton where the archlinux will be installed"
  print_danger "\tAll data on the ROOT and SWAP partition will be LOST."
  i=0

  block_list=(`lsblk | grep 'part\|lvm\|cciss' | awk '{print substr($1,3)}'`)

  # check if there is no partition
  if [[ ${#block_list[@]} -eq 0 ]]; then
    echo "No partition found"
    exit 0
  fi

  partitions_list=()
  for OPT in ${block_list[@]}; do
    check_lvm=`echo $OPT | grep lvm`
    if [[ -z $check_lvm ]]; then
      partitions_list+=("/dev/$OPT")
    else
      partitions_list+=("/dev/mapper/$OPT")
    fi
  done

  # partitions based on boot system
  if [[ $UEFI -eq 1 ]]; then
    partition_name=("root" "EFI" "swap" "another")
  else
    partition_name=("root" "swap" "another")
  fi

  select_filesystem(){
    filesystems_list=( "btrfs" "ext2" "ext3" "ext4" "f2fs" "jfs" "nilfs2" "ntfs" "vfat" "xfs");
    PS3="$prompt1"
    echo -e "Select filesystem:\n"
    select filesystem in "${filesystems_list[@]}"; do
      if contains_element "${filesystem}" "${filesystems_list[@]}"; then
        break
      else
        invalid_option
      fi
    done
  }

  disable_partition(){
    #remove the selected partition from list
    unset partitions_list[${partition_number}]
    partitions_list=(${partitions_list[@]})
    #increase i
    [[ ${partition_name[i]} != another ]] && i=$(( i + 1 ))
  }

  format_partition(){
    read_input_text "Confirm format $1 partition"
    if [[ $OPTION == y ]]; then
      [[ -z $3 ]] && select_filesystem || filesystem=$3
      mkfs.${filesystem} $1 \
        $([[ ${filesystem} == xfs || ${filesystem} == btrfs ]] && echo "-f") \
        $([[ ${filesystem} == vfat ]] && echo "-F32")
      fsck $1
      mkdir -p $2
      mount -t ${filesystem} $1 $2
      disable_partition
    fi
  }

  format_swap_partition(){
    read_input_text "Confirm format $1 partition"
    if [[ $OPTION == y ]]; then
      mkswap $1
      swapon $1
      disable_partition
    fi
  }

  create_swap(){
    swap_options=("partition" "file" "skip");
    PS3="$prompt1"
    echo -e "Select ${BYellow}${partition_name[i]}${Reset} filesystem:\n"
    select OPT in "${swap_options[@]}"; do
      case "$REPLY" in
        1)
          select partition in "${partitions_list[@]}"; do
            #get the selected number - 1
            partition_number=$(( $REPLY - 1 ))
            if contains_element "${partition}" "${partitions_list[@]}"; then
              format_swap_partition "${partition}"
            fi
            break
          done
          break
          ;;
        2)
          total_memory=`grep MemTotal /proc/meminfo | awk '{print $2/1024}' | sed 's/\..*//'`
          fallocate -l ${total_memory}M ${MOUNTPOINT}/swapfile
          chmod 600 ${MOUNTPOINT}/swapfile
          mkswap ${MOUNTPOINT}/swapfile
          swapon ${MOUNTPOINT}/swapfile
          i=$(( i + 1 ))
          break
          ;;
        3)
          i=$(( i + 1 ))
          break
          ;;
        *)
          invalid_option
          ;;
      esac
    done
  }

  check_mountpoint(){
    if mount | grep $2; then
      echo "Successfully mounted"
      disable_partition "$1"
    else
      echo "WARNING: Not Successfully mounted"
    fi
  }

  set_efi_partition(){
    efi_options=("/boot/efi" "/boot")
    PS3="$prompt1"
    echo -e "Select EFI mountpoint:\n"
    select EFI_DISK in "${efi_options[@]}"; do
      if contains_element "${EFI_DISK}" "${efi_options[@]}"; then
        break
      else
        invalid_option
      fi
    done
  }

  while true; do
    PS3="$prompt1"
    if [[ ${partition_name[i]} == swap ]]; then
      create_swap
    else
      echo -e "Select ${BYellow}${partition_name[i]}${Reset} partition:\n"
      select partition in "${partitions_list[@]}"; do
        #get the selected number - 1
        partition_number=$(( $REPLY - 1 ))
        if contains_element "${partition}" "${partitions_list[@]}"; then
          case ${partition_name[i]} in
            root)
              ROOT_PART=`echo ${partition} | sed 's/\/dev\/mapper\///' | sed 's/\/dev\///'`
              ROOT_DISK=${partition}
              format_partition "${partition}" "${MOUNTPOINT}"
              ;;
            EFI)
              set_efi_partition
              read_input_text "Format ${partition} partition"
              if [[ $OPTION == y ]]; then
                format_partition "${partition}" "${MOUNTPOINT}${EFI_DISK}" vfat
              else
                mkdir -p "${MOUNTPOINT}${EFI_DISK}"
                mount -t vfat "${partition}" "${MOUNTPOINT}${EFI_DISK}"
                check_mountpoint "${partition}" "${MOUNTPOINT}${EFI_DISK}"
              fi
              ;;
            another)
              read -p "Mountpoint [ex: /home]:" directory
              [[ $directory == "/boot" ]] && BOOT_DISK=`echo ${partition} | sed 's/[0-9]//'`
              select_filesystem
              read_input_text "Format ${partition} partition"
              if [[ $OPTION == y ]]; then
                format_partition "${partition}" "${MOUNTPOINT}${directory}" "${filesystem}"
              else
                read_input_text "Confirm fs="${filesystem}" part="${partition}" dir="${directory}""
                if [[ $OPTION == y ]]; then
                  mkdir -p ${MOUNTPOINT}${directory}
                  mount -t ${filesystem} ${partition} ${MOUNTPOINT}${directory}
                  check_mountpoint "${partition}" "${MOUNTPOINT}${directory}"
                fi
              fi
              ;;
          esac
          break
        else
          invalid_option
        fi
      done
    fi
    #check if there is no partitions left
    if [[ ${#partitions_list[@]} -eq 0 && ${partition_name[i]} != swap ]]; then
      break
    elif [[ ${partition_name[i]} == another ]]; then
      read_input_text "Configure more partitions"
      [[ $OPTION != y ]] && break
    fi
  done
  pause_function
}
#}}}




#CONFIGURE FSTAB {{{
configure_fstab(){
  print_title "FSTAB - https://wiki.archlinux.org/index.php/Fstab"
  print_info "The /etc/fstab file contains static filesystem information. It defines how storage devices and partitions are to be mounted and integrated into the overall system. It is read by the mount command to determine which options to use when mounting a specific partition or partition."
  if [[ ! -f ${MOUNTPOINT}/etc/fstab.aui ]]; then
    cp ${MOUNTPOINT}/etc/fstab ${MOUNTPOINT}/etc/fstab.aui
  else
    cp ${MOUNTPOINT}/etc/fstab.aui ${MOUNTPOINT}/etc/fstab
  fi
  if [[ $UEFI -eq 1 ]]; then
    fstab_list=("DEV" "PARTUUID" "LABEL");
  else
    fstab_list=("DEV" "UUID" "LABEL");
  fi

  PS3="$prompt1"
  echo -e "Configure fstab based on:"
  select OPT in "${fstab_list[@]}"; do
    case "$REPLY" in
      1) genfstab -p ${MOUNTPOINT} >> ${MOUNTPOINT}/etc/fstab ;;
      2) if [[ $UEFI -eq 1 ]]; then
          genfstab -t PARTUUID -p ${MOUNTPOINT} >> ${MOUNTPOINT}/etc/fstab
         else
          genfstab -U -p ${MOUNTPOINT} >> ${MOUNTPOINT}/etc/fstab
         fi
         ;;
      3) genfstab -L -p ${MOUNTPOINT} >> ${MOUNTPOINT}/etc/fstab ;;
      *) invalid_option ;;
    esac
    [[ -n $OPT ]] && break
  done
  echo "Review your fstab"
  [[ -f ${MOUNTPOINT}/swapfile ]] && sed -i "s/\\${MOUNTPOINT}//" ${MOUNTPOINT}/etc/fstab
  pause_function
  $EDITOR ${MOUNTPOINT}/etc/fstab
}
#}}}



#CONFIGURE HOSTNAME {{{
configure_hostname(){
  print_title "HOSTNAME - https://wiki.archlinux.org/index.php/HOSTNAME"
  print_info "A host name is a unique name created to identify a machine on a network.Host names are restricted to alphanumeric characters.\nThe hyphen (-) can be used, but a host name cannot start or end with it. Length is restricted to 63 characters."
  read -p "Hostname [ex: archlinux]: " host_name
  echo "$host_name" > ${MOUNTPOINT}/etc/hostname
  if [[ ! -f ${MOUNTPOINT}/etc/hosts.aui ]]; then
    cp ${MOUNTPOINT}/etc/hosts ${MOUNTPOINT}/etc/hosts.aui
  else
    cp ${MOUNTPOINT}/etc/hosts.aui ${MOUNTPOINT}/etc/hosts
  fi
  arch_chroot "sed -i '/127.0.0.1/s/$/ '${host_name}'/' /etc/hosts"
  arch_chroot "sed -i '/::1/s/$/ '${host_name}'/' /etc/hosts"
}
#}}}
#CONFIGURE TIMEZONE {{{
configure_timezone(){
  print_title "TIMEZONE - https://wiki.archlinux.org/index.php/Timezone"
  print_info "In an operating system the time (clock) is determined by four parts: Time value, Time standard, Time Zone, and DST (Daylight Saving Time if applicable)."
  OPTION=n
  while [[ $OPTION != y ]]; do
    settimezone
    read_input_text "Confirm timezone (${ZONE}/${SUBZONE})"
  done
  arch_chroot "ln -s /usr/share/zoneinfo/${ZONE}/${SUBZONE} /etc/localtime"
}
#}}}



#CONFIGURE LOCALE {{{
configure_locale(){
  print_title "LOCALE - https://wiki.archlinux.org/index.php/Locale"
  print_info "Locales are used in Linux to define which language the user uses. As the locales define the character sets being used as well, setting up the correct locale is especially important if the language contains non-ASCII characters."
  OPTION=n
  while [[ $OPTION != y ]]; do
    setlocale
    read_input_text "Confirm locale ($LOCALE)"
  done
  echo 'LANG="'$LOCALE_UTF8'"' > ${MOUNTPOINT}/etc/locale.conf
  arch_chroot "sed -i '/'${LOCALE_UTF8}'/s/^#//' /etc/locale.gen"
  arch_chroot "locale-gen"
}
#}}}




#ROOT PASSWORD {{{
root_password(){
  print_title "ROOT PASSWORD"
  print_warning "Enter your new root password"
  arch_chroot "passwd"
  pause_function
}
#}}}






#FINISH {{{
finish(){
  print_title "INSTALL COMPLETED"
  #COPY AUI TO ROOT FOLDER IN THE NEW SYSTEM
  print_warning "\nA copy of the AUI will be placed in /root directory of your new system"
  cp -R `pwd` ${MOUNTPOINT}/root
  read_input_text "Reboot system"
  if [[ $OPTION == y ]]; then
    umount_partitions
    reboot
  fi
  exit 0
}
#}}}

print_title "https://wiki.archlinux.org/index.php/Arch_Install_Scripts"
print_info "The Arch Install Scripts are a set of Bash scripts that simplify Arch installation."
pause_function
check_boot_system
check_connection
pacman -Sy
while true
do
  print_title "ARCHLINUX ULTIMATE INSTALL - https://github.com/helmuthdu/aui"
  echo " 1) $(mainmenu_item "${checklist[1]}" "Select Keymap")"
  echo " 2) $(mainmenu_item "${checklist[2]}" "Select Editor")"
  echo " 3) $(mainmenu_item "${checklist[3]}" "Configure Mirrorlist")"
  echo " 4) $(mainmenu_item "${checklist[4]}" "Create Partition")"
  echo " 5) $(mainmenu_item "${checklist[5]}" "Select|Format Partiton")"
  echo " 6) $(mainmenu_item "${checklist[6]}" "Install Base System")"
  echo " 7) $(mainmenu_item "${checklist[7]}" "Configure Fstab")"
  echo " 8) $(mainmenu_item "${checklist[8]}" "Configure Hostname")"
  echo " 9) $(mainmenu_item "${checklist[9]}" "Configure Timezone")"
  echo "10) $(mainmenu_item "${checklist[10]}" "Configure Hardware Clock")"
  echo "11) $(mainmenu_item "${checklist[11]}" "Configure Locale")"
  echo "12) $(mainmenu_item "${checklist[12]}" "Configure Mkinitcpio")"
  echo "13) $(mainmenu_item "${checklist[13]}" "Install Bootloader")"
  echo "14) $(mainmenu_item "${checklist[14]}" "Root Password")"
  echo ""
  echo " d) Done"
  echo ""
  read_input_options
  for OPT in ${OPTIONS[@]}; do
    case "$OPT" in
      1)
        select_keymap
        checklist[1]=1
        ;;
      2)
        select_editor
        checklist[2]=1
        ;;
      3)
        configure_mirrorlist
        checklist[3]=1
        ;;
      4)
        umount_partitions
        create_partition_scheme
        checklist[4]=1
        ;;
      5)
        [[ checklist[4] -eq 0 ]] && umount_partitions
        format_partitions
        checklist[5]=1
        ;;
      6)
        install_base_system
        configure_keymap
        checklist[6]=1
        ;;
      7)
        configure_fstab
        checklist[7]=1
        ;;
      8)
        configure_hostname
        checklist[8]=1
        ;;
      9)
        configure_timezone
        checklist[9]=1
        ;;
      10)
        configure_hardwareclock
        checklist[10]=1
        ;;
      11)
        configure_locale
        checklist[11]=1
        ;;
      12)
        configure_mkinitcpio
        checklist[12]=1
        ;;
      13)
        install_bootloader
        configure_bootloader
        checklist[13]=1
        ;;
      14)
        root_password
        checklist[14]=1
        ;;
      "d")
        finish
        ;;
      *)
        invalid_option
        ;;
    esac
  done
done
#}}}









