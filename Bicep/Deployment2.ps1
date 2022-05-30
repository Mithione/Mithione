
$script:steps = ([System.Management.Automation.PsParser]::Tokenize((gc "$PSScriptRoot\$($MyInvocation.MyCommand.Name)"), [ref]$null) | where { $_.Type -eq 'Command' -and $_.Content -eq 'Write-DeployProgress' }).Count
$script:Title = "Azure deployment"
$stepCounter = 0

function Write-DeployProgress {
	param (
	    [int]$StepNumber,
        [string] $Title,
	    [string]$Message,
        [int] $ParentId,
        [int] $Id
	)

	Write-Progress -Activity $Title -Status $Message -ParentId $ParentId -Id $Id # -PercentComplete (($StepNumber / $steps) * 100) 
}

Write-Progress -Id 0 -Activity $script:Title 

Write-DeployProgress -Title "Step 1" -Message 'Doing something' -Id 1 -ParentId 0 # -StepNumber ($stepCounter++) 
Start-Sleep -Seconds 5

Write-DeployProgress -Title "Step 2" -Message 'Doing something2' -Id 2 -ParentId 0 #-StepNumber ($stepCounter++) 

Start-Sleep -Seconds 5


Write-DeployProgress -Title "Step 3" -Message 'Doing something3' -Id 3 -ParentId 0 #-StepNumber ($stepCounter++) 

Start-Sleep -Seconds 5
pause