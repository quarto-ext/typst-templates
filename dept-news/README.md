# Dept News Format

Based on the dept-news template published by the Typst team at <https://typst/typst-templates/dept-news>.

**NOTE**: This format requires the pre-release version of Quarto v1.4, which you can download here: <https://quarto.org/docs/download/prerelease>.

## Installing

```bash
quarto use template quarto-ext/typst-templates/dept-news
```

This will install the extension and create an example qmd file that you can use as a starting place for your document.

## Using

The example qmd demonstrates the document options supported by the dept-news format (`title`, `edition`, `hero-image`, `publication-info`, etc.). For example, your document options might look something like this:

```yaml
---
title: "Chemistry Department"
edition: |
   March 18th, 2023 \
   Purview College
hero-image: 
  path: "newsletter-cover.jpg"
  caption: "Award winning science"
publication-info: |
  The Dean of the Department of Chemistry. \
  Purview College, 17 Earlmeyer D, Exampleville, TN 59341. \
  <mailto:newsletter@chem.purview.edu>
format:
  dept-news-typst: default
---
```

Dept News documents are rendered as follows:

![](dept-news.png)





