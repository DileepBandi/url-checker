#!/bin/bash

# Function to validate URL
validate_url() {
    if [[ $1 =~ ^https?:// ]]; then
        return 0
    else
        return 1
    fi
}

# Read input from a file if provided, otherwise read from stdin
if [ -n "$1" ]; then
    urls=$(cat "$1")
else
    urls=$(cat)
fi

# Initialize the JSON output
output="["

# Initialize the status code count array
declare -A status_codes

# Iterate over each URL
for url in $urls; do
    if validate_url "$url"; then
        start_time=$(date +%s%3N)
        response=$(curl -s -o /dev/null -w "%{http_code},%{size_download},%{time_total},%{date}" "$url" 2>/dev/null)
        status_code=$(echo $response | cut -d',' -f1)
        content_length=$(echo $response | cut -d',' -f2)
        request_duration=$(echo $response | cut -d',' -f3)
        date=$(echo $response | cut -d',' -f4)

        # Update status code count
        if [[ -z "${status_codes[$status_code]}" ]]; then
            status_codes[$status_code]=1
        else
            status_codes[$status_code]=$((status_codes[$status_code]+1))
        fi

        # Append the result to the output
        output+="{\"url\": \"$url\", \"statusCode\": $status_code, \"contentLength\": $content_length, \"requestDuration\": \"${request_duration}s\", \"date\": \"$date\"},"
    else
        # Handle invalid URLs
        output+="{\"url\": \"$url\", \"error\": \"invalid url\"},"
    fi
done

# Close the JSON array
output="${output%,}]"

# Output the summary header
summary="["
for code in "${!status_codes[@]}"; do
    summary+="{\"statusCode\": $code, \"numberOfResponses\": ${status_codes[$code]}},"
done
summary="${summary%,}]"

# Combine summary and main output
final_output="{\"summary\": $summary, \"responses\": $output}"

# Output the JSON result
echo $final_output | jq .  # using jq for pretty-printing the JSON

