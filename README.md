---
gitea: none
include_toc: true
---

# ReachableCEO Enterprises Document Production Pipeline

## Introduction

Welcome to the ReachableCEO Enterprises document production pipeline! 

This is the code and (public)(non proprietary) metadata files that ReachableCEO Enterprises uses for
producing all of it's PDF files (for internal use, public consumption, clients). 


## Runtime requirements

You will need to place the eisvogel.latex file in your pandoc user data directory. 

Use:

pandoc --version 

to obtain the path.

```
❯ pandoc --version
pandoc.exe 3.2
Features: +server +lua
Scripting engine: Lua 5.4
*User data directory: C:\Users\tsys\AppData\Roaming\pandoc*
```

## Inspiration / supply chain

- https://github.com/jgm/pandoc/issues/2865
- https://github.com/Wandmalfarbe/pandoc-latex-template?tab=readme-ov-file
- https://pandoc.org/MANUAL.html
- https://jdhao.github.io/2019/05/30/markdown2pdf_pandoc/
- https://learnbyexample.github.io/customizing-pandoc/
- https://lornajane.net/posts/2023/generating-a-nice-looking-pdf-with-pandoc