#!/bin/bash
#creates an app reminder for students to remind them of pending assignments

#ask for the user input and create a directory submission_reminder_{userinput}
read -p "Enter your name:" name
mkdir -p submission_reminder_$name

beni_dir="submission_reminder_$name"
#create subdirectories
mkdir -p "$beni_dir/app"
mkdir -p "$beni_dir/modules"
mkdir -p "$beni_dir/assets"
mkdir -p "$beni_dir/config"

#create the files in their respective subdirectories with their contents

echo '# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2' > $beni_dir/config/config.env

echo "student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Miguel, Git, submitted
Samuel, Shell Basics, not submitted
Axcel, Shell Navigation, submission
Keza, Shell Basics, submitted
David, Git, not submitted" > $beni_dir/assets/submissions.txt

echo '#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}' > $beni_dir/modules/functions.sh

echo '#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file' > $beni_dir/app/reminder.sh

echo '
if [ -f "./app/reminder.sh" ]; then
     ./app/reminder.sh
else
    echo "Error: reminder.sh not found!"
    exit 1
fi' > $beni_dir/startup.sh

#adding execution permissions to the shell scripts
chmod +x $beni_dir/app/reminder.sh
chmod +x $beni_dir/startup.sh   
chmod +x $beni_dir/modules/functions.sh
