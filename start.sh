#!/bin/bash
screen -d -m -S "remindme-server" bundle exec rails server -b 0.0.0.0 -p 3002
