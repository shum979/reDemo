echo off
CLS
SETLOCAL ENABLEDELAYEDEXPANSION

SET PATH_TO_FILE=%1
SET FILE_NAME=%2
SET EXTERNAL_JAR_LOCATION=
SET EXTERNAL_JAR_PROPERTY_NAME=externalJarLocation
SET JAR_NAMES_LIST=
SET EXTERNAL_JAR_PROPERTY_NAME_STRING_LENGTH=20

call :get_external_jar_location %EXTERNAL_JAR_PROPERTY_NAME% %FILE_NAME% %EXTERNAL_JAR_PROPERTY_NAME_STRING_LENGTH% EXTERNAL_JAR_LOCATION

call :getJarNames JAR_NAMES_LIST %EXTERNAL_JAR_LOCATION%

IF "%PATH_TO_FILE%"=="" (
	echo "Please provide DataSource XML file to start."
	goto end
)

echo "Recon Job Started"

IF "%JAR_NAMES_LIST%"=="""" (
	spark-submit --driver-class-path %FILE_NAME%\config --files %FILE_NAME%\config\app.conf,%FILE_NAME%\config\log4j.properties --conf spark.local.dir=D:\\tmpdelete --class com.sapient.main.OpenBankApp %FILE_NAME%\lib\open-bank-fluid-data.jar %PATH_TO_FILE%
) ELSE (
	spark-submit --driver-class-path %FILE_NAME%\config --jars %JAR_NAMES_LIST% --files %FILE_NAME%\config\app.conf --conf spark.local.dir=D:\\tmpdelete --class com.sapient.main.OpenBankApp %FILE_NAME%\lib\open-bank-fluid-data.jar %PATH_TO_FILE%
)

:end
endlocal

:get_external_jar_location
SET EXTERNAL_JAR_LOCATION=
set EXTERNAL_JAR_PROPERTY_NAME=%1
set FILE_NAME=%2
set EXTERNAL_JAR_PROPERTY_NAME_STRING_LENGTH=%3
FOR /f %%i in ('FINDSTR /i %EXTERNAL_JAR_PROPERTY_NAME% %FILE_NAME%\config\app.conf') do set EXTERNAL_JAR_LOCATION=%%i
set EXTERNAL_JAR_LOCATION=!EXTERNAL_JAR_LOCATION:~%EXTERNAL_JAR_PROPERTY_NAME_STRING_LENGTH%!
set EXTERNAL_JAR_LOCATION=%EXTERNAL_JAR_LOCATION:"=%
set %4=%EXTERNAL_JAR_LOCATION%
exit /b 0


:getJarNames
set JAR_NAMES=""
set JARS_DIR_LOCATION=%2
for %%g in (%JARS_DIR_LOCATION%\*.jar) do (
	set JAR_NAMES=!JAR_NAMES!,%%g
)
call set str=%%JAR_NAMES:"",=%%
set %1=%str%
exit /b 0