##############################################################
# Script to loop through json files and do operations on them
##############################################################

$componentTotalCost = 0
$versionCount = 0
$databasefileCount = 0

Get-ChildItem -Path "${pwd}" -Filter *.json | 
ForEach-Object {
    # Convert each json file into a HashTable to work on
    $jsonHashtable = Get-Content -Path $_ | ConvertFrom-JSON -AsHashtable

    # Write the total cost of all components to the console
    $componentTotalCost += $jsonHashtable["count"] * $jsonHashtable["cost"]

    # Replace all occurrences with your name, and then write it to a new file
    if ($jsonHashtable.ContainsValue('${REPLACE}')) {
  
        $jsonHashtable.keys.Clone() | ForEach-Object {
            if ($jsonHashtable[$_] -eq '${REPLACE}' ) {
                $jsonHashtable[$_] = "Alex"
            }
        }
        $newFileName = $($_.NameString -replace '.json', '')
        $jsonHashtable | ConvertTo-Json | Out-File "newfile/$newFileName-new.json"
    }

    # How many files have a property with the name version
    foreach($key in $jsonHashtable.Keys)
    {
        if($key -eq "version")
        {
            $versionCount += 1
        }
    }
    
    # How many files have a property called component with the value database
    if ($jsonHashtable.ContainsKey("component") -and $jsonHashtable["component"] -eq "database") {
        $databasefileCount += 1
    }
}
Write-Host  -Foreground Blue "Total cost of component: $componentTotalCost `n"
Write-Host -Foreground Green "Number of files with version property:  $versionCount `n"
Write-Host  -Foreground Yellow "Files with property component and value database: $databasefileCount `n"