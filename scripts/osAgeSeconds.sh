#!/bin/bash

birth_install=$(stat -c %W /)
current=$(date +%s)

echo $((current - birth_install))