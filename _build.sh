#!/bin/sh

Rscript -e "bookdown::render_book('.', 'bookdown::gitbook')"
Rscript -e "bookdown::render_book('.', 'bookdown::pdf_book')"
Rscript -e "bookdown::render_book('.', 'bookdown::epub_book')"