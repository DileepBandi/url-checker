URL Checker Script
This project provides a Bash script that checks the validity of URLs, retrieves their HTTP response properties, and outputs the results in JSON format. The script can handle a list of URLs, identify invalid URLs, and process HTTP responses, including handling non-responsive requests.

Prerequisites
Before running the scripts, ensure you have the following prerequisites installed:

1. Bash Shell
Linux/Mac: Bash is installed by default.
Windows: Install Git Bash or use the Windows Subsystem for Linux (WSL).
2. jq Command-Line JSON Processor
Linux: Install via your package manager:


sudo apt-get install jq   # For Debian/Ubuntu-based distributions
sudo yum install jq       # For CentOS/RHEL
Mac: Install via Homebrew:
bash

brew install jq
Windows:
If using Git Bash: Download the jq Windows binary from the official jq website and add it to your PATH.
Installation
Clone the Repository



git clone https://github.com/DileepBandi/url-checker.git
cd url-checker
Set Executable Permissions
Ensure all scripts have executable permissions:


chmod +x final_url_checker.sh
chmod +x test_script.sh
chmod +x mock_url.sh
Usage
1. Running the URL Checker Script
To run the URL checker script on a list of URLs:



bash final_url_checker.sh

2. Alternative Method Using cat and a Pipe
If the script is set to read from stdin, you can use:



cat urls.txt | bash final_url_checker.sh
