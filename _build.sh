#!/bin/sh

echo "Cleaning book"
Rscript -e "bookdown::clean_book()"
echo "Creating HTML"
Rscript -e "bookdown::render_book('.', 'bookdown::gitbook')"
echo "Creating PDF"
Rscript -e "bookdown::render_book('.', 'bookdown::pdf_book')"
echo "Creating epub"
Rscript -e "bookdown::render_book('.', 'bookdown::epub_book')"