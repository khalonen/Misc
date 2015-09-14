#-----------------------------------------------------------------------------
# Name:           	Fix-SP2013Aug2015Regression.ps1 
# Description:     	This script will fix the August 2015 CU Regression
# Usage:        	Run the script
# By:             	Ivan Josipovic, Softlanding.ca 
#-----------------------------------------------------------------------------
$ScriptLoc = "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\TEMPLATE\LAYOUTS\FORM.JS";
$ScriptDebugLoc = "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\TEMPLATE\LAYOUTS\FORM.debug.js";

#Fix Main File
$Script = Get-Content $ScriptLoc -Raw;
if($Script.IndexOf("else{if(IndexOfIllegalCharInUrlLeafName(c)!=-1)") -ne -1){
	# Backup File
	Copy-Item -Path $ScriptLoc -Destination $($ScriptLoc + "_bak");
	# Modify File
	$Script = $Script.Replace("else{if(IndexOfIllegalCharInUrlLeafName(c)!=-1)", 'else{var j=c.substring(c.lastIndexOf("\\")+1);if(IndexOfIllegalCharInUrlLeafName(j)!=-1)');
	# Save File
	Out-File -FilePath $ScriptLoc -InputObject $Script;
	Write-Host "FORM.JS is patched.";
} else {
	Write-Host "FORM.JS was already patched.";
}

#Fix Debug File
$ScriptDebug = Get-Content $ScriptDebugLoc -Raw;
if($ScriptDebug.IndexOf("if (IndexOfIllegalCharInUrlLeafName(filename) != -1) {") -ne -1){
	# Backup File
	Copy-Item -Path $ScriptDebugLoc -Destination $($ScriptDebugLoc + "_bak");
	# Modify File
	$ScriptDebug = $ScriptDebug.Replace("if (IndexOfIllegalCharInUrlLeafName(filename) != -1) {", "var filNameOnly = filename.substring(filename.lastIndexOf('\\') + 1);`r`n`tif (IndexOfIllegalCharInUrlLeafName(filNameOnly) != -1) {");
	# Save File
	Out-File -FilePath $ScriptDebugLoc -InputObject $ScriptDebug;
	Write-Host "FORM.debug.js is patched.";
} else {
	Write-Host "FORM.debug.js was already patched.";
}