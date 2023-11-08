<#
.SYNOPSIS
Cmdlet to take a list of objects as input and creating a Excel pastable table from it

.EXAMPLE
dir c:\windows | Select BaseName, Extension | Copy-AsExcelTable
#>
function Copy-AsExcelTable {
    [CmdletBinding()]

    Param
    (
        [Parameter(Mandatory = $false, Position = 1)]
        [String[]] $Properties = $null,

        [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $true)]
        $InputObject
    )
                    
    Begin {
        $Strings = New-Object System.Collections.ArrayList
        $First = $true
    }
    Process {
        if (!$Properties) {
            $Properties = $InputObject | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
        }

        if ($First) {
            $First = $false
            $Strings.Add(
                $Properties -join "`t"
            ) | Out-Null
        }
        
        $Strings.Add(
            (
                $Properties | 
                ForEach-Object {
                    $InputObject.$_
                }
            ) -join "`t"
        ) | Out-Null
    }
    End {
        $Strings -join "`r`n" | Set-Clipboard
    }
}