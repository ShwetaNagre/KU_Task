wget -q https://ftp.ncbi.nlm.nih.gov/genomes/archive/old_refseq/Bacteria/Escherichia_coli_K_12_substr__MG1655_uid57779/NC_000913.faa
Total_num_of_seqs=$(grep -c "^>" NC_000913.faa) && Total_AA_count=$(grep -v "^>" NC_000913.faa | tr -d '\n' | wc -c)
Average_length=$(echo "scale=2; $Total_AA_count / $Total_num_of_seqs" | bc)
echo "Average length of protein: $Average_length"
