# Benchmarks

```swift
BENCHMARK=1 swift build -c release
.build/release/chartrender-benchmark --iterations 1000 --time-unit ms
```

## initial rendering, simple bar chart

```
running create chart... done! (11.37 ms)
running snapshot chart... done! (3825.61 ms)

name           time     std        iterations
---------------------------------------------
create chart   0.012 ms ±   7.23 %       1000
snapshot chart 3.755 ms ±  65.30 %       1000
```
