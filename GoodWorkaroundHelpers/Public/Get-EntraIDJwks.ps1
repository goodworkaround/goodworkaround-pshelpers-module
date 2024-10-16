function Get-EntraIDJwks {
    [CmdletBinding()]

    Param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidatePattern("^[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}$")]
        [string]$ClientId,

        [Parameter(Mandatory=$false)]
        [string]$Tenant = "common"
    )

    Process {
        $url = "https://login.microsoftonline.com/{0}/discovery/keys" -f $Tenant

        if($ClientId) {
            $url += "?appid=$ClientId"
        }
        Write-Verbose "Jwks url: $url"
        Invoke-RestMethod -Uri $url | Select-Object -expand keys
    }
}