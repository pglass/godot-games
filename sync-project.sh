#!/bin/bash -e

PROJECT=${1?"Project is required"}
DIST_DIR="$PROJECT/dist"
SERVER=games.pglbutt.com
REMOTE_DIR=/var/www/html/

rsync -v -r $DIST_DIR/* "$SERVER:$REMOTE_DIR"
