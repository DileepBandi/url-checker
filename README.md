# URL Checker

This project includes scripts to validate and check the status of URLs. The main script, `final_url_checker.sh`, processes a list of URLs and outputs the status, content length, and response time in JSON format.

## How to Use

1. Ensure that all required scripts (`final_url_checker.sh`, `mock_url.sh`, `test_script.sh`, and `urls.txt`) are in the same directory.
2. Run the main script with a list of URLs:
   ```bash
   cat urls.txt | ./final_url_checker.sh
