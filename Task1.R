# Load necessary libraries
library(data.table)
library(tidyr)

# Read gene_info file and create mapping of symbols to Entrez IDs
gene_info_file <- "/home/shweta/Downloads/hiring_task/Homo_sapiens.gene_info.gz"

gene_info <- fread(cmd = paste("zcat", gene_info_file))
gene_info <- gene_info[, .(GeneID, Symbol, Synonyms)]
# Extract relevant columns: GeneID (Entrez ID), Symbol, and Synonyms
gene_info <- gene_info[, c("GeneID", "Symbol", "Synonyms"), drop = FALSE]

# Split Synonyms column and unnest it
synonyms <- unlist(strsplit(gene_info$Synonyms, "\\|"))
gene_info <- gene_info[rep(1:nrow(gene_info), lengths(strsplit(gene_info$Synonyms, "\\|"))), ]
gene_info$Symbol <- synonyms

# Create a mapping of symbols to Entrez IDs
symbol_entrez_mapping <- unique(gene_info)


# Read GMT file and replace symbols with Entrez IDs
gmt_file <- "/home/shweta/Downloads/hiring_task/h.all.v2023.1.Hs.symbols.gmt"
output_file <- "Task1.gmt"

input <- file(gmt_file, "r")
output <- file(output_file, "w")

while (TRUE) {
  line <- readLines(input, n = 1)
  if (length(line) == 0) break  # Break if end of file is reached
  
  # Split line into fields
  fields <- unlist(strsplit(line, "\t"))
  
  # Replace gene names with Entrez IDs
  entrez_ids <- symbol_entrez_mapping$GeneID[symbol_entrez_mapping$Symbol %in% fields[-c(1, 2)]]
  fields[-c(1, 2)] <- paste(entrez_ids, collapse = "\t")
  
  # Write modified line to output file
  writeLines(paste(fields, collapse = "\t"), output)
}

# Close input and output files
close(input)
close(output)

