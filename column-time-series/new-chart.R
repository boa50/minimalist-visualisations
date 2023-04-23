library(dplyr)
library(tidyr)
library(scales)
library(ggplot2)

df <- tibble(
  dates = seq(as.Date("01-01-2019", format = "%d-%m-%Y"),
              length.out = 12,
              by = "month"),
  direct_sales = c(88, 76, 48, 76, 71, 59, 80, 69, 54, 81, 74, 46),
  indirect_sales = c(82, 71, 89, 81, 88, 120, 84, 74, 98, 85, 94, 65)
)

goal <- 90
last_month <- as.Date("01-12-2019", format = "%d-%m-%Y")
first_month <- as.Date("01-01-2019", format = "%d-%m-%Y")
plot_colours <- c(app_colours$main, app_colours$line_complementary2)

annotate_line <- function(label, y, colour) {
  annotate("text", label = {{label}}, hjust = -0.1,
           size = 3, colour = {{colour}}, fontface = "bold",
           x = last_month, y = {{y}})
}

df %>% 
  pivot_longer(!dates, names_to = "type", values_to = "value") %>% 
  ggplot(aes(x = dates, y = value)) +
  geom_line(aes(colour = type)) +
  geom_segment(x = first_month - 17, xend = Inf, 
               y = goal, yend = goal,
               linetype = "longdash", 
               colour = app_colours$axis, 
               size = .37) +
  annotate("text", label = "GOAL", hjust = 0.5, vjust = -0.5,
           size = 4, colour = app_colours$axis,
           x = last_month, y = goal) +
  annotate_line("DIRECT SALES", 
                last(df$direct_sales), 
                plot_colours[1]) +
  annotate_line("INDIRECT SALES", 
                last(df$indirect_sales), 
                plot_colours[2]) +
  labs(x = NULL,
       y = "Time to Close Deal (days)",
       title = "Times to Close Deals in 2019",
       subtitle = paste0("In almost every month of 2019, the company achieved",
                         " the goal of closing deals before 90 days")) +
  scale_y_continuous(limits = c(0, 150),
                     breaks = seq(from = 0, to = 150, by = 30),
                     expand = expansion(mult = 0)) +
  scale_x_date(date_breaks = "month", date_labels = "%b") +
  scale_colour_manual(values = plot_colours) +
  theme(plot.margin = margin(c(15, 65, 15, 15)),
        axis.title.y = element_text(margin = margin(r = 7)),
        axis.title.x = element_text(margin = margin(t = 7)),
        legend.position = "none") +
  coord_cartesian(clip = "off")
