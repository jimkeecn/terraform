function Select-AwsKeyPair {
    param (
        [string]$clientName
    )

    Write-Host "Fetching available AWS key pairs..." -ForegroundColor Cyan
    $keyPairs = aws ec2 describe-key-pairs --profile $clientName --query "KeyPairs[*].KeyName" --output json | ConvertFrom-Json

    if (-not $keyPairs -or $keyPairs.Count -eq 0) {
        Write-Host "⚠ No key pairs found in AWS. Skipping key pair selection." -ForegroundColor Yellow
        return ""
    }

    # Add "None" option for skipping selection
    $keyPairs += "None"

    Write-Host "`nAvailable Key Pairs:"
    for ($i = 0; $i -lt $keyPairs.Count; $i++) {
        Write-Host "$($i + 1). $($keyPairs[$i])"
    }

    $selection = $null
    while ($selection -eq $null) {
        $input = Read-Host "`nEnter the number corresponding to the key pair (or select 'None' to skip)"

        if ($input -match '^\d+$' -and $input -gt 0 -and $input -le $keyPairs.Count) {
            $selection = $keyPairs[$input - 1]
        } else {
            Write-Host "❌ Invalid selection. Please enter a valid number." -ForegroundColor Red
        }
    }

    if ($selection -eq "None") {
        Write-Host "✅ No key pair selected. Proceeding without a key pair." -ForegroundColor Yellow
        return ""
    } else {
        Write-Host "✅ Selected Key Pair: $selection" -ForegroundColor Green
        return $selection
    }
}