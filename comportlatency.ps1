If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))

{
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Break
}


$pathToFTDIPorts = 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\FTDIBUS'
$obdIniPath = 'C:\EDIABAS\Bin\obd.ini'

# Function to read INI files, took from Stack Overflow
function Get-IniFile
{
    param(
        [parameter(Mandatory = $true)] [string] $filePath
    )

    $anonymous = "NoSection"

    $ini = @{}
    switch -regex -file $filePath
    {
        "^\[(.+)\]$" # Section
        {
            $section = $matches[1]
            $ini[$section] = @{}
            $CommentCount = 0
        }

        "^(;.*)$" # Comment
        {
            if (!($section))
            {
                $section = $anonymous
                $ini[$section] = @{}
            }
            $value = $matches[1]
            $CommentCount = $CommentCount + 1
            $name = "Comment" + $CommentCount
            $ini[$section][$name] = $value
        }

        "(.+?)\s*=\s*(.*)" # Key
        {
            if (!($section))
            {
                $section = $anonymous
                $ini[$section] = @{}
            }
            $name,$value = $matches[1..2]
            $ini[$section][$name] = $value
        }
    }

    return $ini
}

# Get COM port set for EDIABAS
try {
    $obdIni = Get-IniFile $obdIniPath -ErrorAction Stop
    $portName = $obdIni.OBD.Port
    Write-Host "Found $portName in $obdIniPath" -ForegroundColor Blue
}
catch {
    Write-Host "Failed to read $obdIniPath, exiting." -ForegroundColor Red
    read-host 'Press ENTER to exit...'
    break
}

try {
    # Getting all FTDI com ports
    $ftdiPorts = Get-ChildItem -Path $pathToFTDIPorts -ErrorAction Stop
}
catch [System.Management.Automation.ItemNotFoundException] {
    Write-Host 'No FTDI COM ports found, exiting.' -ForegroundColor Red
    read-host 'Press ENTER to exit...'
    break
}
$found = $false
foreach ($port in $ftdiPorts) {
    # $portParams = Get-ChildItem -path  $port
    $paramsPath = ('Registry::' +  $port.Name + '\0000\Device Parameters')
    $portParams = Get-ItemProperty -Path $paramsPath
    if ($portParams.PortName.ToLower() -eq $portName.ToLower() ) {
        Write-Host "Found $portName, $port" -ForegroundColor Blue
        $found = $true
        if ($portParams.LatencyTimer -ne 1) {
            Write-Host 'Latency timer is not set to 1, setting to 1' -ForegroundColor Yellow
            Set-ItemProperty -Path $paramsPath -Name LatencyTimer -Value 1
        }
        else {
            Write-Host 'Latency already set to 1' -ForegroundColor Green
        }
        Write-Host '------------------------------------------------'

    }
}

if ($found -ne $true) {
    Write-Host "No $portName was found, check if device exist"
}
read-host 'Press ENTER to exit...'
