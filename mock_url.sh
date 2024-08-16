#!/bin/bash

echo "Mock URL script started"  # Debugging output

url=$1

# Simulate different responses based on the URL
case $url in
    *"bbc.co.uk"*)
        echo "HTTP/1.1 200 OK"
        echo "Date: $(date -u)"
        echo "Content-Length: 567805"
        ;;
    *"not.exists.bbc.co.uk"*)
        echo "HTTP/1.1 504 Gateway Timeout"
        echo "Date: $(date -u)"
        echo "Content-Length: 0"
        ;;
    *"timeout.test"*)
        # Simulate a timeout (no response)
        echo "Simulating timeout..."  # Debugging output
        sleep 10  # Simulate a long delay
        ;;
    *"space%20test"*)
        echo "HTTP/1.1 200 OK"
        echo "Date: $(date -u)"
        echo "Content-Length: 12345"
        ;;
    *)
        echo "HTTP/1.1 400 Bad Request"
        echo "Date: $(date -u)"
        ;;
esac

echo "Mock URL script completed"  # Debugging output
