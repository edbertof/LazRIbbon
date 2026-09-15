# LazRibbon Security Policy

LazRibbon is a local Lazarus/LCL component package. It does not provide network
services, authentication or server-side processing by itself, but security
issues can still matter when a consuming application loads external files such
as skin XML.

## Reporting A Vulnerability

If GitHub private vulnerability reporting is enabled for the repository, use it.
If it is not available, open an issue with a short non-sensitive summary and ask
for a private reporting channel before sharing exploit details or private data.

## What To Include

- Affected LazRibbon version or Git commit.
- Lazarus and Free Pascal versions.
- Operating system and widgetset.
- The affected component, tool, parser or file format.
- Minimal reproduction steps.
- Whether the issue requires opening an untrusted `.skin` file, project file or
  other external input.

## Supported Versions

The active development and validation target is the current 2.1 line on Lazarus
4.8. Older releases may receive fixes only when the issue is severe and the fix
can be applied without destabilizing the current package structure.
