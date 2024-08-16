#!/bin/bash

echo "Starting test_script.sh..."  # Debugging output

# Source the final_url_checker.sh script to make its functions available
source ./final_url_checker.sh

# Function to compare JSON outputs
compare_json() {
    local expected="$1"
    local actual="$2"

    # Remove any extra text from the actual output and parse the JSON
    actual=$(echo "$actual" | jq 'del(.date)' 2>/dev/null)
    expected=$(echo "$expected" | jq 'del(.date)' 2>/dev/null)

    expected_url=$(echo "$expected" | jq -r '.url')
    actual_url=$(echo "$actual" | jq -r '.url')
    expected_status=$(echo "$expected" | jq -r '.statusCode')
    actual_status=$(echo "$actual" | jq -r '.statusCode')

    if [[ "$expected_url" == "$actual_url" && "$expected_status" == "$actual_status" ]]; then
        echo "Test Passed for $expected_url"
    else
        echo "Test Failed for $expected_url"
        echo "Expected: $expected"
        echo "Actual: $actual"
    fi
}


# Function to test a URL
test_url() {
    local url="$1"
    local expected="$2"
    echo "Testing URL: $url"  # Debugging output
    local actual=$(process_url "$url" 2>/dev/null)  # Suppress any stderr output
    echo "Actual Output: $actual"  # Debugging output
    compare_json "$expected" "$actual"
}

# Run your tests here
echo "Running test cases..."  # Debugging output

# Test valid URLs
test_url "https://www.bbc.co.uk/iplayer" '{
  "url": "https://www.bbc.co.uk/iplayer",
  "statusCode": 200,
  "contentLength": 567805,
  "requestDuration": "0ms"
}'
# Test invalid URL
test_url "bad://address" '{
  "url": "bad://address",
  "error": "Invalid URL"
}'

# Test non-existent domain
test_url "http://not.exists.bbc.co.uk/" '{
  "url": "http://not.exists.bbc.co.uk/",
  "statusCode": 504
}'


echo "Finished test_script.sh."  # Debugging output
