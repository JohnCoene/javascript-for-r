html:
				Rscript -e 'bookdown::render_book(".", output_format = "bookdown::gitbook")'

pdf:
				Rscript -e 'bookdown::render_book(".", output_format = "bookdown::pdf_book")'
