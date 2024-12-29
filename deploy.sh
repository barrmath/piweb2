git push origin main
curl --user $USER:$TOKENJENKINS http://0.0.0.0:8090/job/piweb_deploy/buildWithParameters?token=$TOKENJENKINS