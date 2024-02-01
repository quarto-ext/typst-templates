# Typst Fiction Format

Based on the fiction template published by the Typst team at <https://github.com/typst/templates/tree/main/fiction>.

**NOTE**: This format requires the pre-release version of Quarto v1.4, which you can download here: <https://quarto.org/docs/download/prerelease>.

## Installing

```bash
quarto use template quarto-ext/typst-templates/fiction
```

This will install the extension and create an example qmd file that you can use as a starting place for your document.

## Using

The example qmd demonstrates the document options supported by the fiction format (`title`, `author`, `dedication`, `publishing-info`, etc.). For example, your document options might look something like this:

```yaml
---
title: "Liam's Playlist"
author: Janet Doe
dedication: |
  for Rachel
publishing-info: |
  UK Publishing, Inc. \
  6 Abbey Road \
  Vaughnham, 1PX 8A3

  <https://example.co.uk/>

  971-1-XXXXXX-XX-X
format:
  fiction-typst: default
---
```
