# zig.thi.ng

Various, still unstructured experiments / open-learning with [Zig](https://ziglang.org).

## About

Current dev highlights include:

- [SIMD-based generic vector type](./src/vec-simd.zig) & operations (incl. type specific additions)
- [Generic nD-Array](./src/nd.zig) base implementation


## Build for WASM

The below command builds `exports.zig` for SIMD-enabled WASM target, then
optimizes & disassembles it using Binaryen.

```text
zig build-lib -O ReleaseFast -target wasm32-freestanding -mcpu=generic+simd128 -dynamic --strip src/exports.zig && wasm-opt exports.wasm -o exports.wasm -O3 --enable-simd && wasm-dis -o exports.wast exports.wasm
```

## License

&copy; 2021 - 2022 Karsten Schmidt // Apache Software License 2.0