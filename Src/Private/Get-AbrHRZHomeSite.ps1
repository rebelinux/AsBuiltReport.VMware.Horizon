function Get-AbrHRZHomeSite {
    <#
    .SYNOPSIS
        PowerShell script which documents the configuration of VMware Horizon in Word/HTML/XML/Text formats
    .DESCRIPTION
        Documents the configuration of VMware Horizon in Word/HTML/XML/Text formats using PScribo.
    .NOTES
        Version:        1.1.5
        Author:         Chris Hildebrandt, Karl Newick
        Twitter:        @childebrandt42, @karlnewick
        Editor:         Jonathan Colon, @jcolonfzenpr
        Twitter:        @asbuiltreport
        Github:         AsBuiltReport
        Credits:        Iain Brighton (@iainbrighton) - PScribo module


    .LINK
        https://github.com/AsBuiltReport/AsBuiltReport.VMware.Horizon
    #>

    [CmdletBinding()]
    param (
    )

    begin {
        Write-PScriboMessage "Home Site Assignments InfoLevel set at $($InfoLevel.UsersAndGroups.HomeSiteAssignments)."
        Write-PScriboMessage "Collecting Home Site General Information."
    }

    process {
        if ($InfoLevel.UsersAndGroups.HomeSiteAssignments -ge 1) {
            try {
                if ($Homesites) {
                    Section -Style Heading3 'Home Site' {
                        Paragraph "The following section provide a summary of user and group home site configuration."
                        BlankLine
                        $OutObj = @()
                        foreach ($HomeSite in $HomeSites) {
                            try {
                                # Clear Var
                                $HomeSiteUserIDName = ''
                                $HomeSiteUserIDDomain = ''
                                $HomeSiteUserIDEmail = ''
                                $HomeSiteUserIDGroup = ''
                                $HomeSiteSiteIDName = ''
                                $HomeSiteGlobalEntitlementIDName = ''
                                $HomeSiteGlobalApplicationEntitlementIDName = ''

                                # HomeSite User or Group ID
                                if ($HomeSite.Base.UserOrGroup) {
                                    $HomeSiteUserID = $hzServices.ADUserOrGroup.ADUserOrGroup_Get($homesite.Base.UserOrGroup)
                                    $HomeSiteUserIDName = $HomeSiteUserID.Base.Name
                                    $HomeSiteUserIDDomain = $HomeSiteUserID.Base.Domain
                                    $HomeSiteUserIDEmail = $HomeSiteUserID.Base.Email
                                    $HomeSiteUserIDGroup = $HomeSiteUserID.Base.Group
                                }

                                # Home Site Site ID
                                if ($HomeSite.Base.Site) {
                                    $HomeSiteSiteID = $hzServices.Site.Site_Get($HomeSite.Base.Site)
                                    $HomeSiteSiteIDName = $HomeSiteSiteID.base.DisplayName
                                }

                                # Home Site Global Entilement ID
                                if ($HomeSite.Base.GlobalEntitlement) {
                                    $HomeSiteGlobalEntitlementID = $hzServices.GlobalEntitlement.GlobalEntitlement_Get($homesite.Base.GlobalEntitlement)
                                    $HomeSiteGlobalEntitlementIDName = $HomeSiteGlobalEntitlementID.base.DisplayName
                                }

                                # Home Site Global Application Entilement ID
                                if ($HomeSite.Base.GlobalApplicationEntitlement) {
                                    $HomeSiteGlobalApplicationEntitlementID = $hzServices.GlobalApplicationEntitlement.GlobalApplicationEntitlement_Get($homesite.Base.GlobalApplicationEntitlement)
                                    $HomeSiteGlobalApplicationEntitlementIDName = $HomeSiteGlobalApplicationEntitlementID.base.DisplayName
                                }
                                $inObj = [ordered] @{
                                    'User or Group Name' = $HomeSiteUserIDName
                                    'Domain' = $HomeSiteUserIDDomain
                                    'Group' = $HomeSiteUserIDGroup
                                    'Email' = $HomeSiteUserIDEmail
                                    'Home Site' = $HomeSiteSiteIDName
                                    'Global Entitlement' = $HomeSiteGlobalEntitlementIDName
                                    'Global Application Entitlement' = $HomeSiteGlobalApplicationEntitlementIDName
                                }
                                $OutObj += [pscustomobject](ConvertTo-HashToYN $inObj)
                            } catch {
                                Write-PScriboMessage -IsWarning $_.Exception.Message
                            }
                        }

                        $TableParams = @{
                            Name = "Home Site General - $($HVEnvironment.toUpper())"
                            List = $false
                            ColumnWidths = 17, 10, 10, 18, 15, 15, 15
                        }

                        if ($Report.ShowTableCaptions) {
                            $TableParams['Caption'] = "- $($TableParams.Name)"
                        }
                        $OutObj | Sort-Object -Property 'User or Group Name' | Table @TableParams
                    }
                }
            } catch {
                Write-PScriboMessage -IsWarning $_.Exception.Message
            }
        }
    }
    end {}
}