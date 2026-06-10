# LazRibbon license/header notes

This document records the source-header normalization performed in LazRibbon 0.3.55.

## Policy used

- Existing LazToolbar/LazRibbon notices were preserved.
- Pascal units without a visible header received a standard LazRibbon notice pointing to `LICENSE.txt`.
- The standard header intentionally does not claim new ownership over original upstream code.
- Demo units also received a minimal project header so the distribution is consistent.

## What this does not solve

This pass does not audit every third-party image, icon, binary resource, or skin file. Those assets need separate review before public redistribution.

## Recommended future step

Before a public release, review each file with uncertain provenance and decide whether it should be kept, replaced, or removed.
