#!/bin/bash

set -e

echo "Running Static Application Security Testing (SAST),,,"

FAILED=0

echo -e "\n1. Running Checkstyle..."
if mvn checkstyle:check; then
    echo -e "Checkstyle passed"
else
    echo -e "Checkstyle failed"
    FAILED=1
fi

echo -e "\n2. Running PMD (Static Analysis)..."
if mvn pmd:check; then
    echo -e "PMD passed"
else
    echo -e "PMD failed"
    FAILED=1
fi

echo -e "\n3. Running SpotBugs (Bug Detection)..."
if mvn spotbugs:check; then
    echo -e "SpotBugs passed"
else
    echo -e "SpotBugs failed"
    FAILED=1
fi

echo -e "\n4. Generate detailed reports..."
mvn site || true

echo -e "\n======================================"
echo -e "SAST Analysis Complete"
echo -e "======================================"

if [ $FAILED -eq 1 ]; then
    echo -e "Some checks failed. Please review the output above."
    echo ""
    echo "View detailed reports at:"
    echo "  target/site/checkstyle.html"
    echo "  target/site/pmd.html"
    echo "  target/site/spotbugs.html"
    exit 1
else
  echo -e "All SAST checks passed!"
  exit 0
fi
