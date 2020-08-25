Configured local wildcard dns (i.e., *.address.thing) by creating /etc/dnsmasq.d/02-nameservers.conf with this:
address=/{base domain}/{local ip}

Then restart dnsmasq with pihole restartdns
