args <- commandArgs(TRUE)
input <- paste0(args[1])
output <- paste0(input, ".pdf")

source("plot/core.R")

data <- read_delim(input, " ")

data <- data %>%
  group_by(size, processor) %>%
  mutate(speedup = median_ms[6]/median_ms) %>%
  transform(size = factor(size, c("1536x2560", "4256x2832")),
            processor = factor(processor, levels=c("Cortex A7", "Cortex A15", "Cortex A53", "Cortex A73", "Intel i7 7700")),
            variant = factor(variant, levels=c("opencv", "lift", "cbuf", "cbuf+vec", "cbuf+vec+rot", "halide")))

print(data)

# start <- 0.5
# off <- 2*start
#t_shift <- scales::trans_new("shift",
#                             transform = function(x) { ifelse(x <= 1, 2*x, 1+x)-off },
#                             inverse = function(x) { ifelse((x+off) <= 2, (x+off)/2, (x+off)-1) })
                             #transform = function(x) { log2(x)-log2(1-start) },
                             #inverse = function(x) { (2^x)*(1-start) })

g <- ggplot(data, aes(x=variant, y=speedup, fill=generator)) +
  # xlab("variant") +
  # ylab("relative runtime performance") +
  scale_y_continuous(name = "relative runtime\n performance",
                     # trans="log2", breaks=c(1, 2, 4, 8, 16),
                     breaks = function(lim) { c(1, seq(2, lim[2], by=2)) }) +
                     # limits=c(0, 18)) +
                     # trans=t_shift, breaks = c(0.5, 0.6, 0.7, 0.8, 0.9, 1, 1.2, 1.4, 1.6, 1.8, 2.0),
                     # limits = c(0.5, 2)) +
  geom_bar(colour = "black", position="dodge", stat="identity", aes(alpha=size)) + # show.legend = FALSE,
  geom_hline(yintercept = 1) +
  facet_wrap(~processor, scales="free_y", nrow=1) +
  # coord_flip() +
  theme_bw() + theme(
    legend.title = element_blank(),
    axis.text.x = element_text(angle = 45, hjust=1),
    axis.title.x = element_blank(),
    axis.title.y = element_text(margin = margin(t = 0, r = 15, b = 0, l = 0)),
    text = element_text(size=14, family="DejaVu Sans")
  ) +
  scale_fill_manual(values = c("#882255", "#DDCC77", "#505050", "#117733")) +
  scale_alpha_manual(values = c(0.75, 1.0))
ggsave(output, plot = g, width = 28, height = 8, units = "cm")
