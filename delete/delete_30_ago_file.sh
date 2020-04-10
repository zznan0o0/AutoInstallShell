#!/bin/bash
location=/home/user/deleted
find $location -mtime +30 -print | xargs rm -rf 