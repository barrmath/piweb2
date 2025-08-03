git push origin main
curl --user $USER:$TOKENJENKINS http://tuxpi:8080/job/piweb/buildWithParameters?token=$TOKENJENKINS
