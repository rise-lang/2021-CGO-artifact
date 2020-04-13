args <- commandArgs(TRUE)
input <- paste0(args[1])
output <- paste0(input, ".pdf")

source("plot/core.R")

data <- read_delim(input, " ")

data <- data %>%
  group_by(processor) %>%
  mutate(speedup = median_ms[1]/median_ms) %>%
  transform(processor = factor(processor, levels=c("cortex-a7", "cortex-a15", "cortex-a53", "cortex-a73")),
            variant = factor(variant, levels=rev(c("halide", "rise unaligned loads", "rise aligned loads", "rise register rotation"))))

g <- ggplot(data, aes(x=variant, y=speedup, fill=generator)) +
  # xlab("variant") +
  scale_y_continuous(name="median speedup (log scale)",
                     trans="log2", breaks = seq(0, 2, by=0.1)) +
  geom_bar(colour = "black", show.legend = FALSE, stat = "identity") +
  geom_hline(yintercept = 1) +
  facet_wrap(~processor, scales="free_x") + # scale, nrow
  coord_flip() +
  theme_bw() + theme(legend.title = element_blank()) +
  scale_fill_manual(values = c("#5e3c99", "#e66101"))
ggsave(output, plot = g, width = 10, height = 6, units = "cm")
