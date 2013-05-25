#!/bin/bash
# Bash script that creates a Debian rootfs or even a complete bootable SD-Card for the Embedded Projects Gnublin board
# Should run on current Debian or Ubuntu versions
# Author: Ingmar Klein (ingmar.klein@hs-augsburg.de)
# Edited by Benedikt Niedermayr (niedermayr@embedded-projects.net)
#



# This program (including documentation) is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License version 3 (GPLv3; http://www.gnu.org/licenses/gpl-3.0.html ) for more details.


echo " " >> $logfile_build
echo " " >> $logfile_build
echo "#############################################" >> $logfile_build
echo "#         4th Stage: Build rootfs           #" >> $logfile_build 
echo "#############################################" >> $logfile_build	



trap cleanup INT
source $debian_build_path/build_functions.sh		 # functions called by this main build script



#########################
###### Main script ######
#########################


check_priviliges # check if the script was run with root priviliges
if [ ! -d "${output_dir}" ]
then
	mkdir -p ${output_dir} # main directory for the build process
	echo "Output directory '${output_dir}' successfully created."
else
	echo "Output directory '${output_dir}' already created."
fi


if [ ! -d "${output_dir}/tmp" ]
then
	mkdir ${output_dir}/tmp # subdirectory for all downloaded or local temporary files
	echo "Subfolder 'tmp' of output directory '${output_dir}' successfully created."
else
	echo "Output directory '${output_dir}/tmp' already created."
fi


check_n_install_prerequisites # see if all needed packages are installed and if the versions are sufficient

create_n_mount_temp_image_file # create the image file that is then used for the rootfs

do_debootstrap # run debootstrap (first and second stage)

disable_mnt_tmpfs # disable all entries in /etc/init.d trying to mount temporary filesystems (tmpfs), in order to save precious RAM

do_post_debootstrap_config # do some further system configuration

