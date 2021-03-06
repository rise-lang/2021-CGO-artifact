inputs <- list(
  list("Cortex A7", "results/cortex-a7/benchmark.data"),
  list("Cortex A15", "results/cortex-a15/benchmark.data"),
  list("Cortex A53", "results/cortex-a53/benchmark.data"),
  list("Cortex A73", "results/cortex-a73/benchmark.data")
)
output <- "results/figure8.pdf"

source("plot/core.R")

data <- data.frame()
cols <- c("size", "generator", "variant", "median_ms", "min_ms", "max_ms")
for (input in inputs) {
  processorData <- read_delim(input[[2]], " ", col_names = cols) %>%
    select(-c(min_ms, max_ms)) %>%
    mutate(processor=input[[1]])
  data <- bind_rows(data, processorData)
}

toPixels <- function(size) {
  parts <- unlist(str_split(size, 'x'))
  as.numeric(parts[1]) * as.numeric(parts[2])
}
processors <- c("Cortex A7", "Cortex A15", "Cortex A53", "Cortex A73")

data <- data %>%
  group_by(size, processor) %>%
  mutate(pixels = toPixels(size)) %>%
  mutate(mpxps = (pixels/1e6)/(median_ms/1e3)) %>%
  transform(size = factor(size, c("1536x2560", "4256x2832")),
            processor = factor(processor, levels=processors),
            variant = factor(variant, levels=c("opencv", "lift", "cbuf", "cbuf+rrot", "halide"))) %>%
  mutate(variant = recode(variant,
                          opencv = "OpenCV",
                          lift = "Lift",
                          cbuf = "Rise cbuf",
                          `cbuf+rrot` = "Rise cbuf+rrot",
                          halide = "Halide"))

print(data)

g <- ggplot(data, aes(x=variant, y=mpxps, fill=generator)) +
  # xlab("variant") +
  # ylab("relative runtime performance") +
  scale_y_continuous(name = "runtime performance\n(megapixels per second)") +
                     # trans="log2", breaks=c(1, 2, 4, 8, 16),
                     # breaks = function(lim) { c(1, seq(2, lim[2], by=2)) }) +
                     # limits=c(0, 18)) +
                     # trans=t_shift, breaks = c(0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.2, 1.4, 1.6, 1.8, 2.0),
                     # limits = c(0.5, 2)) +
  geom_bar(colour = "black", position="dodge", stat="identity", aes(alpha=size)) +
  # geom_hline(yintercept = 1) +
  facet_wrap(~processor, scales="free_y", nrow=1) +
  # coord_flip() +
  theme_bw() + theme(
    legend.title = element_blank(),
    axis.text.x = element_text(angle = 45, hjust=1),
    axis.title.x = element_blank(),
    axis.title.y = element_text(margin = margin(t = 0, r = 15, b = 0, l = 0)),
    text = element_text(size=14, family="DejaVu Sans")
  ) +
  scale_fill_manual(values = c("#882255", "#7D500E", "#505050", "#117733"), breaks=0) +
  scale_alpha_manual(values = c(0.6, 1.0))
ggsave(output, plot = g, width = 28, height = 8, units = "cm")
