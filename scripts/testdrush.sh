#!/bin/bash

docroot=$(pwd | cut -d'/' -f4)

if [ "$docroot" = "casdev" ]; then
    sitesdir=$(pwd | cut -d'/' -f6)

    if [ "$sitesdir" = "sites" ]; then
        site=$(pwd | cut -d'/' -f7)    
        if [ "$site" != "" ]; then
            drush -l $site $*
        fi
    else
        echo "You aren't in the sites dir, you can just use drush, not this alias"
    fi
else
    echo "You aren't in casdev docroot (/var/www/casdev/), you should use drush aliases or drush -l to specify a site in this docroot"
fi