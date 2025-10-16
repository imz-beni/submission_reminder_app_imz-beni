# Submission Reminder App

A small set of bash scripts that check a CSV-style submissions list and print reminders for students who have not submitted a specific assignment. The scripts are lightweight and intentionally simple so they can run on any system with bash (Linux/macOS) or on Windows using WSL, Git Bash, or similar.

## Table of Contents
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Project Layout](#project-layout)
- [Configuration](#configuration)
- [Submissions File Format](#submissions-file-format)
- [How to Run](#how-to-run)
- [Example: Edit Config and Re-run](#example-edit-config-and-re-run)
- [Common Issues & Troubleshooting](#common-issues--troubleshooting)
- [Extending this Project](#extending-this-project)
- [License & Contribution](#license--contribution)

## Features

- Read a submissions file (CSV-like) and print reminders for students with status `not submitted` for a configured assignment.
- Configuration is stored in a simple env file (`ASSIGNMENT` and `DAYS_REMAINING`).
- Includes an interactive helper (`copilot_shell_script.sh`) to create/update a per-user project directory and config.

## Prerequisites

- bash (any POSIX-compatible shell)
- On Windows, run scripts from WSL, Git Bash, or a similar environment that provides bash and standard Unix utilities.
- Ensure scripts are executable. If not, run:

```bash
chmod +x *.sh
chmod +x submission_reminder_axel/*.sh
chmod +x submission_reminder_axel/app/*.sh
chmod +x submission_reminder_axel/startup.sh
```

## Project layout

- `copilot_shell_script.sh` — interactive helper that prompts for a username, assignment name, and days remaining; updates a per-user config and can run the reminder.
- `reminder.sh` — root reminder entrypoint (sources `config.env` and `modules/functions.sh` when run from `submission_reminder_axel`).
- `functions.sh` — helper function used by the root scripts to parse the submissions file and print reminders.
- `create_environment.sh` — helper for environment setup (if provided).
- `config.env` — root configuration file with variables `ASSIGNMENT` and `DAYS_REMAINING`.
- `submissions.txt` — top-level submissions file used as example data.
- `submission_reminder_axel/` — packaged app folder; contains its own `startup.sh`, `app/reminder.sh`, `assets/submissions.txt`, `config/config.env`, and `modules/functions.sh`.

## Configuration

There are two configuration places used in the repo:

- Root config: `config.env` — used by the root-level scripts if you run them from the repo root.
- Per-app config: `submission_reminder_axel/config/config.env` — used when running the packaged app (`submission_reminder_axel/startup.sh`).

Both files use the same variables:

- `ASSIGNMENT` — assignment name (string, quoted or unquoted). Example: ASSIGNMENT="git"
- `DAYS_REMAINING` — integer days remaining until the deadline.

You can edit these files manually with a text editor or use the interactive `copilot_shell_script.sh` to update a user-specific folder (see "Interactive setup").

## Submissions file format

The scripts expect a CSV-like file with the following header (first line):

```
student, assignment, submission status
```

Each subsequent line should follow the same comma-separated pattern. Example lines from `assets/submissions.txt`:

```
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
```

The scripts check the `assignment` column for a match with `ASSIGNMENT` and the `submission status` column for the exact string `not submitted` (case-sensitive in current implementation). If both match, the script prints a reminder for that student.

Notes:
- Avoid adding extra commas inside fields (no quoting parser is implemented).
- Whitespace around fields is trimmed by the scripts.

## How to run

There are a few ways to run the reminders depending on which folder/config you want to use.

1) Run the packaged app (recommended):

```bash
cd submission_reminder_axel
./startup.sh
```

This runs `app/reminder.sh` which:
- sources `config/config.env` to load `ASSIGNMENT` and `DAYS_REMAINING`
- uses `modules/functions.sh` to check `assets/submissions.txt`

2) Run the root reminder directly (uses root `config.env` and `submissions.txt`):

```bash
./reminder.sh
```

3) Use the interactive helper `copilot_shell_script.sh` to set up or update a user directory and optionally run the reminder there.

```bash
./copilot_shell_script.sh
```

The script will prompt for a name, assignment, and days remaining. Important: it expects a directory named `submission_reminder_<name>` to already exist in the current working directory. The script will validate inputs and update `submission_reminder_<name>/config/config.env`.

If you choose to run the reminder immediately from the helper, it will `cd` into the directory and run `./startup.sh`.

## Example: Edit config and re-run

Edit `submission_reminder_axel/config/config.env`, set:

```text
ASSIGNMENT="git"
DAYS_REMAINING=5
```

Then run:

```bash
cd submission_reminder_axel
./startup.sh
```

Expected output (example):

```
Assignment: git
Days remaining to submit: 5 days
--------------------------------------------
Reminder: David has not submitted the git assignment!
```

## Common issues & troubleshooting

- "Error: reminder.sh not found!" — make sure you're in the `submission_reminder_axel` directory and `app/reminder.sh` exists and is executable.
- "permission denied" — ensure scripts are executable (`chmod +x ...`) or run them with `bash ./script.sh`.
- Wrong/missing reminders — check `config/config.env` (ASSIGNMENT value) and ensure the `assets/submissions.txt` file uses the expected CSV format and the `submission status` field contains `not submitted` for outstanding students.
- On Windows, prefer running inside WSL or Git Bash to get consistent behavior with `tail`, `xargs`, and process substitutions used by the helper scripts.

## Extending this project

- Add a small parser to support quoted CSV fields and case-insensitive status matching.
- Add output options: send emails, write to a file, or integrate with Slack.

## License & contribution

Feel free to open issues or PRs. This project is provided as-is; add a LICENSE file if you want a formal license.

---

If you'd like, I can also:
- make the scripts accept a path argument for the submissions file,
- add a case-insensitive comparison for statuses,
- or implement a small test harness that runs the scripts against sample data.


