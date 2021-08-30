# ## Beginners' course - starter files
#
# This example is the starting point of our <a href="https://robocorp.com/docs/courses/beginners-course">beginners' course</a>.
#
# Take the course to learn how to turn this into a complete and useful robot!
#

*** Settings ***
Documentation     Starter robot for the Beginners' course.
Library           RPA.Browser.Selenium
Library           RPA.HTTP
Library           RPA.Excel.Files

*** Keywords ***
Open The Intranet Website
    Open Available Browser    https://robotsparebinindustries.com/

*** Keywords ***
Log In
    Input Text  username    maria
    Input Password    password  thoushallnotpass
    Submit Form
    Wait Until Page Contains Element    id:sales-form

*** Keywords ***
Fill And Submit The Form For One Person
    [Arguments]    ${sales_rep}
    Input Text  firstname    ${sales_rep}[First Name]
    Input Text  lastname    ${sales_rep}[Last Name]
    Input Text  salesresult    ${sales_rep}[Sales]
    ${target_as_string}=    Convert To String    ${sales_rep}[Sales Target]
    Select From List By Value    salestarget  ${target_as_string}
    Click Button    Submit

*** Keywords ***
Download The Excel File
    Download    https://robotsparebinindustries.com/SalesData.xlsx  overwrite=True

*** Keywords ***
Fill The Form Using The Data From The Excel File
        Open Workbook   SalesData.xlsx
        ${sales_reps}=  Read Worksheet As Table     header=True
        Close Workbook
        FOR    ${sales_rep}    IN    @{sales_reps}
            Fill And Submit The Form For One Person    ${sales_rep}
        END

*** Tasks ***
Insert the sales data for the week and export it as a PDF
    Open The Intranet Website
    Log In
    Download The Excel File
    Fill The Form Using The Data From The Excel File
