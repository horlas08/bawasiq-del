#!/bin/bash
rsync -a -R $(git diff --name-only "$1" "$2") "changedfiles"
git diff --name-status "$1" "$2" >>changedFiles.txt
