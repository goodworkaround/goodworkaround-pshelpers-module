Describe 'ConvertTo-Buckets' {
    It 'Splits 10 numbers into 2 buckets when asked to' {
        $buckets = 1..10 | ConvertTo-Buckets -NumberOfBuckets 2
        $buckets.Count | Should -Be 2
    }

    It 'Splits 10 numbers into buckets of 5 when asked to' {
        $buckets = 1..10 | ConvertTo-Buckets -BucketSize 5
        $buckets.Count | Should -Be 2
    }
}