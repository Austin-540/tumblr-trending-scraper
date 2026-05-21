library(rvest)
library(tidyverse)
library(jsonlite)

while (TRUE) {
  read_html("https://www.tumblr.com/robots.txt") %>%
    html_text2() %>%
    str_detect("explore|trending") %>%
    if (.) {
      stop("Hold up! The robots.txt file now mentions the trending page... check if this is still allowed")
    }
  
  trending_url <- "https://www.tumblr.com/explore/trending"
  
  page <- read_html(trending_url)
  
  script_with_trending <- page %>% html_element("script#___INITIAL_STATE___") %>%
    html_text2()
  
  tumblr_function_data <- fromJSON(script_with_trending)
  
  trending_data <- tumblr_function_data$Explore$trendingTagsTimeline$elements
  
  trending_tags <- trending_data$topicTitle
  
  output <- paste0(trending_tags, collapse="}")
  
  output_with_date <- paste0(now(), "^", output)
  
  write(output_with_date, file="output/trending_data.txt", append = TRUE)
  
  
  Sys.sleep(14400)
}

