function Validate-AMI {
    param (
        [string]$amiId,
        [string]$clientName
    )

    Write-Host "Validating AMI ID: $amiId" -ForegroundColor Cyan

    # Fetch AMI details (owned + shared)
    $amiDetails = aws ec2 describe-images --profile $clientName --image-ids $amiId --query "Images[*].{ID:ImageId,Owner:OwnerId}" --output json | ConvertFrom-Json

    if (-not $amiDetails -or $amiDetails.Count -eq 0) {
        Write-Host "❌ AMI ID '$amiId' is invalid or does not exist in the AWS account." -ForegroundColor Red
        exit 1
    }

    # Check if AMI is owned by the account or shared
    $accountId = aws sts get-caller-identity --profile $clientName --query "Account" --output text
    if ($amiDetails[0].Owner -eq $accountId) {
        Write-Host "✅ AMI ID '$amiId' is valid and owned by your AWS account." -ForegroundColor Green
    } else {
        Write-Host "⚠️ AMI ID '$amiId' is not owned by your AWS account (Owner: $($amiDetails[0].Owner))" -ForegroundColor Yellow
        Write-Host "Checking if the AMI is shared with your AWS account..." -ForegroundColor Cyan

        try {
            # Fetch AMI permissions
            $permissions = aws ec2 describe-image-attribute --profile $clientName --image-id $amiId --attribute launchPermission --query "LaunchPermissions[*].UserId" --output json | ConvertFrom-Json
            
            if ($permissions -contains $accountId) {
                Write-Host "✅ AMI ID '$amiId' is shared with your AWS account." -ForegroundColor Green
            } else {
                Write-Host "❌ AMI ID '$amiId' is NOT shared with your AWS account. Check AMI permissions." -ForegroundColor Red
                exit 1
            }
        } catch {
            Write-Host "⚠️ Unable to check AMI permissions due to missing IAM permission (ec2:DescribeImageAttribute)." -ForegroundColor Yellow
            Write-Host "Check your AWS IAM Role/User permissions or contact the AMI owner." -ForegroundColor Red
            exit 1
        }
    }
}
