# thi.ng.random

## About

Additional `std.rand.Random`-compatible PRNGs and related utilities.

-   [Sfc32](./src/sfc32.zig) - 32bit version of [`std.rand.Sfc64`](https://github.com/ziglang/zig/blob/master/lib/std/rand/Sfc64.zig)

## Example usage

```zig
const rnd = @import("thi.ng").random;
const Sfc32 = @import("thi.ng").random.Sfc32;
```
