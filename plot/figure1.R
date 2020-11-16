input <- "results/cortex-a53/benchmark.data"
output <- "results/figure1.pdf"

source("plot/core.R")

cols <- c("size", "generator", "variant", "median_ms", "min_ms", "max_ms")
data <- read_delim(input, " ", col_names = cols)

variants = c("halide", "lift", "cbuf+rrot")
data <- data %>%
  filter(size == "1536x2560") %>%
  filter(variant %in% variants) %>%
  mutate(speedup = median_ms[1]/median_ms) %>%
  transform(variant = factor(variant, levels=variants))

print(data)

g <- ggplot(data, aes(x=variant, y=speedup, fill=generator)) +
  scale_y_continuous(name = "relative runtime\n performance") +
  geom_col(colour = "black") + # show.legend = FALSE,
  # geom_hline(yintercept = 1) +
  geom_text(aes(label=sprintf("%0.2f", round(speedup, digits = 2))), colour="white", family="DejaVu Sans", size=4, position=position_dodge(width=0.9), vjust=1.5) +
  # facet_wrap(~processor, scales="free_y", nrow=1) +
  # coord_flip() +
  theme_bw() + theme(
    legend.title = element_blank(),
    legend.text = element_text(size=10, family="DejaVu Sans"),
    axis.text.x = element_blank(),
    axis.text.y = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_text(margin = margin(t = 0, r = 15, b = 0, l = 0)),
    text = element_text(size=10, family="DejaVu Sans")
  ) +
  scale_fill_manual(values = c("#882255", "#7D500E", "#117733"))
ggsave(output, plot = g, width = 8, height = 3, units = "cm")
