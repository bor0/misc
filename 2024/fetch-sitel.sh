#!/bin/bash
URL=$(curl -s "https://tvstanici.net/sitel-vo-zivo/" | grep teve.mk | awk -F'"' '{print $2}')
M3U8_REL_URL=$(curl -s $URL | tail -n 1)
BASE_URL=$(echo $URL | sed 's/playlist.m3u8.*//')

M3U8_URL=${BASE_URL}${M3U8_REL_URL}

set -x
php capture-m3u8.php "${BASE_URL}${M3U8_REL_URL}"
