#!/usr/bin/env bash
#
# Copyright (c) 2018 The Bitcoin Core developers
# Distributed under the MIT software license, see the accompanying
# file COPYING or http://www.opensource.org/licenses/mit-license.php.

export LC_ALL=C.UTF-8

if [ "$RUN_UNIT_TESTS" = "true" ]; then

  cd build || (echo "could not enter build directory"; exit 1)
  cd "verge-$HOST" || (echo "could not enter distdir verge-$HOST"; exit 1)

  BEGIN_FOLD unit-tests
  DOCKER_EXEC LD_LIBRARY_PATH=$TRAVIS_BUILD_DIR/depends/$HOST/lib make $MAKEJOBS check VERBOSE=1
  END_FOLD

  cd ${TRAVIS_BUILD_DIR}
fi

if [ "$RUN_COV_REPORT" = "true" ]; then

  cd build || (echo "could not enter build directory"; exit 1)
  cd "verge-$HOST" || (echo "could not enter distdir verge-$HOST"; exit 1)

  BEGIN_FOLD coverage-report-generation
  DOCKER_EXEC LD_LIBRARY_PATH=$TRAVIS_BUILD_DIR/depends/$HOST/lib make $MAKEJOBS test_verge_filtered.info VERBOSE=1
  END_FOLD

  bash <(curl -s https://codecov.io/bash) -f test_verge_filtered.info || (echo "Could not upload coverage report to codecov"; exit 1)
  cd ${TRAVIS_BUILD_DIR}
fi

# if [ "$RUN_FUNCTIONAL_TESTS" = "true" ]; then
#   BEGIN_FOLD functional-tests
#   DOCKER_EXEC test/functional/test_runner.py --ci --combinedlogslen=4000 --coverage --quiet --failfast
#   END_FOLD
# fi

# if [ "$RUN_FUZZ_TESTS" = "true" ]; then
#   BEGIN_FOLD fuzz-tests
#   DOCKER_EXEC test/fuzz/test_runner.py -l DEBUG ${DIR_FUZZ_IN}
#   END_FOLD
# fi