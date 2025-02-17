# Hands-on Codescanning with Third party tool

This hands-on guide will help you understand how to integrate SAST tools to Code Scanning. You'll begin by forking this repository to your own GitHub account, and then implement a 3rd party tool and send the findings to Code Scanning.

Note: Ensure that GitHub Actions is enabled for your forked repository.

## Steps

# Step 1: Fork the Repository
Click the "Fork" button at the top-right corner of this page to create a copy of this repository under your own GitHub account.

# Step 2: Create a workflow
We will use checkov as SAST tool. you can use any other tool that can export the results as SARIF.
1. Create a new workflow called `/github/workflows/checkov.yml`
2. Paste the code into the file
```
name: Checkov Security Scan

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main
  workflow_dispatch:


jobs:
  checkov:
    name: Run Checkov
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Set Up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.x'

      - name: Install Checkov
        run: pip install checkov

      - name: Run Checkov and Generate SARIF Report
        run: checkov -d . --output sarif --output-file-path checkov-report.sarif

      - name: Upload SARIF Report to GitHub Security
        uses: github/codeql-action/upload-sarif@v3
        with:
          sarif_file: checkov-report.sarif
```



