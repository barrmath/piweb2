git push origin main
curl --user $USER:$TOKENJENKINS http://http://tuxpi:8080/job/piweb_deploy/buildWithParameters?token=$TOKENJENKINS
