library(dplyr)
library(tidyr)
library(scales)
library(ggplot2)

df <- tibble(warehouse_id = as.character(c(1:19)),
             errors = c(80, 121, 80, 96, 57, 94, 77, 26, 46, 25,
                        45, 48, 30, 11, 34, 39, 16, 22, 14),
             accuracy = c(691, 692, 668, 560, 487, 469, 408, 405, 368, 317,
                          322, 316, 310, 261, 246, 255, 200, 195, 182),
             nulls = c(32, 52, 48, 27, 23, 23, 26, 4, 4, 22, 11,
                          7, 34, 6, 6, 33, 9, 4, 4)
) %>%
  mutate(total = errors + accuracy + nulls,
         accuracy_pct = accuracy / total)

sum(df$accuracy) / sum(df$total)

bars_levels <- reorder(df$warehouse_id, df$accuracy_pct) %>% 
  rev() %>% 
  levels()

metrics_order <- toupper(c("errors", "nulls", "accuracy"))
metrics_colours <- c(app_colours$no_emphasis, 
                     app_colours$no_emphasis2,
                     app_colours$main)

df %>% 
  select(1:4) %>% 
  pivot_longer(!warehouse_id, names_to = "type", values_to = "value") %>% 
  mutate(type = toupper(type)) %>% 
  ggplot(aes(x = factor(warehouse_id, levels = bars_levels), 
             y = value, 
             fill = factor(type, 
                           levels = metrics_order))) +
  geom_bar(stat = "identity", position = "fill", colour = "white") +
  coord_flip() +
  scale_y_continuous(labels = label_percent(),
                     expand = expansion(mult = 0)) +
  scale_fill_manual(values = metrics_colours,
                    labels = paste0("<span style='color:",
                                    metrics_colours,
                                    "'>",
                                    metrics_order,
                                    "</span>",
                                    "<span> </span>",
                                    "<span> </span>",
                                    "<span style='color:",
                                    c("transparent", 
                                      app_colours$legend_title, 
                                      app_colours$legend_title),
                                    "'>",
                                    "|",
                                    "</span>")) +
  labs(x = "Warehouse",
       y = "Total Orders (%)",
       title = "Most Accurate Warehouses",
       subtitle = paste("All warehouses fulfilled at least 200 orders.",
                        "On average, the warehouses had an accuracy of",
                        "<strong><span style='color:",
                        app_colours$main,
                        ";'>85%</span></strong>"),
       caption = "Data from Q4 2021") +
  theme(plot.margin = margin(rep(15, 4)),
        axis.title.y = element_text(margin = margin(r = 7)),
        axis.title.x = element_text(margin = margin(t = 7)),
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        legend.position = "top",
        legend.text = element_markdown(face = "bold"),
        legend.justification = c(0, 0),
        legend.margin = margin(),
        legend.key.size = unit(1, units = "pt"),
        legend.spacing.x = unit(3, units = "pt")) +
  guides(fill = guide_legend(title = NULL,
                             reverse = TRUE,
                             label.position = "left",
                             override.aes = list(alpha = 0)))
