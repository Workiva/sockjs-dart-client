#!/bin/bash

# Fast fail the script on failures.
set -e

# Check arguments.
TASK=$1

if [ -z "$TASK" ]; then
  echo -e '\033[31mTASK argument must be set!\033[0m'
  echo -e '\033[31mExample: tool/travis.sh test:unit\033[0m'
  exit 1
fi

DART_VERSION=$(dart --version 2>&1)
DART_2_PREFIX="Dart VM version: 2"

# Run the correct task type.
case $TASK in
  test)
    echo -e '\033[1mTASK: Testing [test]\033[22m'

    node tool/server.js &
    SOCKJS_SERVER=$!

    sleep 2

    if [[ $DART_VERSION = $DART_2_PREFIX* ]]; then
      echo -e 'dart run build_runner test -- -P all -P travis'
      dart run build_runner test -- -P all -P travis
    else
      echo -e 'dart test -P all -P travis'
      dart test -P all -P travis
    fi

    kill $SOCKJS_SERVER
    sleep 2

    ;;

  *)
    echo -e "\033[31mNot expecting TASK '${TASK}'. Error!\033[0m"
    exit 1
    ;;
esac
