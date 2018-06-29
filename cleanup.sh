#!/bin/sh
while true
do
  sleep 3600
  cd /root/.ethash && (ls -t|head -n 2;ls)|sort|uniq -u|xargs rm
  cd /var/log/supervisor && (ls -t|head -n 8;ls)|sort|uniq -u|xargs rm
done