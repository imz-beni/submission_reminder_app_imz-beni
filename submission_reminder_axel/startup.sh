
if [ -f "./app/reminder.sh" ]; then
     ./app/reminder.sh
else
    echo "Error: reminder.sh not found!"
    exit 1
fi
