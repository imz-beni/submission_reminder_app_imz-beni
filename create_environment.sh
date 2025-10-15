#!/bin/bash
#creates an app reminder for students to remind them of pending assignments

#ask for the user input and create a directory submission_reminder_{userinput}
read -p "Enter your name:" yourname
mkdir -p submission_reminder_$yourname

parent_dir="submission_reminder_'$yourname'"
#create subdirectories
mkdir -p "$parent_dir/app"
mkdir -p "$parent_dir/modules"
mkdir -p "$parent_dir/assets"
mkdir -p "$parent_dir/config"

#create the files in their respective subdirectories with their contents

echo "# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
" > $parent_dir/config/config.env

echo "student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted" > $parent_dir/assets/submissions.txt

echo "#!/bin/bash

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
}
" > $parent_dir/modules/functions.sh

echo "#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
" > $parent_dir/app/reminder.sh

#create and paste the contents of submissions.txt

echo "Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Fred, Git, submitted
Bosco, Shell Basics, not submitted
Jojo, Shell Navigation, submission
Alicia, Shell Basics, submitted
Zacharia, Git, not submitted" > $parent_dir/assets/submissions.txt