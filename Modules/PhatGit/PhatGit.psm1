## Import PhatGit.ps1
$moduleRoot = Split-Path -Parent $MyInvocation.MyCommand.Path;
. (Join-Path -Path $moduleRoot -ChildPath 'PhatGit.ps1');

## Set default global known commands. These can be overridden in a user's profile as required.
## NOTE: It's important to specify matching command parameters BEFORE missing parameters!
$knownGitCommands = @(
    @{ Command = 'commit'; Parameter = '--interactive'; Exists = $true; MessageId = 'InteractiveCommitMessageWarning'; }
    @{ Command = 'commit'; Parameter = '-m'; Exists = $false; MessageId = 'MissingCommitMessageWarning'; }
)
$ignoredGitCommands = @(
    @{ Command = 'push'; }
    @{ Command = 'pull'; }
    @{ Command = 'clone'; }
)
## Set the variables in the parent scope.
Set-Variable -Name PhatGitKnownCommands -Value $knownGitCommands -Scope 1 -Visibility Public;
Set-Variable -Name PhatGitIgnoredCommands -Value $ignoredGitCommands -Scope 1 -Visibility Public;

New-Alias -Name Git -Value Invoke-PhatGit;
Export-ModuleMember -Function Invoke-PhatGit -Alias Git;

