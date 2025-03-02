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

# Initiate All nessary AWS resources

Write-Host "Initiate All nessary AWS resources ........" -ForegroundColor Yellow
Write-Host "Loading AWS Regions ........" -ForegroundColor Yellow

$validRegions = aws ec2 describe-regions --profile $clientName --query "Regions[*].RegionName" --output text | ForEach-Object { $_ -split "\s+" }

Write-Host "Complete AWS Regions Loading" -ForegroundColor Green

# Fetch available certificates
Write-Host "Fetching available SSL certificates..." -ForegroundColor Cyan
$certificates = aws acm list-certificates --profile $clientName --query "CertificateSummaryList[*].{ARN:CertificateArn,Domain:DomainName}" --output json | ConvertFrom-Json

# Check if certificates are available
if (-not $certificates -or $certificates.Count -eq 0) {
    Write-Host "❌ No available SSL certificates found in AWS ACM." -ForegroundColor Red
    exit 1
}

Write-Host "Successfully fetched available SSL certificates." -ForegroundColor Green

Write-Host "Complete all nessary AWS resources" -ForegroundColor Green

# Validate AWS profile
Write-Host "Checking AWS Profile ........" -ForegroundColor Yellow
$profileCheck = aws sts get-caller-identity --profile $clientName 2>&1
if ($profileCheck -match "could not be found") {
    Write-Host "Error: AWS profile '$clientName' is not valid or does not exist." -ForegroundColor Red
    exit 1
}
Write-Host "Checking AWS Profile Complete" -ForegroundColor Green

# Check if AWS S3 bucket exists for the client
$bucketName = "$clientName-terraform-state-bucket"
Write-Host "Checking AWS S3 Bucket ........" -ForegroundColor Yellow
$bucketCheck = aws s3api head-bucket --bucket $bucketName --profile $clientName 2>&1

if ($bucketCheck -match "404" -or $bucketCheck -match "NoSuchBucket") {
    Write-Host "Bucket does NOT exist: $bucketName" -ForegroundColor Red
    exit 1
} elseif ($bucketCheck -match "403") {
    Write-Host "Bucket exists but access is denied: $bucketName" -ForegroundColor Yellow
    exit 1
}
Write-Host "Checking AWS S3 Bucket Complete" -ForegroundColor Green


# Prompt user for variables
$isProd = Read-Host "Is this a production environment? (true/false)"
try {
    $isProd = [System.Convert]::ToBoolean($isProd)
} catch {
    Write-Host "Error: Invalid value for production environment. Please enter 'true' or 'false'." -ForegroundColor Red
    exit 1
}

$validEnvironments = @("Dev", "Test", "Prod", "Staging", "Sandbox")
$environment = $null

while ($environment -eq $null) {
    Write-Host "Select the environment to deploy:"
    for ($i = 0; $i -lt $validEnvironments.Count; $i++) {
        Write-Host "$($i + 1). $($validEnvironments[$i])"
    }

    $selection = Read-Host "Enter the number corresponding to the environment"

    if ($selection -match '^\d+$' -and $selection -gt 0 -and $selection -le $validEnvironments.Count) {
        $environment = $validEnvironments[$selection - 1]
    } else {
        Write-Host "Error: Invalid selection. Please enter a number between 1 and $($validEnvironments.Count)." -ForegroundColor Red
    }
}

$clientForceUrl = Read-Host "Enter if your client has specifc URL prefix (leave blank if not applicable)"

# Get the list of valid AWS regions dynamically

# Ensure the regions were retrieved successfully
if (-not $validRegions) {
    Write-Host "Error: Failed to retrieve AWS regions. Please check your AWS CLI and profile settings." -ForegroundColor Red
    exit 1
}

$clientRegion = $null

# Loop until a valid region is selected
while ($clientRegion -eq $null) {
    Write-Host "`nAvailable AWS Regions:"
    for ($i = 0; $i -lt $validRegions.Count; $i++) {
        Write-Host "$($i + 1). $($validRegions[$i])"
    }

    $selection = Read-Host "Enter the number corresponding to the AWS region"

    if ($selection -match '^\d+$' -and $selection -gt 0 -and $selection -le $validRegions.Count) {
        $clientRegion = $validRegions[$selection - 1]
    } else {
        Write-Host "Error: Invalid selection. Please enter a number between 1 and $($validRegions.Count)." -ForegroundColor Red
    }
}

Write-Host "✅ Selected AWS Region: $clientRegion" -ForegroundColor Green


# Display the list of available certificates
Write-Host "`nAvailable SSL Certificates:" -ForegroundColor Cyan
for ($i = 0; $i -lt $certificates.Count; $i++) {
    Write-Host "$($i + 1). $($certificates[$i].Domain)  -  $($certificates[$i].ARN)"
}

# Prompt user to select a certificate
$certificateArn = $null
while ($certificateArn -eq $null) {
    $selection = Read-Host "Enter the number corresponding to the certificate"

    if ($selection -match '^\d+$' -and $selection -gt 0 -and $selection -le $certificates.Count) {
        $certificateArn = $certificates[$selection - 1].ARN
    } else {
        Write-Host "❌ Invalid selection. Please enter a number between 1 and $($certificates.Count)." -ForegroundColor Red
    }
}

Write-Host "`n✅ Selected Certificate ARN: $certificateArn" -ForegroundColor Green

# Validate certificate status
Write-Host "Checking certificate status..." -ForegroundColor Yellow
$certStatus = aws acm describe-certificate --profile $clientName --certificate-arn $certificateArn --query "Certificate.Status" --output text

if ($certStatus -eq "ISSUED") {
    Write-Host "✅ Certificate is issued and valid!" -ForegroundColor Green
} elseif ($certStatus -eq "PENDING_VALIDATION") {
    Write-Host "⚠️ Certificate is pending validation." -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "❌ Certificate is either missing or in an invalid state: $certStatus" -ForegroundColor Red
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

$environment_lowerCase = $environment.ToLower()
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


