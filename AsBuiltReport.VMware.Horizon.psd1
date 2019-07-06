$manifest = @{
    Path              = '.\AsBuiltReport.VMware.Horizon.psd1'
    RootModule        = 'AsBuiltReport.VMware.Horizon.psm1' 
    Author            = 'Chris Hildebrandt'
	Description		  = 'A PowerShell module to generate an as built report on the configuration of VMware Horizon.'
    FunctionsToExport = 'Invoke-AsBuiltReport.VMware.Horizon'
    RequiredModules = @{
        'AsBuiltReport.Core'
    }
}
New-ModuleManifest @manifest