library(tidyverse)
library(ggbump) #This package is no longer on CRAN, so it will need to be manually installed from a CRAN archived version

txt_data <- read.csv("output/trending_data.txt", header=FALSE)

txt_data <- txt_data %>%
  mutate(date_string = str_split_i(V1, "\\^", 1)) %>%
  mutate(lubri_date = ymd_hms(str_squish(date_string))) %>%
  mutate(num1 = str_split_i(str_split_i(V1, "\\^", 2), "\\}", 1),
         num2 = str_split_i(str_split_i(V1, "\\^", 2), "\\}", 2),
         num3 = str_split_i(str_split_i(V1, "\\^", 2), "\\}", 3),
         num4 = str_split_i(str_split_i(V1, "\\^", 2), "\\}", 4),
         num5 = str_split_i(str_split_i(V1, "\\^", 2), "\\}", 5),
         num6 = str_split_i(str_split_i(V1, "\\^", 2), "\\}", 6),
         num7 = str_split_i(str_split_i(V1, "\\^", 2), "\\}", 7),
         num8 = str_split_i(str_split_i(V1, "\\^", 2), "\\}", 8),
         num9 = str_split_i(str_split_i(V1, "\\^", 2), "\\}", 9),
         num10 = str_split_i(str_split_i(V1, "\\^", 2), "\\}", 10))

all_trended_tags <- c()
trending <- tibble(tag=c(),date=c(),position=c())

for (col_num in 4:13) {
  all_trended_tags <- c(all_trended_tags, pull(txt_data[col_num], 1))
  
  for (observ_num in 1:nrow(txt_data)) {
    trending <- bind_rows(trending, tibble(tag=c(txt_data[observ_num, col_num]), date=c(txt_data[observ_num, 3]), position = col_num-3 ) )
  }
}

all_trended_tags <- all_trended_tags %>%
  unique()

currently_trending <- c()
for (col_num in 4:13) {
  currently_trending <- c(currently_trending, (txt_data[nrow(txt_data), col_num]))
}

trending %>%
  filter(tag %in% currently_trending) %>% #Only get the currently trending tags because otherwise its wayyyyy too hard to read
  ggplot(aes(date, position, color=reorder(tag, +position), group=tag)) +
  geom_bump(linewidth=2.5, smooth = 15) +
  theme_minimal() +
  labs(y = "Rank",
       color = "Tag",
       x = NULL,
       title = "How did the current tumblr trending tags get to where they are now?",
       caption = "Source: Trending rankings scraped from the logged-out tumblr trending page"
  ) +
  scale_y_continuous(
    breaks = 1:10,
    minor_breaks = NULL,
    trans = "reverse"
  ) +
  theme(
    panel.background = element_rect(fill = "black"),
    plot.background = element_rect(fill = "black"),
    axis.text.x = element_text(color = "white"),
    axis.text.y = element_text(color = "white"),
    text = element_text(color = "white"),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_blank()
  )
