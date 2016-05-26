# Latex

## Installation
```shell
$ sudo dnf install texlive texlive-biblatex
$ sudo dnf install latexmk # used by atom latex plugins
```
#### Xelatex
```shell
$ sudo dnf install install latex-xetex
$ sudo dnf install texlive-collection-latex \
texlive-collection-latexrecommended \
texlive-xetex-def \
texlive-collection-xetex \
texlive-collection-latexextra
```

### Atom editor plugins Installation
```shell
$ apm install latex
$ apm install language-latex  # syntax highlighting
$ apm install pdf-view  # view pdf in atom
```

### Building in commandline
```shell
$ pdflatex filename.tex
```
## usage

A document consists of two parts, the **preamble** and the **main document**. You might want to compare the structure with that of a C/C++ file.

#### Preamble

The purpose of the preamble is to tell LaTeX what kind of document you will set up and what packages you are going to need.

#### Main document

The main document is contained within the document environment.

#### Useful commands
```latex
\section{Text goes here} % On top of document hierarchy; automatically numbered
\subsection{}
\subsubsection{}
\paragraph{} % Paragraphs have no numbering
\subparagraph{}

\author{Claudio Vellage} % The authors name
\title{A quick start to \LaTeX{}} % The title of the document
\date{\today{}} % Sets date you can remove \today{} and type a date manually
\maketitle{} % Generates title
\tableofcontents{} % Generates table of contents from sections and subsections

\\ % Linebreak
\newpage{} % Pagebreak
```

## Misc

Indenting for the first paragraph of \chapter and \sections
```
\usepackage{indentfirst}
```
Removing blank page after \part or \chapter
```
\documentclass[oneside]{book}
```
