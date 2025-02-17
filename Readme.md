# Hands-on Code Scanning with a Third-Party Tool  

This guide will help you integrate **Static Application Security Testing (SAST) tools** with GitHub Code Scanning. You'll fork this repository, implement a third-party SAST tool, and send the findings to GitHub Code Scanning.  

> **Note:** Ensure that **GitHub Actions** is enabled for your forked repository.  

## Steps  

### Step 1: Fork the Repository  
Click the **Fork** button at the top-right corner of this page to create a copy of this repository under your own GitHub account.  

### Step 2: Create a Workflow  

We will use **Checkov** as the SAST tool, but you can use any other tool that supports **SARIF** format for exporting results.  

1. Create a new workflow file at:  
   ```plaintext
   .github/workflows/checkov.yml
   ```
2. Copy and paste the following YAML configuration:
    ```yaml
    name: Checkov Security Scan  

    on:  
    push:  
        branches:  
        - main  
    pull_request:  
        branches:  
        - main  
    workflow_dispatch:  

    permissions:  
    contents: read  
    security-events: write  
    packages: read  
    pull-requests: read  

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
            continue-on-error: true  

        - name: Upload SARIF Report to GitHub Security  
          uses: github/codeql-action/upload-sarif@v3  
          with:  
            sarif_file: checkov-report.sarif  
    ```

### Step 3: Important Notes

- By default, Checkov exits with an error if it detects issues. To ensure that GitHub Actions proceeds to the next step and uploads the SARIF file, we use:
    ```yaml
    continue-on-error: true
    ```

- You can integrate other SAST tools, as long as they support SARIF format. Just ensure you use:
    ```yaml
    uses: github/codeql-action/upload-sarif@v3
    ```
    to upload the SARIF file to GitHub Code Scanning.

- Some tools report findings as `error` instead of GitHub’s standard severity levels (`critical`, `high`, `medium`, `low`). This may cause issues where certain findings are not displayed in GitHub reports.

In such cases, parse the SARIF file and adjust the security-severity property before uploading.
For more details, refer to the [GitHub SARIF documentation](https://docs.github.com/en/code-security/code-scanning/integrating-with-code-scanning/sarif-support-for-code-scanning#validating-your-sarif-file).

### Step 4: Expected Results

The Checkov workflow will run and analyze your project's code.
Navigate to the Security tab in your repository to view Checkov’s findings.

## Conclusion

By leveraging SARIF format, you can integrate multiple SAST tools into GitHub Code Scanning. This allows you to detect vulnerabilities that CodeQL might not cover, enhancing your project's security.