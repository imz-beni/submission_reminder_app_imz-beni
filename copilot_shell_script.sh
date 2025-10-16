#!/bin/bash
read -p "Enter your name :" name1

name1=$(echo "$name1" | tr  '[:upper:]' '[:lower:]' )
#to check if the variable is not empty
if [ -z "$name1" ]; then
    echo "Name cannot be empty. Please run the script again and provide a valid name."
    exit 1
fi
#to check if the name is valid
if [[ ! $name1 =~ ^[a-zA-Z]+$ ]]; then
    echo "Invalid name, please enter a name with alphabetic characters only."
    exit 1
fi

dir_name="submissions
_reminder_$name1"
submissions_file="$dir_name/assets/submissions.txt"
config_file="$dir_name/config/config.env"

#to check if the directory already exists
if [ ! -d "$dir_name" ]; then
echo "the directory does not exist"
exit 1
fi

read -p "enter the name of assignment: " assignment
read -p "enter the number of days remaining: " days_remaining

#to check if the assignment and days variables are empty
if [[ -z $assignment || -z $days_remaining ]]; then
    echo "Assignment name and days remaining cannot be empty."
    exit 1
fi

#to clean the days variable
days_remaining=$(echo "$days_remaining" | xargs)

#to validate assignment to only include alphabetic characters, numbers and spaces
if [[ ! $assignment =~ ^[a-zA-Z0-9\ ]+$ ]]; then
    echo "error: Assignment name should only contain alphabetic characters, numbers, and spaces."
    exit 1
fi

#to validate days to only include numbers
if [[ ! $days_remaining =~ ^[0-9]+$ ]]; then
echo "error: Days remaining should be a valid number."
exit 1
fi  

#to check if the assignment exists in the submissions file
matched_assignment=$(grep -i ", *$assignment," "$submissions_file" | awk -F',' '{print $2}' | head -n1 | xargs)
if [[ -z $matched_assignment ]]; then
    echo "Assignment '$assignment' not found in submissions file."
    exit 1
fi

#to update the config file with the new assignment and days remaining
cat <<EOF > $config_file
# This is the config file
ASSIGNMENT="$assignment"
DAYS_REMAINING=$days_remaining
EOF

read -p "Do you want to run the reminder script now? (y/n): " run_script

#to validate user input
if [[ $run_script =~ ^[Yy$]$ ]]; then
   echo "Running the script..."
   cd "$dir_name"
   ./startup.sh
else
    echo "You can run the script later by executing './startup.sh' inside the '$dir_name' directory."
fi