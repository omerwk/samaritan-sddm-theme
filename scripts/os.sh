#!/bin/bash

source /etc/os-release
echo "$ID" | tr '[:lower:]' '[:upper:]'