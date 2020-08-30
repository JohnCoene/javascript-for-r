#!/bin/sh

# clean
if [ $1 ]
then
  echo "\e[31mCleaning book\033[0m"
  Rscript -e "bookdown::clean_book()" 
fi

# render book
echo "\e[33mCreating HTML\033[0m"
Rscript -e "bookdown::render_book('.', 'bookdown::gitbook')"
echo "\e[33mCreating PDF\033[0m"
Rscript -e "bookdown::render_book('.', 'bookdown::pdf_book')"

if [ $2 ]
then
  xdg-open ./_book/index.html
fi
