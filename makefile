html:
				Rscript -e 'bookdown::render_book(".", output_format = "bookdown::gitbook")'

pdf:
				Rscript -e 'bookdown::render_book(".", output_format = "bookdown::pdf_book")'

install:
				Rscript -e "setwd('./code/gio');devtools::install();"
				Rscript -e "setwd('./code/ms');devtools::install();"
				Rscript -e "setwd('./code/playground');devtools::install();"
				Rscript -e "setwd('./code/typed');devtools::install();"
				Rscript -e "setwd('./code/peity');devtools::install();"
				Rscript -e "setwd('./code/playground');devtools::install();"
				Rscript -e "setwd('./code/ml');devtools::install();"
