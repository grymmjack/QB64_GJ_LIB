# QB64_GJ_LIB/native — C++ hot kernels (-O3)

A QB64-PE program compiles to a single C++ translation unit at **-O0**, so pixel-hot
inner loops never vectorize and pay a function call per `_MEMGET`/`_MEMPUT`. This dir
holds small **header-only** C++ kernels that IMGADJ pulls out of that -O0 TU and compiles
at **-O3** via `DECLARE LIBRARY`, over the raw `_MEMIMAGE` buffers.

## Usage pattern

```qb64
DECLARE LIBRARY "../native/blur_kernel"   ' path is relative to the .BM that DECLAREs it
    SUB gj_box_blur (BYVAL dst AS _OFFSET, BYVAL src AS _OFFSET, BYVAL w AS LONG, BYVAL h AS LONG, BYVAL radius AS LONG)
END DECLARE
' ... gj_box_blur m.OFFSET, tempMem.OFFSET, w, h, radius
```

Gotchas (both real):
- **Path resolves relative to the file containing the `DECLARE`**, not the main .BAS or
  the build CWD. IMGADJ.BM lives in `IMGADJ/`, so the path is `../native/blur_kernel`.
- **`_OFFSET` arrives as `intptr_t`** (QB64 `ptrszint`); C++ won't implicitly cast it to
  `uint32_t*`, so the kernel takes `intptr_t` and casts inside.
- QB64 32-bit pixels are ARGB: `_RED32=(p>>16)&0xFF`, `_GREEN32=(p>>8)&0xFF`,
  `_BLUE32=p&0xFF`, `_RGB32(r,g,b)=0xFF000000|(r<<16)|(g<<8)|b`.

## Cross-platform

`#pragma GCC optimize("O3")` → full win on g++ (Linux / Windows-MinGW). clang (macOS)
ignores it, so the kernel runs at the program's -O0 there — still correct, still faster
than the BASIC path (no per-pixel `_MEMGET` call overhead), just not vectorized.

## Kernels

| File | Entry | Replaces |
|---|---|---|
| `blur_kernel.h` | `gj_box_blur` | `GJ_IMGADJ_Blur` naive box blur (~18× at radius 6, bit-exact) |
