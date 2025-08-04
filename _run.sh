#!/bin/bash

# app name and project path 
app_name="ticketing"
root="$HOME/Documents/Studies/ITU/S5/INF313_Framework/ticketing"

# set paths
sourceFolder="$root/src"
destinationFolder="$root/bin"
lib="$root/lib"
src="$root"
lib_jar="$root/web/WEB-INF/lib"

# create temp directory if it doesn't exist
mkdir -p "$root/temp"

# copy all java files to temporary folder
find "$sourceFolder" -name "*.java" -exec cp {} "$root/temp/" \;

# check if any java files were found
if [ ! "$(ls -A $root/temp/*.java 2>/dev/null)" ]; then
    echo "No Java files found in $sourceFolder"
    echo "Please check if the src directory exists and contains .java files"
    rm -rf "$root/temp"
    exit 1
fi

# create bin directory if it doesn't exist
mkdir -p "$destinationFolder"

# go to temp and compile all java files
cd "$root/temp"
javac -d "$destinationFolder" -cp "$lib_jar/*" *.java

# check if compilation was successful
if [ $? -ne 0 ]; then
    echo "Compilation failed!"
    rm -rf "$root/temp"
    exit 1
fi

# create classes directory if it doesn't exist
mkdir -p "$root/web/WEB-INF/classes"

# copy compiled java files (.class) from bin to classes folder 
cp -r "$root/bin/." "$root/web/WEB-INF/classes/" 2>/dev/null || echo "Warning: No compiled classes found to copy"

# create war file 
cd "$src/web"
jar -cvf "../$app_name.war" .
cd ..

# deploy
cp "$app_name.war" "/opt/tomcat10.1/webapps"

# cleanup temp directory
rm -rf "$root/temp"

echo "Build completed successfully!"
echo "Press any key to continue..."
read -n 1