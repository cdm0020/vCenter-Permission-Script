

# Build Params

param
(
        $directory = $(read-host "Enter local input directory"),
        $datacenter = $(read-host "Enter datacenter name"),
        [switch]$roles,
        [switch]$permissions
        
)


#Build Roles
if ($roles)
{
        $allRoles = import-clixml $directory\Roles\Datacenter-roles.xml
        $i = 0
        foreach ($thisRole in $allRoles)
        {
                write-progress -Activity "Creating Roles" -percentComplete ($i / $allRoles.count * 100)
                if (!(get-virole $thisRole.name -erroraction silentlycontinue))
                {
                        new-virole -name $thisRole.name -privilege (get-viprivilege -id $thisRole.PrivilegeList) -erroraction silentlycontinue
                }
                $i++
        }
}

#build Permissions
if ($permissions)
{
        $allPermissions = import-clixml $directory\Roles\Datacenter-permissions.xml
        $i = 0
        foreach ($thisPermission in $allPermissions)
        {
                write-progress -Activity "Creating Permissions" -percentComplete ($i / $allPermissions.count * 100)
                #$target = ""
                
                else
                {
                        write-error "Unable to find permission object $($thisPermission.entity)"
                }
                $i++
        }
}
