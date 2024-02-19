# Load required libraries
library(ggplot2)

# Read the data
gene_info = read.table("/home/shweta/Downloads/hiriing_task2/Homo_sapiens.gene_info.gz", header = TRUE, sep = "\t", quote = "", comment.char = "")

# Filtered out rows with ambiguous chromosome values
gene_info = gene_info[!grepl("[\\|-]", gene_info$chromosome), ]

# Counting the number of genes per chromosome
gene_counts = table(gene_info$chromosome)

# Created a data frame from the counts
gene_counts_df = data.frame(chromosome = names(gene_counts), count = as.numeric(gene_counts))

# Chronlogically ordered the chromosome levels
chromosome_order = c(1:22, "X", "Y", "MT", "Un")
gene_counts_df$chromosome = factor(gene_counts_df$chromosome, levels = chromosome_order)


# Plot
p = ggplot(gene_counts_df, aes(x = chromosome, y = count)) +
  geom_bar(stat = "identity") +
  labs(title = "Number of genes in each chromosome",
       x = "Chromosomes", y = "Gene count") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
        axis.line = element_line(color = "black"),
        axis.ticks = element_line(color = "black"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  theme(plot.title = element_text(hjust = 0.5))
  
# Save the plot as PDF
ggsave("Task3_gene_counts_per_chromosome.pdf", plot = p, width = 10, height = 6)
