git push origin main
curl --user $USER:$JENKINSUSERTOKEN http://tuxpi:8080/job/piweb/buildWithParameters?token=$TOKENJENKINS
