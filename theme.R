### Theme to be used by all visualisations
library(ggplot2)
library(ggtext)
library(showtext)
font_add_google("Roboto", "roboto")
showtext_auto()

app_colours <- list(
  title = "#474747",
  axis = "#757575",
  legend_title = "#474747",
  legend_text = "#757575",
  subtitle = "#757575",
  caption = "#8f8f8f",
  main = "#1976d2",
  no_emphasis = "#8f8f8f",
  no_emphasis2 = "#a8a8a8",
  divergent = "#f57c00",
  line_main = "#42a5f5",
  line_complementary = "#78909c"
)

theme_minimalistic <- function() {
  theme_classic() +
    theme(
      text = element_text(family = "roboto"),
      plot.title = element_text(hjust = 0, colour = app_colours$title),
      plot.title.position = "plot",
      axis.line = element_line(colour = app_colours$axis),
      axis.ticks = element_line(colour = app_colours$axis),
      axis.text = element_text(colour = app_colours$axis),
      axis.title = element_text(colour = app_colours$axis),
      legend.title = element_text(colour = app_colours$legend_title),
      legend.text = element_text(colour = app_colours$legend_text),
      plot.subtitle = element_textbox_simple(colour = app_colours$subtitle,
                                             margin = margin(b = 15)),
      plot.caption = element_text(colour = app_colours$caption),
      plot.caption.position = "plot",
      panel.background = element_rect(fill = "transparent"),
      plot.background = element_rect(fill = "transparent", color = NA)
    )
}

theme_set(theme_minimalistic())