@echo off

:: app name and project path 
set "app_name=ticketing"
set "root=D:\Studies\ITU\S5\INF313_Framework\ticketing"

:: set paths
set "sourceFolder=%root%\src"
set "destinationFolder=%root%\bin"
set "lib=%root%\lib"
set "src=%root%"
set "lib_jar=D:\Studies\ITU\S5\INF313_Framework\ticketing\web\WEB-INF\lib"

:: copy all java file to a temporary folder
for /r "%sourceFolder%" %%f in (*.java) do (
    xcopy "%%f" "%root%\temp"
)

:: go to temp and compile all java files
cd "%root%\temp"
javac -d "%destinationFolder%" -cp "%lib_jar%\*" *.java

::copy compiled java file (.class) from bin to classes folder 
xcopy "%root%\bin"  "%root%\web\WEB-INF\classes" /E /I /H /YKO

:: create war file 
cd "%src%\web"
jar -cvf "../%app_name%.war" .
cd ..

:: copy war file to webapps
xcopy "%app_name%.war"  "D:\Programs\xampp\tomcat\webapps"
rmdir /s /q "%root%\temp"

pause