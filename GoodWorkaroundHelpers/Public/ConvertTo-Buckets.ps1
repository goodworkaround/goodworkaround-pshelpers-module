<#
.SYNOPSIS
Cmdlet to take a list of objects as input, splitting them into buckets of a given size or a given number of buckets of equal size

.EXAMPLE
PS> 1..10 | ConvertTo-Buckets -NumberOfBuckets 2

.EXAMPLE
PS> 1..10 | ConvertTo-Buckets -BucketSize 2
#>
function ConvertTo-Buckets {
    [CmdletBinding()]

    Param
    (
        # Total number of buckets, bucket size will vary
        [Parameter(Mandatory = $true,
            Position = 0,
            ParameterSetName = "NumberOfBuckets")]
        [ValidateRange(2, [Int]::MaxValue)]
        [int] $NumberOfBuckets,
                    
        # Size of each bucket, last bucket will have different size of the rest
        [Parameter(Mandatory = $true,
            Position = 1,
            ParameterSetName = "BucketSize")]
        [ValidateRange(2, [Int]::MaxValue)]
        [int]  $BucketSize,
  
        # Input object to put into bucket
        [Parameter(Mandatory = $true,
            Position = 2, ValueFromPipeline = $true)]
        $InputObject
    )
                    
    Begin {
        $Buckets = New-Object System.Collections.ArrayList<Object>
        if ($NumberOfBuckets -gt 0) {
            # Add numberofbuckets number of array lists to create a multi dimensional array list
            1..$NumberOfBuckets | ForEach-Object {
                $Buckets.Add((New-Object System.Collections.ArrayList<Object>)) | Out-Null
            }   
        }
        else {
            # Add a single bucket as our first bucket
            $Buckets.Add((New-Object System.Collections.ArrayList<Object>)) | Out-Null
        }
        $index = 0
    }
    Process {
        if ($NumberOfBuckets -gt 0) {
            $index = ($index + 1) % $NumberOfBuckets
            $Buckets[$index].Add($InputObject) | Out-Null
        }
        else {
            $Buckets[$index].Add($InputObject) | Out-Null
            if ($Buckets[$index].Count -ge $BucketSize) {
                $Buckets.Add((New-Object System.Collections.ArrayList<Object>)) | Out-Null
                $index += 1
            }
        }
          
    }
    End {
        Write-Output -NoEnumerate -InputObject $Buckets
    }
}