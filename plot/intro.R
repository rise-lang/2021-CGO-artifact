args <- commandArgs(TRUE)
input <- paste0(args[1])
output <- paste0(input, "Intro.pdf")

source("plot/core.R")

data <- read_delim(input, " ")

variants = c("halide", "lift", "reg-rot")
data <- data %>%
  filter(processor == "Cortex A53") %>%
  filter(variant %in% variants) %>%
  mutate(speedup = median_ms[1]/median_ms) %>%
  transform(variant = factor(variant, levels=variants))

print(data)

g <- ggplot(data, aes(x=variant, y=speedup, fill=generator)) +
  scale_y_continuous(name = "relative runtime\n performance") +
  geom_col(colour = "black") + # show.legend = FALSE,
  geom_hline(yintercept = 1) +
  geom_text(aes(label=sprintf("%0.2f", round(speedup, digits = 2))), position=position_dodge(width=0.9), vjust=-0.25) +
  # facet_wrap(~processor, scales="free_y", nrow=1) +
  # coord_flip() +
  theme_bw() + theme(
    legend.title = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_text(margin = margin(t = 0, r = 15, b = 0, l = 0)),
    text = element_text(size=14, family="DejaVu Sans")
  ) +
  scale_fill_manual(values = c("#882255", "#DDCC77", "#117733"))
ggsave(output, plot = g, width = 12, height = 8, units = "cm")
