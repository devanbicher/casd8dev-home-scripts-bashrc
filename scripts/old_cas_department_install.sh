old_cas_department_install () {
    #you moved this to a script.  you should change this function to just call that script.

    #save the current path so I can return to it
    curpath=$(pwd)

    #get the log 
    cd /var/www/casdev/web/profiles/cas_department/
    deptlog=$(git log -n1 --pretty='Department Install Profile Commit: %cn on %cD  Message: %s')\

    #make a commit of the config, in case there is somethig there you want.
    cd /var/www/casdev/web/files/"$1"/config
    git add ./*.yml
    git commit -am "commit before exporting config again, before restoring to default profile."
    #dump the config to make sure everthing from the site is exported and 'saved'
    drush @casdev."$1" -y config:export 
    git add ./*.yml
    git commit -am "Most recent config for the site, BEFORE the site overwrite/install"
    ### NOW install/overwrite the site.
    drush @casdev."$1" site-install cas_department --account-name="$1"_cas_admin --account-mail=incasweb@lehigh.edu --site-mail=incasweb@lehigh.edu --account-pass=$(pwgen 16) --site-name="CASDEV $1 Site (casd8devserver)"
    #export the config for the newly installed site.
    drush @casdev."$1" -y config:export
    git add ./*.yml
    git commit -am "AFTER Resetting to cas_department install profile:  $deptlog"

    cd $curpath
}