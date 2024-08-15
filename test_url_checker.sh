#!/bin/bash

# Test with a known good URL
echo "https://www.google.com" | ./url_checker.sh

# Test with a known bad URL
echo "bad://address" | ./url_checker.sh

# Test with a non-existent domain
echo "http://nonexistent.domain" | ./url_checker.sh
