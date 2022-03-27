#!/bin/bash

##https://github.com/anudeepND/whitelist

python3 /home/pihole/whitelist/scripts/whitelist.py && echo -e "Subject:Pihole's whitelist updated\n\nHello,\n\nThe Pihole's whitelist has been succesfully updated." | /usr/sbin/sendmail yourmailexample@mail.com, yourmailexample2@mail.com || echo -e "Subject:Error during Pihole's whitelist update\n\nHello,\n\nThere was an error during the Pihole's whitelist update." | /usr/sbin/sendmail yourmailexample@mail.com, yourmailexample2@mail.com 
