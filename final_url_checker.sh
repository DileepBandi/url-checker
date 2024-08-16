#!/bin/bash

# Regular expression for URL validation
url_regex="^(https?|ftp)://[^\s/$.?#].[^\s]*$"

# Initialize counters for the summary
declare -A statusCodeCount
results=()

# Function to validate a URL and get HTTP response details
validate_url() {
    local url=$1

    if [[ $url =~ $url_regex ]]; then
        # Simulate HTTP response with the mock script (for offline testing)
        response=$(./mock_url.sh "$url")

        # Extract HTTP response details
        http_code=$(echo "$response" | grep "HTTP/1.1" | awk '{print $2}')
        content_length=$(echo "$response" | grep -i "Content-Length:" | awk '{print $2}')
        request_duration="0ms"  # Mocked value
        date=$(echo "$response" | grep -i "^Date:" | sed 's/Date: //i')

        # Handle cases where headers might be missing
        content_length=${content_length:-0}
        date=${date:-"Thu, 01 Aug 2024 00:00:00 GMT"}

        # Output JSON with HTTP details if valid
        if [[ "$http_code" =~ ^[0-9]+$ ]]; then
            echo "{"
            echo "  \"url\": \"$url\","
            echo "  \"statusCode\": $http_code,"
            echo "  \"contentLength\": $content_length,"
            echo "  \"requestDuration\": \"$request_duration\","
            echo "  \"date\": \"$date\""
            echo "}"
        else
            # Output JSON for invalid response
            echo "{"
            echo "  \"url\": \"$url\","
            echo "  \"error\": \"Invalid URL\""
            echo "}"
        fi
    else
        # Output JSON for invalid URL format
        echo "{"
        echo "  \"url\": \"$url\","
        echo "  \"error\": \"Invalid URL\""
        echo "}"
    fi
}

# Function to generate summary JSON
generate_summary() {
    summary="[]"
    for statusCode in "${!statusCodeCount[@]}"; do
        summary=$(echo "$summary" | jq --arg sc "$statusCode" --argjson count "${statusCodeCount[$statusCode]}" \
          '. += [{"statusCode": ($sc | tonumber), "numberOfResponses": $count}]')
    done
    echo "$summary"
}

# Read input URLs from stdin
urls=$(cat)

# Main execution
for url in $urls; do
    result=$(validate_url "$url")
    # Extract status code from result
    statusCode=$(echo "$result" | jq -r '.statusCode // empty')
    # Update status code count
    if [ "$statusCode" != "null" ] && [ -n "$statusCode" ]; then
        ((statusCodeCount[$statusCode]++))
    fi
    # Append result to results array
    results+=("$result")
done

summary=$(generate_summary)

# Output summary and results as a single valid JSON object
echo "{\"summary\": $summary, \"results\": $(printf '%s\n' "${results[@]}" | jq -s '.')}"
