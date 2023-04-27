# Typst Letter Format

Based on letter format published by the Typst team at <https://typst/typst-templates/letter>.

**NOTE**: This format requires the pre-release version of Quarto v1.4, which you can download here: <https://quarto.org/docs/download/prerelease>.

## Installing

```bash
quarto use template quarto-ext/typst-templates/letter
```

This will install the extension and create an example qmd file that you can use as a starting place for your document.

## Using

Specify the sender, receipient, subject, etc. using YAML options, then write the body of the letter. For example, the following qmd source:

```yaml
---
subject: "Revision of our Procurement Contract"
name: "Jane Smith \ Regional Director"
sender: "Jane Smith, Universal Exports, 1 Heavy Plaza, Morristown, NJ 07964"
recipient: |
  Mr. John Doe \
  Acme Corp. \
  123 Glennwood Ave \
  Quarto Creek, VA 22438 \
sent: "Morristown, June 9th, 2023"
format:
  letter-typst: default
---

Dear Joe,

...
```

This document would be rendered as:

![](letter.png)
