args <- commandArgs(TRUE)
input <- paste0(args[1])
output <- paste0(input, ".pdf")

source("plot/core.R")

data <- read_delim(input, " ")

data <- data %>%
  group_by(processor) %>%
  mutate(speedup = median_ms[1]/median_ms) %>%
  transform(processor = factor(processor, levels=c("cortex-a7", "cortex-a15", "cortex-a53", "cortex-a73")),
            variant = factor(variant, levels=c("reference", "u-loads", "a-loads", "reg-rot")))

start <- 0.4
t_shift <- scales::trans_new("shift",
                             transform = function(x) { log2(x+(1-start)) },
                             inverse = function(x) { (2^x)-(1-start) })

g <- ggplot(data, aes(x=variant, y=speedup, fill=generator)) +
  # xlab("variant") +
  scale_y_continuous(name="median speedup (log scale)",
                     trans=t_shift, breaks = seq(start, 2, by=0.2),
                     limits = c(start, 2)) +
  geom_col(colour = "black") + # show.legend = FALSE,
  geom_hline(yintercept = 1) +
  facet_wrap(~processor, scales="free_y", nrow=1) + # nrow
  # coord_flip() +
  theme_bw() + theme(
    legend.title = element_blank(),
    axis.text.x = element_text(angle = 45, hjust=1)
  ) +
  scale_fill_manual(values = c("#882255", "#117733"))
ggsave(output, plot = g, width = 24, height = 8, units = "cm")
