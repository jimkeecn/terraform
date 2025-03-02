# Check if Terraform is installed
if (!(Get-Command terraform -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Terraform is not installed. Please install Terraform and try again." -ForegroundColor Red
    exit 1
}

# Check if AWS CLI is installed
if (!(Get-Command aws -ErrorAction SilentlyContinue)) {
    Write-Host "Error: AWS CLI is not installed. Please install AWS CLI and try again." -ForegroundColor Red
    exit 1
}


# Prompt user for Client Name
$clientName = Read-Host "Enter the client name (e.g., acme, cxiregistry, testco, other)"
$clientName = $clientName.ToLower()

# Validate AWS profile
$profileCheck = aws sts get-caller-identity --profile $clientName 2>&1
if ($profileCheck -match "could not be found") {
    Write-Host "Error: AWS profile '$clientName' is not valid or does not exist." -ForegroundColor Red
    exit 1
}

# Check if AWS S3 bucket exists for the client
$bucketName = "$clientName-terraform-state-bucket"
$bucketCheck = aws s3api head-bucket --bucket $bucketName --profile $clientName 2>&1

if ($bucketCheck -match "404" -or $bucketCheck -match "NoSuchBucket") {
    Write-Host "Bucket does NOT exist: $bucketName" -ForegroundColor Red
    exit 1
} elseif ($bucketCheck -match "403") {
    Write-Host "Bucket exists but access is denied: $bucketName" -ForegroundColor Yellow
    exit 1
}


# Prompt user for variables
$isProd = Read-Host "Is this a production environment? (true/false)"
if ($isProd -ne "true" -and $isProd -ne "false") {
    Write-Host "Error: Invalid value for production environment. Please enter 'true' or 'false'." -ForegroundColor Red
    exit 1
}

$environment = Read-Host "Enter the environment to deploy (Dev, Test, Prod, Staging, Sandbox)"
if ($environment -notin @("Dev", "Test", "Prod", "Staging", "Sandbox")) {
    Write-Host "Error: Invalid environment. Please enter one of the following: Dev, Test, Prod, Staging." -ForegroundColor Red
    exit 1
}

$environment_lowerCase = $environment.ToLower()

$clientForceUrl = Read-Host "Enter the client URL for Route 53 (leave blank if not applicable)"

$clientRegion = Read-Host "Enter the client AWS region"
if ($clientRegion -eq "") {
    Write-Host "Error: AWS region cannot be empty." -ForegroundColor Red
    exit 1
}

$certificateArn = Read-Host "Enter the AWS certificate ARN"
if ($certificateArn -eq "") {
    Write-Host "Error: Certificate ARN cannot be empty." -ForegroundColor Red
    exit 1
}

$uiAmiId = Read-Host "Enter the AMI ID for the UI instance"
if ($uiAmiId -eq "") {
    Write-Host "Error: AMI ID for the UI instance cannot be empty." -ForegroundColor Red
    exit 1
}

$dbAmiId = Read-Host "Enter the AMI ID for the DB instance"
if ($dbAmiId -eq "") {
    Write-Host "Error: AMI ID for the DB instance cannot be empty." -ForegroundColor Red
    exit 1
}

$uiKey = Read-Host "Enter the key for the UI instance"
if ($uiKey -eq "") {
    Write-Host "Error: Key for the UI instance cannot be empty." -ForegroundColor Red
    exit 1
}

$dbKey = Read-Host "Enter the key for the DB instance"
if ($dbKey -eq "") {
    Write-Host "Error: Key for the DB instance cannot be empty." -ForegroundColor Red
    exit 1
}

$sslPolicy = Read-Host "Enter the SSL policy (leave blank for default)"

if ($sslPolicy -eq "") {
    $sslPolicy = "ELBSecurityPolicy-2016-08"
}

# Fetch all available SSL policies
$availablePolicies = aws elbv2 --profile $clientName describe-ssl-policies --query "SslPolicies[*].Name" --output json | ConvertFrom-Json

# Check if the provided SSL policy exists
if ($availablePolicies -contains $sslPolicy) {
    Write-Host "SSL Policy is valid: $sslPolicy" -ForegroundColor Green
} else {
    Write-Host "Error: SSL Policy does not exist in AWS: $sslPolicy" -ForegroundColor Red
    exit 1
}

# Create a hashtable to store the variables
$variables = @{
    is_prod = $isProd
    environment = $environment
    client_name = $clientName
    client_force_url = $clientForceUrl
    client_region = $clientRegion
    certifcate_arn = $certificateArn
    ui_ami_id = $uiAmiId
    db_ami_id = $dbAmiId
    ui_key = $uiKey
    db_key = $dbKey
    ssl_policy = $sslPolicy
}

# Define source and destination paths
$sourcePath = "./template"

$destinationPath = "./env/$environment_lowerCase"

# Check if the source folder exists
if (!(Test-Path -Path $sourcePath)) {
    Write-Host "Error: Source folder '$sourcePath' does not exist." -ForegroundColor Red
    exit 1
}

# Create destination folder if it does not exist
if (!(Test-Path -Path $destinationPath)) {
    New-Item -ItemType Directory -Path $destinationPath | Out-Null
    Write-Host "Created environment folder: $destinationPath" -ForegroundColor Green
} else {
    Write-Host "Environment folder already exists: $destinationPath" -ForegroundColor Yellow
}

# Copy all files from template to the new environment folder
Copy-Item -Path "$sourcePath\*" -Destination $destinationPath -Recurse -Force

Write-Host "All files copied from '$sourcePath' to '$destinationPath'" -ForegroundColor Green

