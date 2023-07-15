proc exportToSDK {} {
  cd D:/Egitim/ELEYLT-TezCalismasi/Work/v0_8/ISE/mpu
  if { [ catch { xload xmp mpu.xmp } result ] } {
    exit 10
  }
  if { [run exporttosdk] != 0 } {
    return -1
  }
  return 0
}

if { [catch {exportToSDK} result] } {
  exit -1
}

set sExportDir [ xget sdk_export_dir ]
set sExportDir [ file join "D:/Egitim/ELEYLT-TezCalismasi/Work/v0_8/ISE/mpu" "$sExportDir" "hw" ] 
if { [ file exists D:/Egitim/ELEYLT-TezCalismasi/Work/v0_8/ISE/edkBmmFile_bd.bmm ] } {
   puts "Copying placed bmm file D:/Egitim/ELEYLT-TezCalismasi/Work/v0_8/ISE/edkBmmFile_bd.bmm to $sExportDir" 
   file copy -force "D:/Egitim/ELEYLT-TezCalismasi/Work/v0_8/ISE/edkBmmFile_bd.bmm" $sExportDir
}
if { [ file exists D:/Egitim/ELEYLT-TezCalismasi/Work/v0_8/ISE/cnn_system.bit ] } {
   puts "Copying bit file D:/Egitim/ELEYLT-TezCalismasi/Work/v0_8/ISE/cnn_system.bit to $sExportDir" 
   file copy -force "D:/Egitim/ELEYLT-TezCalismasi/Work/v0_8/ISE/cnn_system.bit" $sExportDir
}
exit $result
