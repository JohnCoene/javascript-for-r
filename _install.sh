#!/bin/sh

Rscript -e "setwd('./code/gio');devtools::install();"
Rscript -e "setwd('./code/jbox');devtools::install();"
Rscript -e "setwd('./code/ms');devtools::install();"
Rscript -e "setwd('./code/playground');devtools::install();"
Rscript -e "setwd('./code/typed');devtools::install();"
Rscript -e "setwd('./code/peity');devtools::install();"
Rscript -e "setwd('./code/playground');devtools::install();"
