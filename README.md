# DevTools - Homework 1: Bash Scripting & Git

This project was completed and submitted as part of the **Development Tools (DevTools)** course, Semester B 2026 at Afeka - Academic College of Engineering, Tel Aviv.

* **Course Instructor:** Mr. Tom Cohen.
* **Assignment Guidelines:** [2026B.devtools.HW1_BashScripting.pdf](file:///C:/Users/lidor/Documents/26b-10142-bash-shaked-lidor-eyal/2026B.devtools.HW1_BashScripting.pdf)

## Team Members
* **Lidor Even**
* **Shaked Gabay**
* **Eyal Goldstein**

## Selected Scripts

### Lidor's Scripts:
1. **Count Files by Extension** ([count_files_by_extension.sh](file:///C:/Users/lidor/Documents/26b-10142-bash-shaked-lidor-eyal/scripts/count_files_by_extension.sh))
   - **Description:** Recursively scans a directory and prints a sorted table showing the number of files for each file extension.
   - **Execution:** `bash scripts/count_files_by_extension.sh [path_to_directory]`
2. **Display Environment Variables** ([display_env_vars.sh](file:///C:/Users/lidor/Documents/26b-10142-bash-shaked-lidor-eyal/scripts/display_env_vars.sh))
   - **Description:** Displays important system environment variables with options to search, show all, or show key curated variables.
   - **Execution:** `bash scripts/display_env_vars.sh [option]` (Options: `-k` for key variables, `-a` for all variables, `-s [query]` for search)
3. **Find Large Files** ([find_large_files.sh](file:///C:/Users/lidor/Documents/26b-10142-bash-shaked-lidor-eyal/scripts/find_large_files.sh))
   - **Description:** Searches for files in a directory larger than a specified size threshold (e.g., 10M, 500K) and lists them with their sizes.
   - **Execution:** `bash scripts/find_large_files.sh [directory] [size_threshold]`
4. **Find Recently Modified Files** ([find_modified_files.sh](file:///C:/Users/lidor/Documents/26b-10142-bash-shaked-lidor-eyal/scripts/find_modified_files.sh))
   - **Description:** Finds all files in a specified directory modified within the last N days.
   - **Execution:** `bash scripts/find_modified_files.sh [directory] [days]`
5. **Sort Text File Alphabetically** ([sort_file_alphabetically.sh](file:///C:/Users/lidor/Documents/26b-10142-bash-shaked-lidor-eyal/scripts/sort_file_alphabetically.sh))
   - **Description:** Sorts the lines of a text file alphabetically with options to print to stdout, save to a new file, or overwrite the input file in-place.
   - **Execution:** `bash scripts/sort_file_alphabetically.sh <input_file> [options]`

### Shaked's Scripts:
1. **Add Prefix to Text Files** ([add_prefix.sh](file:///C:/Users/lidor/Documents/26b-10142-bash-shaked-lidor-eyal/scripts/add_prefix.sh))
   - **Description:** Adds a custom prefix to all `.txt` files in a specified directory.
   - **Execution:** `bash scripts/add_prefix.sh <directory_path> <prefix>`
2. **Network Connectivity Test** ([connectivity_test.sh](file:///C:/Users/lidor/Documents/26b-10142-bash-shaked-lidor-eyal/scripts/connectivity_test.sh))
   - **Description:** Tests internet connectivity by pinging Google Public DNS (`8.8.8.8`) and prints a status log including latency (RTT).
   - **Execution:** `bash scripts/connectivity_test.sh`
3. **Delete Old Files** ([del_old_files.sh](file:///C:/Users/lidor/Documents/26b-10142-bash-shaked-lidor-eyal/scripts/del_old_files.sh))
   - **Description:** Deletes files older than a specified number of days from a target directory.
   - **Execution:** `bash scripts/del_old_files.sh <directory_path> <number_of_days>`
4. **Compressed Tar Backup** ([tar_backup.sh](file:///C:/Users/lidor/Documents/26b-10142-bash-shaked-lidor-eyal/scripts/tar_backup.sh))
   - **Description:** Backs up a source directory into a compressed archive (`.tar.gz`) with a unique timestamp in the archive filename.
   - **Execution:** `bash scripts/tar_backup.sh <source_directory> [destination_directory]`
5. **Lines, Words, and Characters Counter** ([txt_counter.sh](file:///C:/Users/lidor/Documents/26b-10142-bash-shaked-lidor-eyal/scripts/txt_counter.sh))
   - **Description:** Counts the number of lines, words, and characters in each file of a specified directory and prints a formatted table.
   - **Execution:** `bash scripts/txt_counter.sh <directory_path>`

### Eyal's Scripts:
1. **Website Accessibility Check** ([check_website_access.sh.txt](file:///C:/Users/lidor/Documents/26b-10142-bash-shaked-lidor-eyal/scripts/check_website_access.sh))
   - **Description:** Reads a text file containing website URLs (one per line) and checks their accessibility using `curl`.
   - **Execution:** `bash scripts/check_website_access.sh [file]`
2. **Clean Project Temporary Files** ([clean_temp_files.sh.txt](file:///C:/Users/lidor/Documents/26b-10142-bash-shaked-lidor-eyal/scripts/clean_temp_files.sh))
   - **Description:** Cleans common temporary and build files/folders (such as `.class`, `.pyc`, `.tmp`, `.log`, `node_modules`, `__pycache__`) from a project directory.
   - **Execution:** `bash scripts/clean_temp_files.sh [project_directory]`
3. **Current User Information** ([current_user_info.sh.txt](file:///C:/Users/lidor/Documents/26b-10142-bash-shaked-lidor-eyal/scripts/current_user_info.sh))
   - **Description:** Displays information about the currently logged-in user, including username, home directory, groups, and configured shell.
   - **Execution:** `bash scripts/current_user_info.sh`
4. **On-Screen Reminder** ([screen_reminder.sh.txt](file:///C:/Users/lidor/Documents/26b-10142-bash-shaked-lidor-eyal/scripts/screen_reminder.sh))
   - **Description:** Schedules an on-screen text reminder to pop up after a specified delay in minutes.
   - **Execution:** `bash scripts/screen_reminder.sh [minutes] [message]`
5. **Word Frequency Count** ([word_frequency_count.sh.txt](file:///C:/Users/lidor/Documents/26b-10142-bash-shaked-lidor-eyal/scripts/word_frequency_count.sh))
   - **Description:** Analyzes a text file and prints a sorted list of word frequencies in descending order.
   - **Execution:** `bash scripts/word_frequency_count.sh [file]`

---

## Instructions for Users

### 1. Cloning the Project
To download the project to your local workspace, run the following commands in your terminal:
```bash
git clone [Your_Repository_Address]
cd 26b-10142-bash-shaked-lidor-eyal
```

### 2. Granting Executable Permissions
Before running the scripts for the first time in Linux, Unix, or Git Bash environments, grant executable permissions:
```bash
chmod +x scripts/*.sh scripts/*.txt
```

### 3. Running an Example Script
For example, to run the network connectivity check script:
```bash
./scripts/connectivity_test.sh
```
