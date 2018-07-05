*** Settings***
Library			SeleniumLibrary

*** Variables ***
${BROWSER}		%{BROWSER}
${test.php} =  https://www.clicktripz.com/test.php

*** Test Cases ***
Visit /test.php
	Open Browser			${test.php}	${BROWSER}
	Capture Page Screenshot
