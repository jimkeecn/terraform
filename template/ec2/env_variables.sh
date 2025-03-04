#get value from terraform script
param (
    [string]$environment,
    [string]$client_name
    [string]$client_force_url
	[string]$client_region
)

$apiUrl = $environment+"-api"
$dbUrl = $environment+"-db"
$investorPortalAPI = "$client_name-$environment-invportal"

# Load the .env file and set the variables
$AWS_ACCESS_KEY_ID
$AWS_SECRET_ACCESS_KEY
$Database_Password
$MasterSoftSecretKey
$GreenIDSecretKey
$SendGridKey

# Get the parent directory of the script
$parentDir = Split-Path -Parent $PSScriptRoot
$envFilePath = Join-Path $parentDir ".env"

# Check if the .env file exists in the parent directory
if (!(Test-Path $envFilePath)) {
    Write-Host "Error: .env file not found in parent directory!" -ForegroundColor Red
    exit 1
}

# Read the .env file and load values
Get-Content $envFilePath | ForEach-Object {
    if ($_ -match "^(.*?)=(.*)$") {
        $key = $matches[1].Trim()
        $value = $matches[2].Trim()

        # Set the variable dynamically
        Set-Variable -Name $key -Value $value -Scope Script

        Write-Host "Loaded: $key"
    }
}

Write-Host "✅ .env variables loaded successfully from $envFilePath." -ForegroundColor Green

# Use the loaded variables
Write-Host "AWS Access Key ID: $AWS_ACCESS_KEY_ID"
Write-Host "AWS Region: $AWS_REGION"
Write-Host "Database Password: $Database_Password"
Write-Host "MasterSoft Secret Key: $MasterSoftSecretKey"
Write-Host "GreenID Secret Key: $GreenIDSecretKey"
Write-Host "SendGrid Key: $SendGridKey"


$variables = @{
	"APIEndpointBatchjob" = "https://$apiUrl.clients.cx:11005/api/";
	"APIEndpointFundEnquiry" = "https://$apiUrl.clients.cx:11010/api/";
	"APIEndpointFundStaticData" = "https://$apiUrl.clients.cx:11015/api/";
	"APIEndpointGeneral" = "https://$apiUrl.clients.cx:11020/api/";
	"APIEndpointInvestorEnquiry" = "https://$apiUrl.clients.cx:11025/api/";
	"APIEndpointInvestorStaticData" = "https://$apiUrl.clients.cx:11030/api/";
	"APIEndpointManualTransactions" = "https://$apiUrl.clients.cx:11035/api/";
	"APIEndpointReport" = "https://$apiUrl.clients.cx:11040/v1/reports/";
	"APIEndpointSystemAdmin" = "https://$apiUrl.clients.cx:11045/api/";
	"APIEndpointTelerikReport" = "https://$apiUrl.clients.cx:11050/v1/api/reports/";
	"APIEndpointTelerikServer" = "https://$apiUrl.clients.cx:11070";
	"APIEndPointWebHooks" = "https://$apiUrl.clients.cx:11060/api/";	
	"APIEndpointInvestorPortal" = "https://$investorPortalAPI.clients.cx/v1/api/"; 

	#DB ConnectionString
	"DBConnectionTaurus" = "data source=$dbUrl.clients.cx,1433;initial catalog=TAURUS;user id=sa;password=$Database_Password;Max Pool Size=50000;Pooling=True;TrustServerCertificate=True;";
	"DBConnectionTaurusNew" = "data source=$dbUrl.clients.cx,1433;initial catalog=TAURUS;user id=sa;password=$Database_Password;Command Timeout=300;TrustServerCertificate=True;";
	"DBConnectionHangfire" ="data source=$dbUrl.clients.cx, 1433; Database=Hangfire;user id=sa;password=$Database_Password;";
	"DBConnectionHangfireGeneral" ="data source=$dbUrl.clients.cx, 1433; Database=HangfireGeneral;user id=sa;password=$Database_Password;";
	"DBConnectionHangfireWebHooks" ="data source=$dbUrl.clients.cx, 1433; Database=HangfireWebHooks;user id=sa;password=$Database_Password;";

	#Address Lookup
	"MastersoftAccessKey" = "CXiController";
	"MasterSoftSecretKey" = $MasterSoftSecretKey;
    #Green ID
	"GreenIDAccessKey" = "cxisoftware";
	"GreenIDRule" = "default";
    "GreenIDSecretKey" = $GreenIDSecretKey;
    #SendGrid
    "SendGridKey" = $SendGridKey;

	#UI S3 BUCKET
	"AwsOriginalBucketName" = "$client_name-$environment-taurus-filestorage";
	"AwsOriginalBucketUrl" = "https://s3-ap-southeast-2.amazonaws.com/$client_name-$environment-taurus-filestorage/";	
    "AwsReportBucketName" = "https://s3-ap-southeast-2.amazonaws.com/$client_name-$environment-taurus-filestorage/";	
	"AwsResizedBucketName" = "$client_name-$environment-report-central-storage";
	"AwsResizedBucketUrl" = "https://s3-ap-southeast-2.amazonaws.com/$client_name-$environment-taurus-filestorage/resized/";
    "AwsVaultName" = "$client_name-$environment-taurus-filestorage";
    "AwsAccessId" = $AWS_ACCESS_KEY_ID;
	"AwsAccessKey" = $AWS_SECRET_ACCESS_KEY;
    "AwsRegion" = $client_region;

	"DomainName" = "https://$client_name-$environment.clients.cx";
	"EnvironmentID" = $environment;
	"Client_Name" = $client_name;

	"InvestorPortalS3BucketName" = "$client_name-$environment-taurus-filestorage";

	#Auth0 Set later because this is high dependent on the auth0 setup.
	"Auth0Domain" = ""
    "Auth0ManagementApiIdentifier" = ""
    "Auth0InvestorPortalApiIdentifier" = ""
    "Auth0AdvisorPortalApiIdentifier" = ""
    "Auth0InvestorPortalM2MClientId" = ""
    "Auth0InvestorPortalM2MClientSecret" = ""
    "Auth0InvestorPortalSwaggerClientId" = ""
    "Auth0InvestorPortalSwaggerClientSecret" = ""
    "Auth0AdvisorPortalM2MClientId" = ""
    "Auth0AdvisorPortalM2MClientSecret" = ""
    "Auth0AdvisorPortalSwaggerClientId" = ""
    "Auth0AdvisorPortalSwaggerClientSecret" = ""
    "Auth0InvestorDatabase" = ""
    "Auth0AdvisorDatabase" = ""
    "Auth0AdviserPortalManagementApiClientID" = ""
    "Auth0AdviserPortalManagementApiClientSecret" = ""
}

# Loop through each key-value pair in the hashtable
foreach ($variable in $variables.GetEnumerator()) {
    # Set the environment variable using the key and value from the hashtable
    [System.Environment]::SetEnvironmentVariable($variable.Name, $variable.Value, "Machine")
}