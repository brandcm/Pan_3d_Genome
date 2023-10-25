# retrieve file
wget https://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/phastConsElements30way.txt.gz
gzip -d phastConsElements30way.txt.gz

# 100 score threshold
awk '($6 >= 100) {print $2,$3,$4,$6}' OFS='\t' phastConsElements30way.txt > phastConsElements30way_100_hg38.tmp
sort -k1,1 -k2n,2 phastConsElements30way_100_hg38.tmp > phastConsElements30way_100_hg38.bed
./liftover phastConsElements30way_100_hg38.bed hg38ToPanTro6.over.chain.gz phastConsElements30way_100_panTro6.tmp phastConsElements30way_100_hg38_unlifted.bed  
sort -k1,1 -k2n,2 phastConsElements30way_100_panTro6.tmp > phastConsElements30way_100_panTro6.bed

# 500 score threshold
awk '($6 >= 500) {print $2,$3,$4,$6}' OFS='\t' phastConsElements30way.txt > phastConsElements30way_500_hg38.tmp
sort -k1,1 -k2n,2 phastConsElements30way_500_hg38.tmp > phastConsElements30way_500_hg38.bed
./liftover phastConsElements30way_500_hg38.bed hg38ToPanTro6.over.chain.gz phastConsElements30way_500_panTro6.tmp phastConsElements30way_500_hg38_unlifted.bed  
sort -k1,1 -k2n,2 phastConsElements30way_500_panTro6.tmp > phastConsElements30way_500_panTro6.bed