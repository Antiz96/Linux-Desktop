#!/bin/bash

pihole -g && echo -e "Subject:Pihole's blacklist updated\n\nHello,\n\nPihole's blacklist has been succesfully updated." | /usr/sbin/sendmail yourmailexample@mail.com, yourmailexample2@mail.com || echo -e "Subject:Error during Pihole's blacklist update\n\nHello,\n\nThere was an error during Pihole's blacklist update." | /usr/sbin/sendmail yourmailexample@mail.com, yourmailexample2@mail.com
