function Get-AbrHRZEventConf {
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
        Write-PScriboMessage "EventDatabase InfoLevel set at $($InfoLevel.Settings.EventConfiguration.EventDatabase)."
        Write-PScriboMessage "Collecting Event Configuration information."
    }

    process {
        try {
            if ($EventDataBases -or $Syslog) {
                if ($InfoLevel.Settings.EventConfiguration.PSObject.Properties.Value -ne 0) {
                    Section -Style Heading2 "Event Configuration" {
                        Paragraph "The following section details on the events configuration information for $($HVEnvironment.toUpper())."
                        BlankLine
                        if ($InfoLevel.Settings.EventConfiguration.EventDatabase -ge 1) {
                            try {
                                Section -Style Heading3 "Event Database" {
                                    $OutObj = @()
                                    foreach ($EventDataBase in $EventDataBases) {
                                        Write-PScriboMessage "Discovered Event Database Information."
                                        $inObj = [ordered] @{
                                            'Server' = $EventDataBase.database.Server
                                            'Type' = $EventDataBase.database.Type
                                            'Port' = $EventDataBase.database.Port
                                            'Name' = $EventDataBase.database.Name
                                            'User Name' = $EventDataBase.database.UserName
                                            'Table Prefix' = $EventDataBase.database.TablePrefix
                                            'Show Events for' = $EventDataBase.Settings.ShowEventsForTime
                                            'Classify Events as New for' = "$($EventDataBase.Settings.ClassifyEventsAsNewForDays) Days"
                                            'Timing Profiler Events' = "$($EventDataBase.Settings.TimingProfilerDataLongevity) Days"
                                            'Enabled' = $EventDataBases.EventDatabaseSet
                                        }

                                        $OutObj += [pscustomobject](ConvertTo-HashToYN $inObj)
                                    }

                                    if ($HealthCheck.EventConfiguration.EventDatabase) {
                                        $OutObj | Where-Object { $_.'Enabled' -eq 'No' } | Set-Style -Style Warning -Property 'Enabled'
                                    }

                                    $TableParams = @{
                                        Name = "Event Database - $($HVEnvironment.split(".").toUpper()[0])"
                                        List = $true
                                        ColumnWidths = 50, 50
                                    }

                                    if ($Report.ShowTableCaptions) {
                                        $TableParams['Caption'] = "- $($TableParams.Name)"
                                    }
                                    $OutObj |  Table @TableParams
                                }
                            } catch {
                                Write-PScriboMessage -IsWarning $_.Exception.Message
                            }
                        }
                        if ($InfoLevel.Settings.EventConfiguration.Syslog -ge 1 -and $Syslog.UdpData.Enabled) {
                            try {
                                Section -Style Heading3 "Syslog Configuration" {
                                    $OutObj = @()
                                    foreach ($Logging in $Syslog.UdpData.NetworkAddresses) {
                                        Write-PScriboMessage "Discovered Syslog Information."
                                        $inObj = [ordered] @{
                                            'Server' = $Logging.split(':')[0]
                                            'Port' = $Logging.split(':')[1]
                                        }

                                        $OutObj += [pscustomobject](ConvertTo-HashToYN $inObj)
                                    }

                                    $TableParams = @{
                                        Name = "Syslog Configuration - $($HVEnvironment.split(".").toUpper()[0])"
                                        List = $false
                                        ColumnWidths = 50, 50
                                    }

                                    if ($Report.ShowTableCaptions) {
                                        $TableParams['Caption'] = "- $($TableParams.Name)"
                                    }
                                    $OutObj | Sort-Object -Property 'Server' | Table @TableParams
                                }
                            } catch {
                                Write-PScriboMessage -IsWarning $_.Exception.Message
                            }
                        }
                        if ($InfoLevel.Settings.EventConfiguration.EventstoFileSystem -ge 1 -and ($Syslog.FileData.Enabled -or $Syslog.FileData.EnabledOnError)) {
                            try {
                                Section -Style Heading3 "Events to File System" {
                                    $OutObj = @()
                                    foreach ($Logging in $Syslog) {
                                        Write-PScriboMessage "Discovered Events to File System Information."
                                        $inObj = [ordered] @{
                                            'Enabled' = $Logging.FileData.Enabled
                                            'Enabled on Error' = $Logging.FileData.EnabledOnError
                                            'Path' = $Logging.FileData.UncPath
                                            'User name' = $Logging.FileData.UncUserName
                                            'Domain' = $Logging.FileData.UncDomain
                                        }

                                        $OutObj += [pscustomobject](ConvertTo-HashToYN $inObj)
                                    }

                                    $TableParams = @{
                                        Name = "Events to File System - $($HVEnvironment.split(".").toUpper()[0])"
                                        List = $true
                                        ColumnWidths = 50, 50
                                    }

                                    if ($Report.ShowTableCaptions) {
                                        $TableParams['Caption'] = "- $($TableParams.Name)"
                                    }
                                    $OutObj | Table @TableParams
                                }
                            } catch {
                                Write-PScriboMessage -IsWarning $_.Exception.Message
                            }
                        }
                    }
                }
            }
        } catch {
            Write-PScriboMessage -IsWarning $_.Exception.Message
        }
    }
    end {}
}