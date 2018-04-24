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

# Run the correct task type.
case $TASK in
  test)
    echo -e '\033[1mTASK: Testing [test]\033[22m'

    echo -e 'pub build test --web-compiler=dartdevc'
    # Precompile tests to avoid timeouts/hung builds.
    pub build test --web-compiler=dartdevc
    # The --precompile option requires that it be given a merged output dir with
    # both compiled JS files and the source .dart files.
    # NOTE: Once we're on Dart 2 for good, we can switch to build_runner which
    # does all of this for us.
    cp -R test/** build/test/

    node tool/server.js &
    SOCKJS_SERVER=$!

    sleep 2

    echo -e 'pub run test -j 1 -p chrome --precompiled=build/'
    pub run test -j 1 -p chrome --precompiled=build/

    kill $SOCKJS_SERVER
    sleep 2

    ;;

  *)
    echo -e "\033[31mNot expecting TASK '${TASK}'. Error!\033[0m"
    exit 1
    ;;
esac
