# -*- coding: utf-8 -*-
*** Settings ***
Documentation     O robo desenvolvido consiste na resolução do desafio RPA, onde ele deve
...               realizar o preenchimento do formulário, com base nos dados fornecidos via arquivo xlsx
...               do Excel
Library           RPA.Browser.Selenium
Library           RPA.Excel.Files
Library           RPA.HTTP

*** Keywords ***
Get The List Of People From The Excel File
    Open Workbook    challenge.xlsx
    ${table}=    Read Worksheet As Table    header=True
    Close Workbook
    [Return]    ${table}

*** Keywords ***
Set Value By Xpath
    [Arguments]    ${xpath}    ${value}
    ${result}=    Execute Javascript    document.evaluate('${xpath}',document.body,null,9,null).singleNodeValue.value='${value}';
    [Return]    ${result}


*** Keywords ***
Fill And Submit The Form
    [Arguments]    ${person}
    Input Text    css:input[ng-reflect-name="labelFirstName"]  ${person}[First Name]
    Set Value By Xpath    //input[@ng-reflect-name="labelFirstName"]  ${person}[First Name]
    Set Value By Xpath    //input[@ng-reflect-name="labelLastName"]  ${person}[Last Name]
    Set Value By Xpath    //input[@ng-reflect-name="labelCompanyName"]  ${person}[Company Name]
    Set Value By Xpath    //input[@ng-reflect-name="labelRole"]  ${person}[Role in Company]
    Set Value By Xpath    //input[@ng-reflect-name="labelAddress"]  ${person}[Address]
    Set Value By Xpath    //input[@ng-reflect-name="labelEmail"]  ${person}[Email]
    Set Value By Xpath    //input[@ng-reflect-name="labelPhone"]  ${person}[Phone Number]
    Click Button    Submit

*** Tasks ***
Start The Challenge
    Open Available Browser    http://rpachallenge.com/
    Download  http://rpachallenge.com/assets/downloadFiles/challenge.xlsx    overwrite=True
    Click Button    Start

*** Tasks ***
Fill The Forms
    ${people}=    Get The List Of People From The Excel File
    FOR  ${person}  IN  @{people}
      Fill And Submit The Form  ${person}
    END

*** Tasks ***
Collect The Results
    Capture Element Screenshot    css:div.congratulations
    [Teardown]  Close All Browsers
