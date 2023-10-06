Describe 'Split-String' {
    It 'Given a single pipeline input, it splits and returns 8 objects' {
        $allPlanets = "Mercury,Venus,Earth,Mars,Jupiter,Saturn,Uranus,Neptune" | Split-String -Delimiter ","
        $allPlanets.Count | Should -Be 8
    }

    It 'Given 10 guids as input, it splits and returns 50 objects' {
        $splitGuids = (1..10|% {New-Guid}) | Split-String -Delimiter "-"
        $splitGuids.Count | Should -Be 50
    }

    It 'Given 10 guids as input, and a limit of 2, it splits and returns 20 objects' {
        $splitGuids = (1..10|% {New-Guid}) | Split-String -Delimiter "-" -Limit 2
        $splitGuids.Count | Should -Be 20
    }
}