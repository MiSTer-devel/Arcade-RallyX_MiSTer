@powershell -NoProfile -ExecutionPolicy Unrestricted "$s=[scriptblock]::create((gc \"%~f0\"|?{$_.readcount -gt 1})-join\"`n\");&$s" %*&goto:eof

function SplitFile ($inFile, $outPrefix, [Int32] $bufSize) {
  $stream = [System.IO.File]::OpenRead("tmp/$inFile")
  $chunkNum = 0
  $barr = New-Object byte[] $bufSize

  while( $bytesRead = $stream.Read($barr,0,$bufsize)){
    $outFile = "tmp/$outPrefix$chunkNum"
    $ostream = [System.IO.File]::OpenWrite($outFile)
    $ostream.Write($barr,0,$bytesRead);
    $ostream.close();
    $chunkNum += 1
  }
  $stream.close();
}
#==============================================================
$zip="nrallyx.zip"
$ifiles="prg1_0","prg2_0","prg1_1","prg2_1","prg3_0","prg4_0","prg3_1","prg4_1","../bang_snd.bin","nrx_chg1.8e","nrx_chg2.8d","rx1-6.8m","rx1-5.3p","nrx1-7.8p","nrx1-1.11n"
$ofile="a.nrallyx.rom"

Expand-Archive -Path "./$zip" -Destination ./tmp/ -Force
SplitFile "nrx_prg1.1d" "prg1_" 2048
SplitFile "nrx_prg2.1e" "prg2_" 2048
SplitFile "nrx_prg3.1k" "prg3_" 2048
SplitFile "nrx_prg4.1l" "prg4_" 2048
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
