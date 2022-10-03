#!/bin/bash

# Local variables
default_src="$HOME/Downloads/Movies/HD/"
default_dest="/Volumes/My\ Passport/Movies/HD/"

usage()
{
	echo "./backup              (backup default source to default destination)"
	echo "./backup -s path      (backup specific source to default destination)"
	echo "./backup -d path      (backup default source to specific destination)"
    echo "./backup -e           empty out hd directory"
	echo "./backup    path path (backup specific source to specific destination)"
	press
	clear
}

dest_status()
{
	echo
	df -h | grep "$2" |awk '{print $4, $5, $9}'
}

# Function to prompt for key return until then wait
press()
{
	read -r -p "Press [Enter] key to continue..."
	clear
}

# Function to backup default source to default destination
default()
{
	rsync -a --info=progress2 "$default_src/" "$default_dest/"
}

# Function to backup specific source to default destination
src()
{
	rsync -a --info=progress2 "$2/" "$default_dest/"
}

# Function to backup default source to specific destination
dest()
{
	rsync -a --info=progress2 "$default_src/" "$2/"
}

# Clean up HD directory
empty()
{
	find "$default_src" -depth -type d -name '*\[*' -prune -print -exec rm -rf {} ';'
	find "$default_src" -type f -delete
	find "$default_src" -type d -mtime +30 -delete
}

# Function to backup specific source to specific destination
src_dest()
{
	rsync -a --info=progress2 "$1/" "$2/"
}

# ---------- Main ----------
clear
if [ "$#" -eq 0 ]
then
	default
elif [ "$#" -eq 1 ]
then
    if [ "$1" = "-e" ]
    then
       empty
    else
       usage
    fi
elif [ "$#" -eq 2 ]
then
	if [ "$1" = "-s" ]
	then
		src "$@"
		dest_status "$@"
	elif [ "$1" = "-d" ]
	then
		dest "$@"
		dest_status "$@"
	elif [[ "$1" == "-"* ]]
	then
		usage
	else
		src_dest "$@" "$@"
		dest_status "$@"
	fi
else
	usage
fi
# ------------------ End of File --------------------