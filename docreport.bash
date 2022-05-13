#!/bin/bash

set -e  # exit on a non-zero return code from a command
set -x  # print a trace of commands as they execute

rm -rf .build
mkdir -p .build/symbol-graphs

$(xcrun --find swift) build --target Chart \
    -Xswiftc -emit-symbol-graph \
    -Xswiftc -emit-symbol-graph-dir -Xswiftc .build/symbol-graphs

rm -f .build/symbol-graphs/Numerics*
rm -f .build/symbol-graphs/RealModule*
rm -f .build/symbol-graphs/ComplexModule*
rm -f .build/symbol-graphs/SwiftVizScale*

$(xcrun --find docc) convert Sources/Chart/Documentation.docc \
    --analyze \
    --fallback-display-name Chart \
    --fallback-bundle-identifier com.github.swiftviz.Chart \
    --fallback-bundle-version 0.1.9 \
    --additional-symbol-graph-dir .build/symbol-graphs \
    --experimental-documentation-coverage \
    --level brief
