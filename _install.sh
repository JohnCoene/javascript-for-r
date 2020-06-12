#!/bin/sh

Rscript -e "setwd('./code/gio');devtools::install_local();"
Rscript -e "setwd('./code/jbox');devtools::install_local();"
Rscript -e "setwd('./code/ms');devtools::install_local();"
Rscript -e "setwd('./code/playground');devtools::install_local();"
Rscript -e "setwd('./code/typed');devtools::install_local();"
Rscript -e "setwd('./code/playground');devtools::install_local();"