# SIG # Begin signature block
# MIIaogYJKoZIhvcNAQcCoIIakzCCGo8CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU+1TmaPLIrZLtshfMIbJDGOOv
# EWmgghXYMIID7jCCA1egAwIBAgIQfpPr+3zGTlnqS5p31Ab8OzANBgkqhkiG9w0B
# AQUFADCBizELMAkGA1UEBhMCWkExFTATBgNVBAgTDFdlc3Rlcm4gQ2FwZTEUMBIG
# A1UEBxMLRHVyYmFudmlsbGUxDzANBgNVBAoTBlRoYXd0ZTEdMBsGA1UECxMUVGhh
# d3RlIENlcnRpZmljYXRpb24xHzAdBgNVBAMTFlRoYXd0ZSBUaW1lc3RhbXBpbmcg
# Q0EwHhcNMTIxMjIxMDAwMDAwWhcNMjAxMjMwMjM1OTU5WjBeMQswCQYDVQQGEwJV
# UzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xMDAuBgNVBAMTJ1N5bWFu
# dGVjIFRpbWUgU3RhbXBpbmcgU2VydmljZXMgQ0EgLSBHMjCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBALGss0lUS5ccEgrYJXmRIlcqb9y4JsRDc2vCvy5Q
# WvsUwnaOQwElQ7Sh4kX06Ld7w3TMIte0lAAC903tv7S3RCRrzV9FO9FEzkMScxeC
# i2m0K8uZHqxyGyZNcR+xMd37UWECU6aq9UksBXhFpS+JzueZ5/6M4lc/PcaS3Er4
# ezPkeQr78HWIQZz/xQNRmarXbJ+TaYdlKYOFwmAUxMjJOxTawIHwHw103pIiq8r3
# +3R8J+b3Sht/p8OeLa6K6qbmqicWfWH3mHERvOJQoUvlXfrlDqcsn6plINPYlujI
# fKVOSET/GeJEB5IL12iEgF1qeGRFzWBGflTBE3zFefHJwXECAwEAAaOB+jCB9zAd
# BgNVHQ4EFgQUX5r1blzMzHSa1N197z/b7EyALt0wMgYIKwYBBQUHAQEEJjAkMCIG
# CCsGAQUFBzABhhZodHRwOi8vb2NzcC50aGF3dGUuY29tMBIGA1UdEwEB/wQIMAYB
# Af8CAQAwPwYDVR0fBDgwNjA0oDKgMIYuaHR0cDovL2NybC50aGF3dGUuY29tL1Ro
# YXd0ZVRpbWVzdGFtcGluZ0NBLmNybDATBgNVHSUEDDAKBggrBgEFBQcDCDAOBgNV
# HQ8BAf8EBAMCAQYwKAYDVR0RBCEwH6QdMBsxGTAXBgNVBAMTEFRpbWVTdGFtcC0y
# MDQ4LTEwDQYJKoZIhvcNAQEFBQADgYEAAwmbj3nvf1kwqu9otfrjCR27T4IGXTdf
# plKfFo3qHJIJRG71betYfDDo+WmNI3MLEm9Hqa45EfgqsZuwGsOO61mWAK3ODE2y
# 0DGmCFwqevzieh1XTKhlGOl5QGIllm7HxzdqgyEIjkHq3dlXPx13SYcqFgZepjhq
# IhKjURmDfrYwggSjMIIDi6ADAgECAhAOz/Q4yP6/NW4E2GqYGxpQMA0GCSqGSIb3
# DQEBBQUAMF4xCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3Jh
# dGlvbjEwMC4GA1UEAxMnU3ltYW50ZWMgVGltZSBTdGFtcGluZyBTZXJ2aWNlcyBD
# QSAtIEcyMB4XDTEyMTAxODAwMDAwMFoXDTIwMTIyOTIzNTk1OVowYjELMAkGA1UE
# BhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMTQwMgYDVQQDEytT
# eW1hbnRlYyBUaW1lIFN0YW1waW5nIFNlcnZpY2VzIFNpZ25lciAtIEc0MIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAomMLOUS4uyOnREm7Dv+h8GEKU5Ow
# mNutLA9KxW7/hjxTVQ8VzgQ/K/2plpbZvmF5C1vJTIZ25eBDSyKV7sIrQ8Gf2Gi0
# jkBP7oU4uRHFI/JkWPAVMm9OV6GuiKQC1yoezUvh3WPVF4kyW7BemVqonShQDhfu
# ltthO0VRHc8SVguSR/yrrvZmPUescHLnkudfzRC5xINklBm9JYDh6NIipdC6Anqh
# d5NbZcPuF3S8QYYq3AhMjJKMkS2ed0QfaNaodHfbDlsyi1aLM73ZY8hJnTrFxeoz
# C9Lxoxv0i77Zs1eLO94Ep3oisiSuLsdwxb5OgyYI+wu9qU+ZCOEQKHKqzQIDAQAB
# o4IBVzCCAVMwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDAO
# BgNVHQ8BAf8EBAMCB4AwcwYIKwYBBQUHAQEEZzBlMCoGCCsGAQUFBzABhh5odHRw
# Oi8vdHMtb2NzcC53cy5zeW1hbnRlYy5jb20wNwYIKwYBBQUHMAKGK2h0dHA6Ly90
# cy1haWEud3Muc3ltYW50ZWMuY29tL3Rzcy1jYS1nMi5jZXIwPAYDVR0fBDUwMzAx
# oC+gLYYraHR0cDovL3RzLWNybC53cy5zeW1hbnRlYy5jb20vdHNzLWNhLWcyLmNy
# bDAoBgNVHREEITAfpB0wGzEZMBcGA1UEAxMQVGltZVN0YW1wLTIwNDgtMjAdBgNV
# HQ4EFgQURsZpow5KFB7VTNpSYxc/Xja8DeYwHwYDVR0jBBgwFoAUX5r1blzMzHSa
# 1N197z/b7EyALt0wDQYJKoZIhvcNAQEFBQADggEBAHg7tJEqAEzwj2IwN3ijhCcH
# bxiy3iXcoNSUA6qGTiWfmkADHN3O43nLIWgG2rYytG2/9CwmYzPkSWRtDebDZw73
# BaQ1bHyJFsbpst+y6d0gxnEPzZV03LZc3r03H0N45ni1zSgEIKOq8UvEiCmRDoDR
# EfzdXHZuT14ORUZBbg2w6jiasTraCXEQ/Bx5tIB7rGn0/Zy2DBYr8X9bCT2bW+IW
# yhOBbQAuOA2oKY8s4bL0WqkBrxWcLC9JG9siu8P+eJRRw4axgohd8D20UaF5Mysu
# e7ncIAkTcetqGVvP6KUwVyyJST+5z3/Jvz4iaGNTmr1pdKzFHTx/kuDDvBzYBHUw
# ggaUMIIFfKADAgECAhAG8BXYFUYj6XmzRgEaZJSVMA0GCSqGSIb3DQEBBQUAMG8x
# CzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3
# dy5kaWdpY2VydC5jb20xLjAsBgNVBAMTJURpZ2lDZXJ0IEFzc3VyZWQgSUQgQ29k
# ZSBTaWduaW5nIENBLTEwHhcNMTMwNDE3MDAwMDAwWhcNMTUwNzE2MTIwMDAwWjBg
# MQswCQYDVQQGEwJHQjEPMA0GA1UEBxMGT3hmb3JkMR8wHQYDVQQKExZWaXJ0dWFs
# IEVuZ2luZSBMaW1pdGVkMR8wHQYDVQQDExZWaXJ0dWFsIEVuZ2luZSBMaW1pdGVk
# MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1dxm3r1cUKp7rYZBDAeo
# Lm0iLIgYuzeg7tC2mt7kEJfvGiSVx4/d3pYw2/GpDB08JjsoAYIfhWOuGtUf0RRy
# 5QcyrfWDCmLfUApf83/GJZrATWs1OPzdYEsLzVrx7ZtvcCVvlEIyG4RJmhSG2mZS
# 6P0D68a2/U4QmcNEGpnbTyszHds8BnVL1D3oQP+rcXN2jDP83/rECmGgYGexvRkV
# K/+HHrporgkT4KRMbrWXMRPrLQazIFeg1mnm1UtjxTXN7IPaY97qwxhxPqwpL3DH
# PdF/6+rC1ZQZ27akf5qporAlsftUe3URHFmmJ8NrLivANrwco9BY3If4iAvz9ipl
# mQIDAQABo4IDOTCCAzUwHwYDVR0jBBgwFoAUe2jOKarAF75JeuHlP9an90WPNTIw
# HQYDVR0OBBYEFNQ3nxxDKFobighYZExYqzXq8SQTMA4GA1UdDwEB/wQEAwIHgDAT
# BgNVHSUEDDAKBggrBgEFBQcDAzBzBgNVHR8EbDBqMDOgMaAvhi1odHRwOi8vY3Js
# My5kaWdpY2VydC5jb20vYXNzdXJlZC1jcy0yMDExYS5jcmwwM6AxoC+GLWh0dHA6
# Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9hc3N1cmVkLWNzLTIwMTFhLmNybDCCAcQGA1Ud
# IASCAbswggG3MIIBswYJYIZIAYb9bAMBMIIBpDA6BggrBgEFBQcCARYuaHR0cDov
# L3d3dy5kaWdpY2VydC5jb20vc3NsLWNwcy1yZXBvc2l0b3J5Lmh0bTCCAWQGCCsG
# AQUFBwICMIIBVh6CAVIAQQBuAHkAIAB1AHMAZQAgAG8AZgAgAHQAaABpAHMAIABD
# AGUAcgB0AGkAZgBpAGMAYQB0AGUAIABjAG8AbgBzAHQAaQB0AHUAdABlAHMAIABh
# AGMAYwBlAHAAdABhAG4AYwBlACAAbwBmACAAdABoAGUAIABEAGkAZwBpAEMAZQBy
# AHQAIABDAFAALwBDAFAAUwAgAGEAbgBkACAAdABoAGUAIABSAGUAbAB5AGkAbgBn
# ACAAUABhAHIAdAB5ACAAQQBnAHIAZQBlAG0AZQBuAHQAIAB3AGgAaQBjAGgAIABs
# AGkAbQBpAHQAIABsAGkAYQBiAGkAbABpAHQAeQAgAGEAbgBkACAAYQByAGUAIABp
# AG4AYwBvAHIAcABvAHIAYQB0AGUAZAAgAGgAZQByAGUAaQBuACAAYgB5ACAAcgBl
# AGYAZQByAGUAbgBjAGUALjCBggYIKwYBBQUHAQEEdjB0MCQGCCsGAQUFBzABhhho
# dHRwOi8vb2NzcC5kaWdpY2VydC5jb20wTAYIKwYBBQUHMAKGQGh0dHA6Ly9jYWNl
# cnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRENvZGVTaWduaW5nQ0Et
# MS5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQUFAAOCAQEAPsyUuxkYkEGE
# 1bl4g3Muy5QxQq8frp34BPf+Sm6E9J915eBizW72ofbm08O9NkQvszbT4GTZaO/o
# SExSDbLIxHI98zi7AavVPuRpmVnfoF55yVomh/BYAU8vu0M7FvUeIhSAUfz0Q8PK
# wT5U+SdNoE7+xgxd4zHjBA3kUo3TZ+R/+MDd2Hzv6vrgxUfGeQfBCwafdEjD4pHr
# 0kvXcPq6VnQpsv92P3wvgsCrsTKIgtaNIfkGe5eCcTQ7pYTBauZl+XmyFvyiADKo
# 6Dng4jyuxYRP3EdCGVlZK7sEmiz1Y2f3zh0xoF58B3xXDnRJxo8ArlEAG8KzXn6w
# ryaA1vbgITCCBqMwggWLoAMCAQICEA+oSQYV1wCgviF2/cXsbb0wDQYJKoZIhvcN
# AQEFBQAwZTELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcG
# A1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEkMCIGA1UEAxMbRGlnaUNlcnQgQXNzdXJl
# ZCBJRCBSb290IENBMB4XDTExMDIxMTEyMDAwMFoXDTI2MDIxMDEyMDAwMFowbzEL
# MAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3
# LmRpZ2ljZXJ0LmNvbTEuMCwGA1UEAxMlRGlnaUNlcnQgQXNzdXJlZCBJRCBDb2Rl
# IFNpZ25pbmcgQ0EtMTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJx8
# +aCPCsqJS1OaPOwZIn8My/dIRNA/Im6aT/rO38bTJJH/qFKT53L48UaGlMWrF/R4
# f8t6vpAmHHxTL+WD57tqBSjMoBcRSxgg87e98tzLuIZARR9P+TmY0zvrb2mkXAEu
# sWbpprjcBt6ujWL+RCeCqQPD/uYmC5NJceU4bU7+gFxnd7XVb2ZklGu7iElo2NH0
# fiHB5sUeyeCWuAmV+UuerswxvWpaQqfEBUd9YCvZoV29+1aT7xv8cvnfPjL93Sos
# MkbaXmO80LjLTBA1/FBfrENEfP6ERFC0jCo9dAz0eotyS+BWtRO2Y+k/Tkkj5wYW
# 8CWrAfgoQebH1GQ7XasCAwEAAaOCA0MwggM/MA4GA1UdDwEB/wQEAwIBhjATBgNV
# HSUEDDAKBggrBgEFBQcDAzCCAcMGA1UdIASCAbowggG2MIIBsgYIYIZIAYb9bAMw
# ggGkMDoGCCsGAQUFBwIBFi5odHRwOi8vd3d3LmRpZ2ljZXJ0LmNvbS9zc2wtY3Bz
# LXJlcG9zaXRvcnkuaHRtMIIBZAYIKwYBBQUHAgIwggFWHoIBUgBBAG4AeQAgAHUA
# cwBlACAAbwBmACAAdABoAGkAcwAgAEMAZQByAHQAaQBmAGkAYwBhAHQAZQAgAGMA
# bwBuAHMAdABpAHQAdQB0AGUAcwAgAGEAYwBjAGUAcAB0AGEAbgBjAGUAIABvAGYA
# IAB0AGgAZQAgAEQAaQBnAGkAQwBlAHIAdAAgAEMAUAAvAEMAUABTACAAYQBuAGQA
# IAB0AGgAZQAgAFIAZQBsAHkAaQBuAGcAIABQAGEAcgB0AHkAIABBAGcAcgBlAGUA
# bQBlAG4AdAAgAHcAaABpAGMAaAAgAGwAaQBtAGkAdAAgAGwAaQBhAGIAaQBsAGkA
# dAB5ACAAYQBuAGQAIABhAHIAZQAgAGkAbgBjAG8AcgBwAG8AcgBhAHQAZQBkACAA
# aABlAHIAZQBpAG4AIABiAHkAIAByAGUAZgBlAHIAZQBuAGMAZQAuMBIGA1UdEwEB
# /wQIMAYBAf8CAQAweQYIKwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8v
# b2NzcC5kaWdpY2VydC5jb20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRp
# Z2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcnQwgYEGA1UdHwR6
# MHgwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3Vy
# ZWRJRFJvb3RDQS5jcmwwOqA4oDaGNGh0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9E
# aWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwHQYDVR0OBBYEFHtozimqwBe+SXrh
# 5T/Wp/dFjzUyMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6enIZ3zbcgPMA0GCSqG
# SIb3DQEBBQUAA4IBAQB7ch1k/4jIOsG36eepxIe725SS15BZM/orh96oW4AlPxOP
# m4MbfEPE5ozfOT7DFeyw2jshJXskwXJduEeRgRNG+pw/alE43rQly/Cr38UoAVR5
# EEYk0TgPJqFhkE26vSjmP/HEqpv22jVTT8nyPdNs3CPtqqBNZwnzOoA9PPs2TJDn
# dqTd8jq/VjUvokxl6ODU2tHHyJFqLSNPNzsZlBjU1ZwQPNWxHBn/j8hrm574rpyZ
# lnjRzZxRFVtCJnJajQpKI5JA6IbeIsKTOtSbaKbfKX8GuTwOvZ/EhpyCR0JxMoYJ
# mXIJeUudcWn1Qf9/OXdk8YSNvosesn1oo6WQsQz/MYIENDCCBDACAQEwgYMwbzEL
# MAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3
# LmRpZ2ljZXJ0LmNvbTEuMCwGA1UEAxMlRGlnaUNlcnQgQXNzdXJlZCBJRCBDb2Rl
# IFNpZ25pbmcgQ0EtMQIQBvAV2BVGI+l5s0YBGmSUlTAJBgUrDgMCGgUAoHgwGAYK
# KwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIB
# BDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU
# 6xKPSEAvWtTPqod/E36Jq/Rg4y8wDQYJKoZIhvcNAQEBBQAEggEAPMM05J+souw6
# DRlGgcI1Z4jWajecYpiPsOqeGIiLS8a/gaFmV9AR72L36Dp+lnTGQjUKfBZOQTR9
# tZCTXc80ypECUkXaOXs7s+4UI1bDqn0Mgbf9TsMszcjp8FMTy0mwQx0/k8l7FoXy
# s3LR4HU0H8OMHQPrwieFI7ge4IF94fk/+VNSuQSIC+BNzvfpWQUke+9MTfijrHws
# SyRtji09MUeobHSUfBf7nOx6k9ud2r2gnucYtwU2PZ7aP2vCiSaFyMRrmDOrofRG
# orIgyzlzPoWoM5+si7n45gZekx6ZzJ8E/s6lWlVqmukDGxYk6souOCf6epzgn4Am
# VBKcWRhUN6GCAgswggIHBgkqhkiG9w0BCQYxggH4MIIB9AIBATByMF4xCzAJBgNV
# BAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3JhdGlvbjEwMC4GA1UEAxMn
# U3ltYW50ZWMgVGltZSBTdGFtcGluZyBTZXJ2aWNlcyBDQSAtIEcyAhAOz/Q4yP6/
# NW4E2GqYGxpQMAkGBSsOAwIaBQCgXTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
# MBwGCSqGSIb3DQEJBTEPFw0xNTA1MTIxNTQ2MzFaMCMGCSqGSIb3DQEJBDEWBBTn
# +zlkyQ0kMOHPvnsb6n0L24gnZjANBgkqhkiG9w0BAQEFAASCAQANMqWijfcS2Yaz
# 5DQI5CO/s7CKAOuooj2cTRbMC7g4u9XjebuKT6eMn+ZEQMYex52KJtmQlnk3zZeh
# HKTGOHRmrquVPnltA/SdfHB2HLMVP2PuRKlkgMR5KUhKVbg7Mrh9b97YFf4HTVBx
# aLBPgNL24vDDd6oRiFaendyn3SilRC1G2r+MaN4OoetcO7HHW5yIzThJaWwuxzb6
# SYmhKFpnx6lhQn91CZ+JdVDz9Vj00EMS7JLleDIH5Acp+2tA3/crtqLjP0LNDXYJ
# ef3Z07stf3plUSb17+1DDU9s1tI/pJ8oY+YVPyHLuEWNHrQjvSCE+9bTZP+g8we2
# PxnVjXY3
# SIG # End signature block
