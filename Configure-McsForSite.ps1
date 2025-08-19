Configure-McsForSite.ps1
param (
    [Parameter(Mandatory=$true)]
    [string]$siteUrl,
    [Parameter(Mandatory=$true)]
    [string]$botUrl,
    [Parameter(Mandatory=$true)]
    [string]$botName,
    [Parameter(Mandatory=$true)]
    [string]$customScope,
    [Parameter(Mandatory=$true)]
    [string]$clientId,
    [Parameter(Mandatory=$true)]
    [string]$authority,
    [Parameter(Mandatory=$true)]
    [string]$buttonLabel,
    [Parameter(Mandatory=$true)]
    [switch]$greet
)
#Self Service Agent
$siteUrl = "https://s63fb.sharepoint.com/sites/SelfServiceAgent/"
$botUrl = "https://6a0383e2ebc3ee40bdc9d05198285a.12.environment.api.powerplatform.com/powervirtualagents/botsbyschema/crfb3_selfServiceAgent/directline/token?api-version=2022-03-01-preview"
$buttonLabel = "Chat Now"
$customScope = "api://27eb69cb-53e6-40db-8533-dfa804dca4ac/Sites.Read"
$clientId = "4ffd1a7a-9a30-48a9-bc3d-51060e46591b"
$authority = "https://login.microsoftonline.com/s63fb.onmicrosoft.com"
$botName = "Self Service Agent"
$greet = $True 

#Service Desk Agent ESS
$siteUrl = "https://azureextraspace.sharepoint.com/sites/SelfServiceAgent/"
$botUrl = "https://6a01bb625327e44cb82093cb461179.04.environment.api.powerplatform.com/powervirtualagents/botsbyschema/sdagent_ServiceDeskAgent/directline/token?api-version=2022-03-01-preview"
$buttonLabel = "Chat Now"
$customScope = "api://f2addeaa-bbdf-449a-8da6-61fbe0b480a5/SSA.Read"
$clientId = "a987856e-0dcd-44af-9da4-2919b028e4fe"
$authority = "https://login.microsoftonline.com/azureextraspace.onmicrosoft.com"
$botName = "Service Desk Agent Bot"
$greet = $True 
#Update-Module PnP.PowerShell
#didnt work 
Connect-PnPOnline -Url $SiteURL -ClientId "748cedca-cf64-4488-98ae-c8c1a57427ff" -ClientSecret "Secrete Goes here"
#didnt work Connect-PnPOnline -Url $siteUrl -Interactive
<#
# Step 1: Create a self-signed certificate valid for 5 years, exportable private key
$cert = New-SelfSignedCertificate -CertStoreLocation Cert:\CurrentUser\My -Subject "CN=PnPAppCert" -KeyExportPolicy Exportable -KeySpec Signature -NotAfter (Get-Date).AddYears(5)
# Step 2: Export the private key (.pfx) to your Desktop with password protection
$pfxPassword = ConvertTo-SecureString -String "YourStrongPassword123!" -Force -AsPlainText
$pfxPath = "$env:C:\Users\nilangi.p.kapade\Downloads\PnPAppCert.pfx"
Export-PfxCertificate -Cert $cert -FilePath $pfxPath -Password $pfxPassword
# Step 3: Export the public certificate (.cer) to your Desktop for upload to Azure AD
$cerPath = "$env:C:\Users\nilangi.p.kapade\Downloads\PnPAppCert.cer"
Export-Certificate -Cert $cert -FilePath $cerPath
Write-Host "Certificate and key exported to your Desktop:"
Write-Host "PFX Path: $pfxPath"
Write-Host "CER Path: $cerPath"
Write-Host "Remember your PFX password: YourStrongPassword123!"
#>
Connect-PnPOnline -Url "https://azureextraspace.sharepoint.com/sites/SelfServiceAgent/" -ClientId "748cedca-cf64-4488-98ae-c8c1a57427ff" -Tenant "b0ee1bf3-60fa-4289-b9b2-115658f04138" -CertificatePath "$env:C:\Users\nilangi.p.kapade\Downloads\PnPAppCert.pfx" -CertificatePassword (ConvertTo-SecureString -String "YourStrongPassword123!" -AsPlainText -Force)
Get-PnPWeb
Get-PnPWeb
$action = (Get-PnPCustomAction | Where-Object { $_.Title -eq "PvaSso" })[0]
$action.ClientSideComponentProperties = @{
    "botURL" = $botUrl
    "customScope" = $customScope
    "clientID" = $clientId
    "authority" = $authority
    "greet" = $greet.isPresent
    "buttonLabel" = $buttonLabel
    "botName" = $botName
} | ConvertTo-Json -Compress
$action.Update()
Invoke-PnPQuery
