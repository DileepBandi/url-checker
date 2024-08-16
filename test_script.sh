#!/bin/bash

# Source the final_url_checker.sh script to make its functions available
source ./final_url_checker.sh

# Function to compare JSON outputs
compare_json() {
    local expected="$1"
    local actual="$2"

    # Extract specific fields from expected and actual JSON
    expected_url=$(echo "$expected" | jq -r '.url')
    actual_url=$(echo "$actual" | jq -r '.url')
    expected_status=$(echo "$expected" | jq -r '.statusCode')
    actual_status=$(echo "$actual" | jq -r '.statusCode')

    echo "Comparing URL: $expected_url"
    echo "Expected Status: $expected_status"
    echo "Actual Status: $actual_status"

    if [[ "$expected_url" == "$actual_url" && "$expected_status" == "$actual_status" ]]; then
        echo "Test Passed"
    else
        echo "Test Failed"
        echo "Expected: $expected"
        echo "Actual: $actual"
    fi
}

# Function to test a URL
test_url() {
    local url="$1"
    local expected="$2"
    echo "Testing URL: $url"
    echo "Expected Output: $expected"
    local actual=$(validate_url "$url" 2>/dev/null)  # Suppress any stderr output
    echo "Actual Output: $actual"
    compare_json "$expected" "$actual"
}

# Test cases
test_url "https://www.bbc.co.uk/iplayer" '{
  "url": "https://www.bbc.co.uk/iplayer",
  "statusCode": 200
}'
test_url "bad://address" '{
  "url": "bad://address",
  "error": "Invalid URL"
}'
test_url "http://not.exists.bbc.co.uk/" '{
  "url": "http://not.exists.bbc.co.uk/",
  "statusCode": 504
}'
test_url "https://example.com/space%20test" '{
  "url": "https://example.com/space%20test",
  "statusCode": 200
}'

