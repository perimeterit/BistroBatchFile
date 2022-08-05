::NOTES, NO INLINE COMMENTS!

::VARIABLES CHANGE FROM NEW
SET "bistro_csv_name=Bistro_Current_Records_%date%.csv"
SET "BISTRODIR=\\smb\Bistro\!NEW-BISTRO\CURRENT_RECORD"
SET "BISTROLOGS=\\smb\Bistro\!NEW-BISTRO\CURRENT_LOGS"
SET "OLD_FOLDER=\\smb\Bistro\!NEW-BISTRO\PAST_RECORDS"
SET "LOCAL_LOGS=C:\Program Files (x86)/SilverWare Loyalty App\logs"


:: 1. GET DATA -WORKING
curl -L "http://az-webtools-p.pi.local:18791/bistro/csv" --output %bistro_csv_name%

:: 1.1 MOVE OLD FILES INTO "OLD" LOCATION - WORKING
xcopy /b/v/y/s %BISTRODIR% %OLD_FOLDER% 

:: 2. DELETE ALL PREVIOUS CSVS? -- COMPLETELY unintelligible but works :: THIS WILL DELETE  eveyrhting, cant use it
FOR /d %%a IN ("%BISTRODIR%\*") DO IF /i NOT "%%~nxa"=="%BISTRODIR%" RD /S /Q "%%a"
FOR %%a IN ("%BISTRODIR%\*") DO IF /i NOT "%%~nxa"=="%bistro_csv_name%" DEL "%%a " 

:: 3. COPY FILES INTO NEW FOLDER 
xcopy /b/v/y "%bistro_csv_name%" "%BISTRODIR%"

:: 4. RUN SCRIPTS
::cd %programfiles(x86)%\SilverWare Loyalty App\
::LoyaltyApp.exe /Mode=ImportClients /ImportClientFilePath="C:\PI\data_imports_temp\%bistro_csv_name%" /ImportClientUpdateColumn=interfaceID /ImportClientIncludeHeader=True /ImportClientUpdateMoneyBalanceMode=12
echo 'ran loyalty'

:: 5.COPY LOGS INTO BISTRO LOG LOCATION :: DELETE ALL OLD LOGS? OR DOES IT GET COPIED OVER
xcopy /b/v/y "%LOCAL_LOGS%" "%BISTROLOGS%"

:: 6. HEARTBEAT -- below is just trying to figure out how to work it for now
curl --header "Authorization: GenieKey 594d62bf-7fc3-4773-92c8-12137c190b0b" "https://api.opsgenie.com/v2/heartbeats/Bistro-Account-Import/ping" 
	
:: 7. PROPER EXIT
echo 'EXITING .BAT FILE'
exit /b 1 




