$manifest = @{
    Path              = '.\AsBuiltReport.VMware.Horizon.psd1'
    RootModule        = 'AsBuiltReport.VMware.Horizon.psm1' 
    Author            = 'Chris Hildebrandt And Karl Newick'
	Description		  = 'A PowerShell module to generate an as built report on the configuration of HPE Nimble Storage arrays.'
    FunctionsToExport = 'Invoke-AsBuiltReport.HPE.NimbleStorage'
    RequiredModules = @{
        'AsBuiltReport.Core'
    }
}
New-ModuleManifest @manifest