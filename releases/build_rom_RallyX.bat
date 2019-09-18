@powershell -NoProfile -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof
#==============================================================
$zip="rallyx.zip"
$ifiles="1b","rallyxn.1e","rallyxn.1h","rallyxn.1k","../bang_snd.bin","8e","rx1-6.8m","rx1-5.3p","rx1-7.8p","rx1-1.11n"
$ofile="a.rallyx.rom"

Expand-Archive -Path "./$zip" -Destination ./tmp/ -Force
cd tmp
Get-Content $ifiles -Enc Byte -Read 512 | Set-Content "../$ofile" -Enc Byte
cd ..
Remove-Item ./tmp -Recurse -Force

echo "** done **"
echo ""
echo "Copy $ofile into root of SD card"
echo ""
echo ""
pause
