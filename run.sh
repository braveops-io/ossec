#!bin/bash


echo '{"Ossec":"Starting"}'
/var/ossec/bin/ossec-control start
filebeat run