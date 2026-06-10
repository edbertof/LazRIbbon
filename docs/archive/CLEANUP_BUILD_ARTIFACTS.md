# Cleaning generated files

This distribution was cleaned before packaging. If you reuse a working directory, remove generated files before making a source ZIP or commit:

```bash
find . -type f \( -iname '*.exe' -o -iname '*.ppu' -o -iname '*.o' -o -iname '*.obj' -o -iname '*.compiled' -o -iname '*.rsj' -o -iname '*.res' -o -iname '*.lps' \) -delete
rm -rf lib/* demos/*/bin demos/*/lib
```

On Windows, perform the equivalent cleanup manually or with PowerShell before distributing the package.
