FROM r-base:4.6.0
COPY . /tumblr_stuff
WORKDIR /tumblr_stuff
RUN R -e "install.packages(c('tidyverse', 'jsonlite', 'rvest'))"
CMD [ "Rscript", "grab_the_data.R" ]