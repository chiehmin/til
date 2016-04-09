# Latex

## Installation
```shell
$ sudo dnf install texlive
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

#### Figure Example
```latex
\documentclass{article}

\usepackage{graphicx}

\begin{document}

\begin{figure}
  \includegraphics[width=\linewidth]{boat.jpg}
  \caption{A boat.}
  \label{fig:boat1}
\end{figure}

Figure \ref{fig:boat1} shows a boat.

\end{document}
```

#### Reference Example
```latex
\section{}\label{sec:YOURLABEL}
...
I've written text in section \ref{sec:YOURLABEL}.
```

#### Bibliography
```bibtex
@ARTICLE=
{
VELLAGE:1,
AUTHOR="Claudio Vellage",
TITLE="A quick start to \LaTeX{}",
YEAR="2013",
PUBLISHER="",
}
```
```latex
\usepackage[backend=bibtex,style=verbose-trad2]{biblatex} % Use biblatex package
\bibliography{FILENAME} % The name of the .bib file (name without .bib)

...
This feature works as I described in \cite{VELLAGE:1}.
...

\printbibliography
```
