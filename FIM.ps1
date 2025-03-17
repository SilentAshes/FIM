Write-Host " "
Write-Host "What would u like to do ?"
Write-Host "A) collect new basline ?"
Write-Host "B) begin monitoring files with saved baseline ?"

$response = Read-Host -Prompt "please enter 'A' or 'B'"

function calculate-file-hash($filepath) { 
    $filehash = Get-FileHash -Path $filepath -Algorithm SHA512
    return $filehash
}

function Erase-Baseline-IF-Exists() {
   $BaselineExists = Test-Path -Path .\baseline.txt
   if ($BaselineExists) {
    #delete 
    Remove-Item -Path .\baseline.txt
   }
}

if ($response -eq "A".ToUpper()) {
    #delete baseline if exists
    Erase-Baseline-IF-Exists
    #calculate hash from the target files and store in baseline.txt
    #collect all files in target folder and calculate hashes for the files , and write a baseline.txt
    $files = Get-ChildItem -Path C:\Users\PC\Desktop\FIM\files -File -Recurse

    #calculate hases for each file 
    foreach ($f in $files) {
        $hash = calculate-file-hash $f.FullName 
        "$($hash.Path)|$($hash.hash)" | Out-File -FilePath .\baseline.txt -append 
    }
}

elseif ($response -eq "B".ToUpper()) {
    $fileHashDicti = @{}
    # load file|hash from baseline.txt and store them in a dictionary
    $pathesAndHashes = Get-Content -Path .\baseline.txt
    foreach ($f in $pathesAndHashes) {
        $fileHashDicti.add($f.Split("|")[0],$f.Split("|")[1])
    }
    $fileHashDicti
    # begin (continuosly) monitoring files with saved baseline
    while ($true) {
        Start-Sleep -Seconds 1
        $files = Get-ChildItem -Path C:\Users\PC\Desktop\FIM\files -File -Recurse

        #calculate hases for each file 
        foreach ($f in $files) {
            $hash = calculate-file-hash $f.FullName 
            #"$($hash.Path)|$($hash.hash)" | Out-File -FilePath .\baseline.txt -append

            #notify if new file has been created
            if ($fileHashDicti[$hash.path] -eq $null) {
                # a new file has been created! notify the user
                Write-Host "$($hash.Path) has been created" -ForegroundColor Cyan
            } 
            #notify if a file has been changed 
            else {
                if ($fileHashDicti[$hash.path] -eq $hash.Hash) {
                    # the file has not changed!
                    
                } 
                else {
                    # the file has been compromised! notify the user 
                    Write-Host "$($hash.Path) has been compromised!!!!" -ForegroundColor Red
                }
            }
        }
        foreach ($key in $fileHashDicti.Keys){
            $fileStillExists = Test-Path -Path $key
            if (-Not $fileStillExists) {
                # one of the basline files must have been deleted!!! notify the user
                Write-Host "$($key)has been deleted!!!!" -ForegroundColor DarkBlue
            }
        }
    }
}

