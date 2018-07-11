*** Settings ***
Library	  SeleniumLibrary
#Library   Selenium2Library
Library   BuiltIn

Test Setup  Begin Web Test
Test Teardown  End Web Test

# Copy/paste the line below into the Terminal to run the script if you have Robot
# installed on your local machine
# pybot -d results --variable  BROWSER:firefox test/simpletest.robot
*** Variables ***
${BROWSER}		%{BROWSER}
${URL} =  https://www.clicktripz.com/test.php
${FirstCampaign} =  id=a_provider_1_container
${CitySearchForm} =  id=city
${City} =  Honolulu
${CheckInDateCalendarIcon} =  //*[@id="hotelSmallSearchForm"]/div[2]/div/img
${SearchButton} =  //*[@id="search-button"]
${PubID} =  PUBLISHER_ID = '4'
${NumberOfDeals} =  //*[@id="ct-header"]/ul
${EU_Title} =  Compare Travel Sites


*** Test Cases ***
Launch an Exit Unit from /test.php
	1. Load Test Page
	2. Verify Page Loaded
	3. Click on Search Form and Type a City Name
	4. Click on Calendar
	5. Verify if There are Campaigns and Click on Search Button
    6. Get Browser Window Titles and Switch to Exit Unit
    7. Verify Pub ID
    8. Capture the Exit Unit deeplink
	9. Click on Each Ad from Exit Unit and Make a ScreenShot


*** Keywords ***
Begin Web Test
    Open Browser  about:blank  ${BROWSER}

End Web Test
    Close Browser

1. Load Test Page
    Go to  ${URL}

2. Verify Page Loaded
    Wait Until Page Contains Element    ${FirstCampaign}

3. Click on Search Form and Type a City Name
    Clear Element Text  ${CitySearchForm}
	Input text  ${CitySearchForm}  ${City}

4. Click on Calendar
    Click Element  ${CheckInDateCalendarIcon}
    Click Element  ${CheckInDateCalendarIcon}
    sleep  1s

5. Verify if There are Campaigns and Click on Search Button
    ${passed}   ${value} =	 Run Keyword And Ignore Error	Page Should Contain Element  ${FirstCampaign}
    Run Keyword If	  '${passed}'=='PASS'    Click Element  ${SearchButton}
    Run Keyword Unless    '${passed}'=='PASS'   Log   No Campaigns Available for Specified City Name

6. Get Browser Window Titles and Switch to Exit Unit
    @{Popup_Title}  Get Window Titles
    Log  @{Popup_Title}[1]
    Select Window  @{Popup_Title}[1]
    sleep  2s
    Log  @{Popup_Title}[0]
    Select Window  @{Popup_Title}[0]
    @{Popup_Title}  Get Window Titles
    Log  @{Popup_Title}[1]
    Select Window  @{Popup_Title}[1]
    Wait Until Page Contains  ${City}  10s

7. Verify Pub ID
    Page Should Contain  ${PubID}
8. Capture the Exit Unit deeplink
    Log Location

9. Click on Each Ad from Exit Unit and Make a ScreenShot
    Page Should Contain  ${City}
    #@{iframes}=  List Windows
    Mouse Over  ${NumberOfDeals}
    ${Temp} =  get matching xpath count  xpath=${NumberOfDeals}/li
    Should be true  ${Temp} > 1
    Log  ${Temp}
    ${Deals} =  Convert to Integer  ${Temp}
    : FOR  ${Advertiser}  IN RANGE  1  ${Deals}+1
    \  @{Popup_Title}  Get Window Titles
    \  Select Window  @{Popup_Title}[1]
    \  Wait For Condition    return window.document.title == "${EU_Title}"
    \  Mouse Over  //*[@id="ct-header"]/ul/li[${Advertiser}]/div/a/span[1]/img
    \  Click Element  //*[@id="ct-header"]/ul/li[${Advertiser}]/div/a/span[1]/img
    \  sleep  3s
    \  @{Popup_Title}  Get Window Titles
    \  ${length} =	Get Length	${Popup_Title}
    \  ${arg}   ${val} =	 Run Keyword And Ignore Error	Should be true  ${length} > 2
    \  Run Keyword If	  '${arg}'=='PASS'
    \  ...  Run Keywords
    \  ...  Select Window  @{Popup_Title}[1]
    \  ...  AND    Log  @{Popup_Title}[2]
    \  ...  AND    Select Window  @{Popup_Title}[2]
    \  ...  AND    Wait For Condition    return window.document.title !== "undefined"
    \  ...  AND    Capture Page Screenshot
    \  ...  AND    Close Window
    \  ...  ELSE   Capture Page Screenshot


