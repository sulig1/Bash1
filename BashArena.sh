#1 Mission: Create a directory named Arena and then inside it, create three files: warrior.txt, mage.txt, and archer.txt. List the contents of the Arena directory.
mkdir -p Arena
touch Arena/warrior.txt Arena/mage.txt Arena/archer.txt

#2 Create a script that outputs the numbers 1 to 10, one number per line.

i=1
while [ $i -le 10]; do
    echo "$i"
    ((i++))
done

#3 Mission: Write a script that checks if a file named hero.txt exists in the Arena directory. If it does, print Hero found!; otherwise, print Hero missing!
#filecheck.sh

#!/bin/bash
file=Arena/hero.txt
if [ -f "$file" ]
then 
    echo "Hero Found!"
else 
    echo "Hero Missing!"
fi

#4 Create a script that copies all .txt files from the Arena directory to a new directory called Backup.
mkdir Backup
cp Arena/*.txt Backup

#5 Mission: Combine what you've learned! Write a script that:

#1. Creates a directory names 'Battlefield'
#2. Inside Battlefield, create files named knight.txt, sorcerer.txt, and rogue.txt.
#3. Check if knight.txt exists; if it does, move it to a new directory called Archive.
#4. List the contents of both Battlefield and Archive.

#combining.sh
mkdir -p Battlefield
touch Battlefield/knight.txt Battlefield/sorcerer.txt Battlefield/rogue.txt

file=Battlefield/knight.txt
if [ -f "$file" ]; then 
    mkdir Archive
    mv "$file" Archive
    echo "'$file' has been moved to Archive"
else 
    echo "'$file' does not exist!"

fi

echo "The contents of Battlefield are: "
ls Battlefield

echo "The contents of Archive are: "
ls Archive

#6 Write a script that accepts a filename as an argument and prints the number of lines in that file. If no filename is provided, display a message saying 'No file provided'.
#file_line_check 
file_name=$1
num_arguments=$#

if [ $num_arguments -eq 0 ]
then 
    echo "No file provided"
elif [ -f $file_name ]; then
    num_lines=$(wc -l < "$file_name")
    echo "The number of lines in '$file_name' is $num_lines"
else 
    echo "$file_name does not exist"
fi

#7 Write a script that sorts all .txt files in a directory by their size, from smallest to largest, and displays the sorted list.
ls -Sr directory

#8 Create a script that searches for a specific word or phrase across all .log files in a directory and outputs the names of the files that contain the word or phrase.
grep -l "phrase" directory/*.log 

#9 Write a script that monitors a directory for any changes (file creation, modification, or deletion) and logs the changes with a timestamp.
# detect.sh
touch change.txt
directory=Battlefield

touch change.txt
inotifywait -m -r -e create -e modify -e delete --format '%T %e %w%f' --timefmt '%Y-%m-%d %H:%M:%S' "$directory" | while read time event path; do 
    echo "$time $event: $path" >> change.txt
done 

#10 Mission: Write a script that: 
#Creates a directory called Arena_Boss.
#Creates 5 text files inside the directory, named file1.txt to file5.txt.
#Generates a random number of lines (between 10 and 20) in each file.
#Sorts these files by their size and displays the list.
#Checks if any of the files contain the word 'Victory', and if found, moves the file to a directory called Victory_Archive.

mkdir -p Arena_Boss 

i=1
while [ $i -le 5 ]
do 
touch Arena-Boss/file$i.txt
((i++))
done

#the following generates a random number between 1-20 $((RANDOM % 11 + 10))
directory=Arena_Boss

for file in $directory/*
do 

random=$((RANDOM % 11 + 10))
for number in $(seq 1 $random) 
do 
    echo "This is line $number" >> $file
done

done

directory=Arena_Boss
ls -Sr $directroy/*

directory=Arena_Boss
mkdir -p Victory_Archive
grep -l "Victory" $directory/* | while read file; do
mv $file Victory_Archive
done


#11 Create a script that checks the disk space usage of a specified directory and sends an alert if the usage exceeds a given threshold.
directory=Battlefield
disk_space=$(du -s "$directory" | cut -f1)
if [ $disk_space -ge 91 ];then
    echo "Usage is way too high!!"
else
    echo "the disk space usage for $directory is $disk_space"

fi

#12 Write a script that reads a configuration file in the format KEY=VALUE and prints each key-value pair.

info.txt
Name=Sulaiman
Age=25
Skill=DevOps

cat info.txt | while IFS='=' read Key Value; do
echo "Key=$Key, Value=$Value"
done

#13 Create a script that backs up a directory to a specified location and keeps only the last 5 backups.

Each backup is a file
A file which can be opened

mkdir -p BUdirectory
timestamp=$(date +'%Y-%m-%d_%H-%M-%S')
backupname="backup_$timestamp.tar.gz"

tar -czf "BUdirectory/$backupname" "sourceDirectory"

cd BUdirectory || exit 1 
ls -t | sed -e '1,5d' | while read -r file 
do 

rm -rf "$file"

done


#14 Create an interactive script that presents a menu with options for different system tasks
# (e.g., check disk space, show system uptime, list users), 
# and executes the chosen task.

echo -e "Choose from the following tasks: \ncheck disk space \nshow system uptime \nlist users"
read task 

case "$task" in 

check disk space)
    echo "You have chosen to check disk space"
    disk_space=$(du -s Battlefield)
    echo "The disk space usage is: $disk_space";;
show system uptime)
    echo "You have chosen to show system uptime"
    system_uptime=$(uptime)
    echo "The system uptime is: $system_uptime";;
list users)
    echo "You have chosen to list users"
    user_list=$(cut -d: -f1 /etc/passwd)
    echo "list of users: $user_list";;
*)
    echo "You have not chosen a valid option";;

esac


#15 1. Presents a menu to the user with the following options:

- Check disk space
- Show system uptime
- Backup the Arena directory and keep the last 3 backups
- Parse a configuration file settings.conf and display the values

Execute the chosen task.

#!/bin/bash

echo "1: Check disk space"
echo "2: Show system uptime"
echo "3: Backup the Arena directory and keep the last 3 backups"
echo "4: Parse a configuration file settings.conf and display the values"

read -p "Choose from options [1-4]: " choice

case "$choice" in 

1)
    echo "You have chosen: $choice"
    usage=$(df -H)
    echo "The disk space is:" 
    echo "$usage"
    ;;

2)
    echo "You have chosen: $choice"
    uptime_output=$(uptime)
    echo -e "System uptime:\n$uptime_output"
    ;;

3)
    echo "You have chosen: $choice"

    mkdir -p Arena_Backup  # typo fix: Arena_Bakcup → Arena_Backup
    backup_name="$(date +'%Y-%m-%d_%H-%M-%S').tar.gz"
    tar -czf "Arena_Backup/$backup_name" Arena

    # Keep only 3 most recent backups
    ls -t Arena_Backup | sed -e '1,3d' | while read file; do 
        rm -f "Arena_Backup/$file"
    done
    ;;

4)
    echo "You have chosen: $choice"
    config_file="settings.conf"
    if [[ -f "$config_file" ]]; then
        while IFS='=' read -r key value; do 
            echo "Key: $key, Value: $value"
        done < "$config_file"
    else
        echo "Configuration file '$config_file' not found."
    fi
    ;;

*)
    echo "You have not picked a valid option."
    ;;
esac
