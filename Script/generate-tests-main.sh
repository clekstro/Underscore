#!/bin/bash

PKG_DIR=..
TESTS_DIR="${PKG_DIR}/Tests"
OUTPUT_FILE=${TESTS_DIR}/main.swift

if ! [ -d "${TESTS_DIR}" ]; then
    echo "The directory containing the tests must be named Tests"
    exit 1
fi

cat << 'EOF' > ${OUTPUT_FILE}
// This file is generated by `generate-tests-main.sh`

import XCTest
EOF

find ${TESTS_DIR} -maxdepth 1 -mindepth 1 -type d -printf '@testable import %ftest\n' >> ${OUTPUT_FILE}

echo >> ${OUTPUT_FILE}
echo XCTMain\(\[ >> ${OUTPUT_FILE}
for FILE in `find ${TESTS_DIR}/* -name "*Tests.swift"`; do
    FILE_NAME=`basename ${FILE}`
    FILE_NAME="${FILE_NAME%.*}"
    echo "  testCase(${FILE_NAME}.allTests)," >> ${OUTPUT_FILE}
done
echo "])" >> ${OUTPUT_FILE}
