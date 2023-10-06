<#
.SYNOPSIS
Pipeline version of the -split operator

.EXAMPLE
PS> "a,b,c" | Split-String -Delimiter ","
#>
function Split-String {
    [CmdletBinding()]

    Param ( 
        [Parameter(Mandatory = $false)]
        [String] $Delimiter = "",

        [Parameter(Mandatory = $false)]
        [Int] $Limit = 0,

        [Parameter(ValueFromPipeline = $true)]
        [String] $InputString
        
    )

    Process {
        $InputString -split $Delimiter, $Limit
    }
}