# Benchmarks

```swift
BENCHMARK=1 swift build -c release
.build/release/chartrender-benchmark --iterations 1000 --time-unit ms
```

## initial rendering, simple bar chart

```
name                        time      std        iterations
-----------------------------------------------------------
create small bar chart       0.012 ms ±  13.31 %       1000
create medium point chart    0.768 ms ±  13.00 %       1000
create large line chart      0.766 ms ±   1.38 %       1000
snapshot small bar chart     4.009 ms ±  50.79 %       1000
snapshot medium point chart 18.298 ms ±  11.74 %       1000
snapshot large line chart   37.245 ms ±   7.85 %       1000
```
