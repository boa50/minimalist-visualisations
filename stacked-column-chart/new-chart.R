library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)

df <- tibble(wharehouse_id = as.character(c(1:19)),
             errors = c(80, 121, 80, 96, 57, 94, 77, 26, 46, 25,
                        45, 48, 30, 11, 34, 39, 16, 22, 14),
             accuracy = c(691, 692, 668, 560, 487, 469, 408, 405, 368, 317,
                          322, 316, 310, 261, 246, 255, 200, 195, 182),
             nulls = c(32, 52, 48, 27, 23, 23, 26, 4, 4, 22, 11,
                          7, 34, 6, 6, 33, 9, 4, 4)
) %>%
  mutate(total = errors + accuracy + nulls,
         accuracy_pct = accuracy / total)

bars_levels <- reorder(df$wharehouse_id, df$accuracy_pct) %>% 
  rev() %>% 
  levels()

df %>% 
  select(1:4) %>% 
  pivot_longer(!wharehouse_id, names_to = "type", values_to = "value") %>% 
  ggplot(aes(x = factor(wharehouse_id, levels = bars_levels), 
             y = value, 
             fill = factor(type, levels = c("errors", "nulls", "accuracy")))) +
  geom_bar(stat = "identity", position = "fill") +
  coord_flip() +
  scale_y_continuous(labels = label_percent()) 
