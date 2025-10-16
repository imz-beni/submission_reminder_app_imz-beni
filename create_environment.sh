#!/usr/bin/bash
read -p "Enter your name: " name
mkdir -p submission_reminder_$name
parent_dir="submission_reminder_'$name'"
mkdir -p "$parent_dir/app"
mkdir -p "$parent_dir/modules"
mkdir -p "$parent_dir/assets"
mkdir -p "$parent_dir/config"
