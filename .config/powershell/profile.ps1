Function Get-RandomPassword
{
  Param(
    [Int]
    $PasswordLength = 32
  )
  $allChars = [char[]](33..126)
  $password = (Get-Random -InputObject $allChars -Count $PasswordLength) -join ''
  return $password
}

# Don't show progress bars by default - speeds downloads and the like up a lot
$ProgressPreference = 'SilentlyContinue';
