#!/bin/bash

shopt -s nullglob

echo "Fixing links in documents"

for file in {branches,tags}/*/docs/*.md; do

    # Change .raml links to .html and rename APIs folder
    perl -pi -e 's:\.raml\):.html\):g; s:/APIs:/html-APIs:g;' "$file"

    # Change %20 escaped spaces in links to understores
    perl -ni -e '@parts = split /(\(.*?\.md\))/ ; for ($n = 1; $n < @parts; $n += 2) { $parts[$n] =~ s/%20/_/g; }; print @parts' "$file"

    # Same but for reference links
    perl -ni -e '@parts = split /(\]:.*?\.md)/ ; for ($n = 1; $n < @parts; $n += 2) { $parts[$n] =~ s/%20/_/g; }; print @parts' "$file"

    # Fix overview links
    perl -pi -e 's:github\.com/AMWA-TV/nmos/blob/master/NMOS_Technical_Overview.md:amwa-tv.github.io/nmos/branches/master/NMOS_Technical_Overview.html:gi;' "$file"

    # For other repos, link to documentation
    perl -pi -e 's:github\.com/AMWA-TV/:amwa-tv.github.io/:gi;' "$file"

    # Additional fix for device control types parameter register link
    perl -pi -e 's:tree/master/device-control-types:device-control-types:gi;' "$file"
done

# Removing the unwanted "schemas/" in .html links due to raml2html v6 workaround
for file in {branches,tags}/*/html-APIs/*.html; do
    perl -pi -e 's:schemas/::g;' "$file"
done
    
