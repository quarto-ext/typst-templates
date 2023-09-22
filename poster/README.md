# Typst Poster Format

An academic poster template designed for Typst. Supports both horizontal and vertical posters. Originally created for Typst by Parth Parikh (https://github.com/pncnmnp/typst-poster) and adapted for Quarto.

## Installing

```bash
quarto use template quarto-ext/typst-templates/poster
```

This will install the format extension and create an example qmd file
that you can use as a starting place for your poster.

## Using

Specify poster size, authors/affiliation, and footer content using the YAML options of the `poster-typst` format:

```yaml
---
title: This is an academic poster with typst and quarto!
format:
  poster-typst: 
    size: "36x24"
    poster-authors: "A. Smith, B. Jones, C. Brown, D. Miller"
    departments: "Department of Computer Science"
    institution-logo: "./images/ncstate.png"
    footer-text: "posit::conf 2023"
    footer-url: "https://posit.co/conference/"
    footer-emails: "abc@example.com"
    footer-color: "ebcfb2"
    keywords: ["Typesetting", "Typst", "Quarto"]
---
```

This is what a poster with the options specified above might look like:

![](images/poster.png)
