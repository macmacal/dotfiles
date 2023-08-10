#!/bin/sh
# Script for cleaning merged git branches
# Needs to be run inside a git repository

git remote prune origin
git branch --merged >/tmp/merged-branches && \
	nvim /tmp/merged-branches && xargs git branch -d </tmp/merged-branches
