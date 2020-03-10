#!/bin/sh

DIRLIST=". Source Source/Metadata Source/FreeImageToolkit"

echo "VER_MAJOR = 3" > Makefile.srcs
echo "VER_MINOR = 18.0" >> Makefile.srcs

printf "SRCS = " >> Makefile.srcs
for DIR in $DIRLIST; do
	VCPRJS=`echo $DIR/*.2013.vcxproj`
	if [ "$VCPRJS" != "$DIR/*.2013.vcxproj" ]; then
		egrep 'ClCompile Include=.*\.(c|cpp)' $DIR/*.2013.vcxproj | cut -d'"' -f2 | tr '\\' '/' | awk '{print "'$DIR'/"$0}' | tr '\r\n' '  ' | tr -s ' ' >> Makefile.srcs
	fi
done
echo >> Makefile.srcs

printf "INCLS = " >> Makefile.srcs
find . -name "*.h" -print | xargs echo >> Makefile.srcs
echo >> Makefile.srcs

printf "INCLUDE =" >> Makefile.srcs
for DIR in $DIRLIST; do
	printf " -I$DIR" >> Makefile.srcs
done
echo >> Makefile.srcs
