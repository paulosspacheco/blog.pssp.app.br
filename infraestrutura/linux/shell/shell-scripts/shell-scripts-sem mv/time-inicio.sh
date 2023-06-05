#!/bin/bash
# Esse script é executado pelo programa cron.
# Para que o cron execute algo é necessário registrar as tarefas pelo programa: $ crontab -e.

date | xargs echo "Date of boot: " >>~/reboot.txt
