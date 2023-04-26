#!/bin/bash

SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )";)

fail_count=0

echo "Testing with bash/git versions:"
bash --version
git --version

for testfile in "$SCRIPT_DIR"/test-*.sh
do
  echo ""
  echo "#########  $(basename $testfile) ################"
  $testfile || ((fail_count++))
done

exit $fail_count
