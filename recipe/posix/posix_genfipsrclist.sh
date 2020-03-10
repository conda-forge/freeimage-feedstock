#!/bin/sh

DIRLIST="Wrapper/FreeImagePlus"


echo "VER_MAJOR = 3" > fipMakefile.srcs
echo "VER_MINOR = 18.0" >> fipMakefile.srcs

printf "SRCS = " >> fipMakefile.srcs
for DIR in $DIRLIST; do
	VCPRJS=`echo $DIR/*.2013.vcxproj`
	if [ "$VCPRJS" != "$DIR/*.2013.vcxproj" ]; then
		egrep 'ClCompile Include=.*\.(c|cpp)' $DIR/*.2013.vcxproj | cut -d'"' -f2 | tr '\\' '/' | awk '{print "'$DIR'/"$0}' | tr '\r\n' '  ' | tr -s ' ' >> fipMakefile.srcs
	fi
done
echo >> fipMakefile.srcs

printf "INCLUDE =" >> fipMakefile.srcs
for DIR in $DIRLIST; do
	printf " -I$DIR" >> fipMakefile.srcs
done
printf " -IDist" >> fipMakefile.srcs
echo >> fipMakefile.srcs

