#!/bin/bash

set -e  # exit on a non-zero return code from a command
set -x  # print a trace of commands as they execute

COMMITTISH=$(git log --pretty=format:"%H" -n 1)
BENCHMARK=1 swift build -c release && .build/release/chartrender-benchmark --iterations 500 --time-unit ms --format csv > benchmarks/${COMMITTISH}.csv
