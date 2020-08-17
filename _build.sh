#!/bin/sh

# clean
# echo "\e[31mCleaning book\033[0m"
Rscript -e "bookdown::clean_book()"

# render book
echo "\e[33mCreating HTML\033[0m"
Rscript -e "bookdown::render_book('.', 'bookdown::gitbook')"
echo "\e[33mCreating PDF\033[0m"
Rscript -e "bookdown::render_book('.', 'bookdown::pdf_book')"
xdg-open ./_book/index.html --no-sandbox
