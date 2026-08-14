param([string]$TargetPath)
$path = $TargetPath.TrimEnd([char]47)
$shell = New-Object -ComObject Shell.Application
$win = @($shell.Windows() | Where-Object {
    $null -ne $_.Document -and $null -ne $_.Document.Folder -and
    $_.Document.Folder.Self.Path.Replace([char]92, [char]47).TrimEnd([char]47) -eq $path
})[0]

if ($win) {
    $win.Refresh()
    (New-Object -ComObject WScript.Shell).AppActivate($win.Name)
} else {
    $winPath = $path.Replace([char]47, [char]92)
    Invoke-Item -LiteralPath $winPath
}
