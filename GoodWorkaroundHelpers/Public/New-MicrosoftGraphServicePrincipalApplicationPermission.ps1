<#
.SYNOPSIS
Assigns a service principal certain application permissions for Microsoft Graph

.PARAMETER ObjectId
The objectid of the service principal to assign permissions to

.EXAMPLE
New-MicrosoftGraphServicePrincipalApplicationPermission -ObjectId "00000000-0000-0000-0000-000000000000" -GraphPermission "User.Read.All", "User.ReadWrite.All
#>
function New-MicrosoftGraphServicePrincipalApplicationPermission {
    [CmdletBinding()]

    Param ( 
        [Parameter(Mandatory = $false)]
        [String[]] $GraphPermission,

        
        [Parameter(Mandatory = $false)]
        [String] $ObjectId
        
    )

    Begin {
        Connect-mggraph -scope Application.Read.All, AppRoleAssignment.ReadWrite.All | Out-Null
    }

    Process {
        # Get Microsoft Graph service principal
        $Graph = Invoke-MgGraphRequest -Uri 'https://graph.microsoft.com/v1.0/servicePrincipals(appId=''00000003-0000-0000-c000-000000000000'')'
        Write-Verbose "Found Microsoft Graph service principal $($Graph.displayName) with objectid $($Graph.id)"
        
        # Build map of app roles
        $GraphAppRoles = Invoke-MgGraphRequest -Uri 'https://graph.microsoft.com/v1.0/servicePrincipals(appId=''00000003-0000-0000-c000-000000000000'')/appRoles?$top=999' | 
        Select-Object -ExpandProperty value | 
        Group-Object -AsHashTable -Property value

        $GraphPermission | ForEach-Object {
            if($GraphAppRoles.ContainsKey($_)) {
                $id = $GraphAppRoles[$_].id
                $body = @{
                    principalId = $ObjectId
                    resourceId = $Graph.id
                    appRoleId = $id
                }
                Write-Verbose "Assigning Microsoft Graph app role $($_) with id $id to service principal $ObjectId"
                try {
                    Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/servicePrincipals/$($Graph.id)/appRoleAssignments" -Method POST -Body $body
                } catch {
                    if($_.ErrorDetails.Message -like "*already exists*") {
                        Write-Verbose "Graph app role $id already assigned to service principal $ObjectId"
                    } else {
                        throw $_
                    }
                }
            } else {
                Write-Warning "Graph app role $($_) not found"
            }
        }
    }
}