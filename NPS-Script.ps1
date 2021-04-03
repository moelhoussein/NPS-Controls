<#

.SYNOPSIS
  NPS ADVANCED OPTIONS TOOL.
  
.DESCRIPTION
    THIS IS A POWERSHELL SCRIPT CREATED TO ASSIST IN MANIPUTLATING ADVANCED NPS EXT SETTINGS, AVAILABLE ONLY IN THE REGEDIT

.AUTHOR:
    MOHAMED EL HOUSSEIN

.USE:
    .\NPS-AOT.PS1

    Enter (1) to Skip MFA for users that are not registered

    Enter (2) to Skip MFA for a specific IP address

    Enter (3) to Use a different login attribute
    
    Enter (4) to force use of GC for LDAP searches

    Enter (5) to specify multiple forests for the LDAP searches

    Enter (Q) to Quit
    


#>


<#test if the reg key exists.
	if yes > request user input
	> write euser input in the valu
	> restart NPS service (or ask user if they would like to)
#>

Function RequireUserMatch{
    ''
    New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\AzureMfa -Name "REQUIRE_USER_MATCH" -Value "FALSE"
    Write-Host "To apply the changes please restart the NPS service." -BackgroundColor Black

}

Function ForceCG{
    ''
    Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\AzureMfa -Name "LDAP_FORCE_GLOBAL_CATALOG" -Value "TRUE"
    Write-Host "To apply the changes please restart the NPS service." -BackgroundColor Black
}


Function ALT_LOGIN{
    ''
    $Attribute =''
    $Attribute = Read-Host -Prompt "Enter the LDAP attribute to proceed" 
    Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\AzureMfa -Name "LDAP_ALTERNATE_LOGINID_ATTRIBUTE" -Value $Attribute
    Write-Host "To apply the changes please restart the NPS service." -BackgroundColor Black
}    


Function Skip_IP{
    ''
    $IP =''
    $IP = Read-Host -Prompt "Enter IP address, comma seperated if multiple. (10.10.10.10,11.11.11.11,12.12.12.12)" 
    New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\AzureMfa -Name "IP_WHITELIST" -Value $IP
    Write-Host "To apply the changes please restart the NPS service." -BackgroundColor Black
} 




Function Forests{
    ''
    $Forest =''
    $Forest = Read-Host -Prompt "Enter comma seperated list of forests. (contoso.com, google.com)" 
    Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\AzureMfa -Name "LDAP_LOOKUP_FORESTS" -Value $Forest
    Write-Host "To apply the changes please restart the NPS service."
} 

Write-Host "Checking If NPS Extension is installed on this Server."
$Test = Test-Path 'HKLM:\SOFTWARE\Microsoft\AzureMfa' -ErrorAction SilentlyContinue
if($Test.value -eq $false){
    Start-Sleep -s 7
    exit Write-Host "NPS Extension is not installed on this host existing. . ." -ForegroundColor Red -BackgroundColor Black
} else {
    continue
}



'==================================================='
Write-Host   '          NPS Advanced Options Tool         ' -ForegroundColor Green 
'==================================================='
''
Write-Host "Please make a selection" -ForegroundColor Yellow
''
Write-Host "Enter (1) to Skip MFA for users that are not registered" -ForegroundColor Green
''
Write-Host "Enter (2) to Skip MFA for a specific IP address" -ForegroundColor Green
''
Write-Host "Enter (3) to Use a different login attribute" -ForegroundColor Green
''
Write-Host "Enter (4) to force use of GC for LDAP searches" -ForegroundColor Green
''
Write-Host "Enter (5) to specify multiple forests for the LDAP searches" -ForegroundColor Green
''
''
Write-Host "Enter (Q) to Quit" -ForegroundColor Green
''

$Num =''
$Num = Read-Host -Prompt "Enter a number and press enter to proceed." 

While(($Num -ne '1') -AND ($Num -ne '2') -AND ($Num -ne '3') -AND ($Num -ne '4') -AND ($Num -ne '5') -AND ($Num -ne 'Q')){

$Num = Read-Host -Prompt "Invalid input. Please make a correct selection from the above options, and press Enter" 

}

if($Num -eq '1'){
    ''
    Write-Host "Skip MFA for users that are not registered" -BackgroundColor Black
    ''
    RequireUserMatch
}elseif($Num -eq '2'){
    ''
    Write-Host "skip MFA for a specific IP address" -BackgroundColor Black
    ''
    Skip_IP
}elseif($Num -eq '3'){
    ''
    Write-Host "Use a different login attribute" -BackgroundColor Black
    ''
    ALT_LOGIN
}elseif($Num -eq '4'){
    ''
    Write-Host "force use of GC for LDAP searches" -BackgroundColor Black
    ''
    ForceCG
}elseif($Num -eq '5'){
    ''
    Write-Host "specify multiple forests for the LDAP searches" -BackgroundColor Black
    ''
    Forests
}