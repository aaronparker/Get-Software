Function Get-LehrerOffice {
    <#
        .SYNOPSIS
            Get the current version and download URL for LehrerOffice.
    #>
    [OutputType([System.Management.Automation.PSObject])]
    [CmdletBinding(SupportsShouldProcess = $False)]
    param (
        [Parameter(Mandatory = $False, Position = 0)]
        [ValidateNotNull()]
        [System.Management.Automation.PSObject]
        $res = (Get-FunctionResource -AppName ("$($MyInvocation.MyCommand)".Split('-'))[1])
    )

    # Get the latest LehrerOffice version
    $webrequest = @{
        Uri = $res.Get.Update.Uri
    }
    $Content = Invoke-EvergreenWebRequest @webrequest

    $versions = $Content | Select-String -Pattern $res.Get.Update.MatchVersion
    $newestVersion = $versions.Matches.Item(0).Groups.Item(1).Value

    # Construct the output; Return the custom object to the pipeline
    If ($Null -ne $Content) {
        $PSObject = [PSCustomObject] @{
            Version = $newestVersion
            Type    = 'Exe'
            URI     = $res.Get.Download.Uri
        }
        Write-Output -InputObject $PSObject
    }
}
