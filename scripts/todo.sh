#!/usr/bin/env sh


html=$1


dir=`dirname $html`
note=`cat $html | shasum`
touch $dir/$note
note=`ls -tr $dir | grep -v html | tail -n 1`

cat $html > $dir/$note
title=`cat $html | pup 'title text{}'`
echo "[9]>$note $title"

