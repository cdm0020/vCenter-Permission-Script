 

#------------Define Variables -------------------

$serverAddress = Read-Host -Prompt 'Input vCenter IP Address'
$domain = Read-Host -Prompt 'Input Domain  ex: Site1, Site2'
$siteID= Read-Host -Prompt 'Input Site ID. Ex, 24'

function TakeABreak {
    param (
        [parameter(mandatory=$true)][int]$Seconds
    )
    $Step = 100 / $seconds
    $i = 0
    while ($i -le 100) {
        Write-Progress -Activity "Take a break..." -PercentComplete $i -CurrentOperation "$i% complete" -Status "Please wait."
        Start-Sleep -Seconds 1
        $i = $i + $Step
    }
}


#------------ Connect to vCenter ---------------
 
#Ignore SSL Warnings & Connect to vCenter

Set-PowerCLIConfiguration -InvalidCertificateAction:Ignore
connect-viserver -server  $serverAddress


#--------------- Create Roles and Assign Privileges ---------------

.\roleScript.ps1 -Roles

Write-Host "";
Write-Host "";
Write-Host "";



TakeABreak -Seconds 3


Write-Host "";
Write-Host "";
Write-Host "";



#Read-Host -Prompt "Press any key to continue or CTRL+C to quit" 

#---------------- Assign AD Groups to Roles and Apply to vCenter Object ---------------

# Set AD Group ent vCenter SuperUsers to role Administrator and assign to vCenter object

New-VIPermission -Role Admin -Principal $domain\'ent vCenter SuperUsers' -Entity (Get-Folder "Datacenters" -Type Datacenter | Where { $_.ParentId -eq $null })

# Set AD Group ent Infrastructure Cloud Managers to role  Cloud Manager and assign to vCenter object

New-VIPermission -Role ' Cloud Manager' -Principal $domain\'ent Infrastructure Cloud Managers' -Entity (Get-Folder "Datacenters" -Type Datacenter | Where { $_.ParentId -eq $null })

# Set AD Group VMware Service Accounts to role Administrator and assign to vCenter object

New-VIPermission -Role Admin -Principal $domain\'VMware Service Accounts' -Entity (Get-Folder "Datacenters" -Type Datacenter | Where { $_.ParentId -eq $null })

# Set AD Group <siteID> vCenter Admins to role OA$domain Site Administrator and assign to vCenter object

New-VIPermission -Role ' Site Administrator' -Principal $domain\$siteID' vCenter Admins' -Entity (Get-Folder "Datacenters" -Type Datacenter | Where { $_.ParentId -eq $null })

# Set AD Group <siteID> vCenter Tier 2 Support to role OADGS Tier 2 Support and assign to vCenter object

New-VIPermission -Role ' Tier 2 Support' -Principal $domain\$siteID' vCenter Tier 2 Support' -Entity (Get-Folder "Datacenters" -Type Datacenter | Where { $_.ParentId -eq $null })

# Set AD Group <siteID> vCenter Tier 1 Support to role OADGS Tier 1 Support and assign to vCenter object

New-VIPermission -Role ' Tier 1 Support' -Principal $domain\$siteID' vCenter Tier 1 Support' -Entity (Get-Folder "Datacenters" -Type Datacenter | Where { $_.ParentId -eq $null })

#--------------- Assign AD Groups to Roles and Folders -----------------------------------

#------------ ESS Folders ----------------

# Assign <Site ID> ACAS vCenter Admins AD Group to ESS > ACAS Folder

New-VIPermission  -Role ' Application Owner' -Principal $domain\$siteID' ACAS vCenter Admins' -Entity (Get-Folder -Location 'ESS' -Name 'ACAS')

# Assign <Site ID> Arcsight vCenter Admins AD Group to ESS > ACAS Folder

New-VIPermission  -Role ' Application Owner' -Principal $domain\$siteID' Arcsight vCenter Admins' -Entity (Get-Folder -Location 'ESS' -Name 'Arcsight')

# Assign <Site ID> Docker vCenter Admins AD Group to ESS > ACAS Folder

New-VIPermission  -Role ' Application Owner' -Principal $domain\$siteID' Docker vCenter Admins' -Entity (Get-Folder -Location 'ESS' -Name 'Docker')

# Assign <Site ID> EXAMPLE vCenter Admins AD Group to ESS > ACAS Folder

New-VIPermission  -Role ' Application Owner' -Principal $domain\$siteID' EXAMPLE vCenter Admins' -Entity (Get-Folder -Location 'ESS' -Name 'EXAMPLE')

# Assign <Site ID> EXAMPLE vCenter Admins AD Group to ESS > ACAS Folder

New-VIPermission  -Role ' Application Owner' -Principal $domain\$siteID' EXAMPLE vCenter Admins' -Entity (Get-Folder -Location 'ESS' -Name 'EXAMPLE')

# Assign <Site ID> EXAMPLE vCenter Admins AD Group to ESS > ACAS Folder

New-VIPermission  -Role ' Application Owner' -Principal $domain\$siteID' EXAMPLE vCenter Admins' -Entity (Get-Folder -Location 'ESS' -Name 'EXAMPLE')

# Assign <Site ID> EXAMPLE vCenter Admins AD Group to ESS > ACAS Folder

New-VIPermission  -Role ' Application Owner' -Principal $domain\$siteID' EXAMPLE vCenter Admins' -Entity (Get-Folder -Location 'ESS' -Name 'EXAMPLE')

# Assign <Site ID> EXAMPLE vCenter Admins AD Group to ESS > ACAS Folder

New-VIPermission  -Role ' Application Owner' -Principal $domain\$siteID' EXAMPLE vCenter Admins' -Entity (Get-Folder -Location 'ESS' -Name 'EXAMPLE')



#------------ Infrastructure  ----------------

New-VIPermission  -Role ' Application Owner' -Principal $domain\'ent Infrastructure Backup Admins' -Entity (Get-Folder -Location 'Infrastructure-NoBackup' -Name 'Backup')

New-VIPermission  -Role ' Application Owner' -Principal $domain\$siteID' AD vCenter Admins' -Entity (Get-Folder -Location 'Infrastructure-NoBackup' -Name 'iDAM')

New-VIPermission  -Role ' Application Owner' -Principal $domain\'ent Network Admins' -Entity (Get-Folder -Location 'Infrastructure-NoBackup' -Name 'Network')

New-VIPermission  -Role ' Application Owner' -Principal $domain\'ent Infrastructure Storage Admins' -Entity (Get-Folder -Location 'Infrastructure-NoBackup' -Name 'Storage')

#------------ Production ----------------

# Assign <Site ID> PRODUCT vCenter Admins AD Group to ESS > AIMES Folder

New-VIPermission  -Role ' Application Owner' -Principal $domain\$siteID' PRODUCT vCenter Admins' -Entity (Get-Folder -Location 'Production' -Name 'PRODUCT')


