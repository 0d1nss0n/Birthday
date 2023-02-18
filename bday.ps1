
#########################################################################################################################################

# Download Image; replace link to $image to add your own image

$image =  "https://raw.githubusercontent.com/0d1nss0n/TWSS/main/twss.jpg"

$i = -join($image,"?dl=1")

iwr $i -O $env:TMP\i.jpg

# Download WAV file; replace link to $wav to add your own sound

$mp3 = "https://github.com/0d1nss0n/Birthday/blob/main/tootisie-roll.mp3?raw=true"

$w = -join($mp3,"?dl=1")
iwr $w -O $env:TMP\s.mp3


#########################################################################################################################################

Function Minimize-All
{
	$apps = New-Object -ComObject Shell.Application
	$apps.MinimizeAll()
}


#########################################################################################################################################

Function Set-WallPaper {
 
param (
    [parameter(Mandatory=$True)]
    [string]$Image,
    [parameter(Mandatory=$False)]
    [ValidateSet('Fill', 'Fit', 'Stretch', 'Tile', 'Center', 'Span')]
    [string]$Style
)
 
$WallpaperStyle = Switch ($Style) {
  
    "Fill" {"10"}
    "Fit" {"6"}
    "Stretch" {"2"}
    "Tile" {"0"}
    "Center" {"0"}
    "Span" {"22"}
  
}
 
If($Style -eq "Tile") {
 
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $WallpaperStyle -Force
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 1 -Force
 
}
Else {
 
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -PropertyType String -Value $WallpaperStyle -Force
    New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name TileWallpaper -PropertyType String -Value 0 -Force
 
}
 
Add-Type -TypeDefinition @" 
using System; 
using System.Runtime.InteropServices;
  
public class Params
{ 
    [DllImport("User32.dll",CharSet=CharSet.Unicode)] 
    public static extern int SystemParametersInfo (Int32 uAction, 
                                                   Int32 uParam, 
                                                   String lpvParam, 
                                                   Int32 fuWinIni);
}
"@ 
  
    $SPI_SETDESKWALLPAPER = 0x0014
    $UpdateIniFile = 0x01
    $SendChangeEvent = 0x02
  
    $fWinIni = $UpdateIniFile -bor $SendChangeEvent
  
    $ret = [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Image, $fWinIni)
}
 
#########################################################################################################################################

# Set Volume to Max

$k=[Math]::Ceiling(100/2);$o=New-Object -ComObject WScript.Shell;for($i = 0;$i -lt $k;$i++){$o.SendKeys([char] 175)}

#########################################################################################################################################

function Play-MP3{
$PlayMP3=New-Object System.Media.SoundPlayer;$PlayMp3.SoundLocation="$env:TMP\s.mp3";$PlayMp3.playsync()
}

Play-MP3

Add-Type -AssemblyName presentationCore
$mediaPlayer = New-Object system.windows.media.mediaplayer
$mediaPlayer.open("$env:tmp\s.mp3")
$mediaPlayer.Play()

#########################################################################################################################################

# Show a popup to notify script is ready

$popmessage = "Happy Birthday"

$readyNotice = New-Object -ComObject Wscript.Shell;$readyNotice.Popup($popmessage)

#########################################################################################################################################

# Pause the script and wait for movement of the mouse before continuing

Add-Type -AssemblyName System.Windows.Forms
$originalPOS = [System.Windows.Forms.Cursor]::Position.X

    while (1) {
        $pauseTime = 3
        if ([Windows.Forms.Cursor]::Position.X -ne $originalPOS){
            break
        }
        else {
            $o.SendKeys("{CAPSLOCK}");Start-Sleep -Seconds $pauseTime
        }
    }

########################################################################################################################################
 

$one = "Happy Birthday..... I made something special for your big day.... I hope you enjoy it.........."

$two = "I hope you like your new wallpaper"

$three = "And lastly... a classic birthday song from your childhood......" 


########################################################################################################################################

# this is where your message is spoken line by line

$s=New-Object -ComObject SAPI.SpVoice

# $s.Rate sets how fast Sapi Speaks

$s.Rate = -1

$s.Speak($one)

Minimize-All

Play-MP3

Set-WallPaper -Image "$env:TMP\i.jpg" -Style Fit


########################################################################################################################################

# Delete contents of Temp folder 

rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

# Delete run box history

reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

# Delete powershell history

Remove-Item (Get-PSreadlineOption).HistorySavePath

# Deletes contents of recycle bin

Clear-RecycleBin -Force -ErrorAction SilentlyContinue

########################################################################################################################################

# This script repeadedly presses the capslock button, this snippet will make sure capslock is turned back off 

Add-Type -AssemblyName System.Windows.Forms
$caps = [System.Windows.Forms.Control]::IsKeyLocked('CapsLock')

#If true, toggle CapsLock key, to ensure that the script doesn't fail
if ($caps -eq $true){

$key = New-Object -ComObject WScript.Shell
$key.SendKeys('{CapsLock}')
}

########################################################################################################################################
