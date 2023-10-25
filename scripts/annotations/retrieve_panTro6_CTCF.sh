#!/bin/bash

# 09-27-22, Colin M. Brand, University of California San Francisco
# Download and format chimpanzee LCL CTCF data from Schwalie et al. 2013.

# This script primarily uses basic Linux commands but also requires bedtools and liftOver. The liftOver executable and necessary chain files should exist in the directory from which this script is run. Otherwise you can edit the path(s) for those lines below.

# download files
wget https://www.ebi.ac.uk/arrayexpress/files/E-MTAB-1511/E-MTAB-1511.additional.1.zip
unzip -a E-MTAB-1511.additional.1.zip && rm E-MTAB-1511.additional.1.zip && mkdir PEAK_CALLING
tar xopf PEAK_CALLING.tar --directory PEAK_CALLING && rm PEAK_CALLING.tar

# format files
cd PEAK_CALLING
awk '{print $1,$4,$5,$6}' OFS='\t' CTCF-ptr-LCL.gff  > CTCF-ptr-LCL_0.gff 
sort -k1,1 -k2n,2 CTCF-ptr-LCL_0.gff > CTCF-ptr-LCL.gff 
rm CTCF-ptr-LCL_0.gff 

# intersect
bedtools intersect -a CTCF-ptr-LCL.gff -b CTCF-ptr-18359.gff -wao > 18359_intersect.txt
bedtools intersect -a CTCF-ptr-LCL.gff -b CTCF-ptr-36222.gff -wao > 36222_intersect.txt
bedtools intersect -a CTCF-ptr-LCL.gff -b CTCF-ptr-EB176.gff -wao > EB176_intersect.txt

# We will retain just the overlap for the second and third individual files to make pasting below easier.
# Also note that the original files are in 1-closed coordinates above so I convert to 0-half-open here for downstream.

awk '{print "chr"$1,$2-1,$3,$4}' OFS='\t' 18359_intersect.txt | uniq > coords.txt
awk '{ seen[$1"\t"$2"\t"$3] += $14 } END { for (i in seen) print i,seen[i] }' OFS='\t' 18359_intersect.txt > 18359.txt
awk '{ seen[$1"\t"$2"\t"$3] += $14 } END { for (i in seen) print i,seen[i] }' OFS='\t' 36222_intersect.txt > 36222.txt
awk '{ seen[$1"\t"$2"\t"$3] += $14 } END { for (i in seen) print i,seen[i] }' OFS='\t' EB176_intersect.txt > EB176.txt

# associative arrays are not returned in order; sort and output overlap column
sort -k1,1 -k2n,2 18359.txt | awk '{print $4}' OFS='\t' > 18359_summed.txt
sort -k1,1 -k2n,2 36222.txt | awk '{print $4}' OFS='\t' > 36222_summed.txt
sort -k1,1 -k2n,2 EB176.txt | awk '{print $4}' OFS='\t' > EB176_summed.txt

# check lengths
if [ "$(wc -l < 18359_summed.txt)" -eq "$(wc -l < 36222_summed.txt)" ]; then echo '18359 and 36222 match in length'; else echo 'Warning: 18359 and 36222 do not match in length' && exit 1; fi
if [ "$(wc -l < 18359_summed.txt)" -eq "$(wc -l < EB176_summed.txt)" ]; then echo '18359 and EB176 match in length'; else echo 'Warning: 18359 and EB176 do not match in length' && exit 1; fi
if [ "$(wc -l < 36222_summed.txt)" -eq "$(wc -l < EB176_summed.txt)" ]; then echo '36222 and 36222 match in length'; else echo 'Warning: 36222 and 36222 do not match in length' && exit 1; fi

# merge
paste -d '\t' coords.txt 18359_summed.txt 36222_summed.txt EB176_summed.txt > panTro2_CTCF.bed
awk '{print $1,$2,$3,$4","$5","$6","$7}' OFS='\t' panTro2_CTCF.bed > panTro2_CTCF_0.bed && mv panTro2_CTCF_0.bed panTro2_CTCF.bed
echo 'CTCF BED-file in panTro2 coordinates successfully created'

# tidy and change directories
rm 18359_intersect.txt && rm 36222_intersect.txt && rm EB176_intersect.txt && rm coords.txt && rm 18359_summed.txt && rm 36222_summed.txt && rm EB176_summed.txt
mv panTro2_CTCF.bed ../
cd ../
rm -R PEAK_CALLING

# liftover from panTro2 to panTro6
./liftover panTro2_CTCF.bed panTro2ToPanTro4.over.chain.gz panTro4_CTCF.bed panTro2_to_panTro4_CTCF_unlifted.bed
./liftover panTro4_CTCF.bed panTro4ToPanTro5.over.chain.gz panTro5_CTCF.bed panTro4_to_panTro5_CTCF_unlifted.bed
./liftover panTro5_CTCF.bed panTro5ToPanTro6.over.chain.gz panTro6_CTCF.bed panTro5_to_panTro6_CTCF_unlifted.bed

# move unlifted files to unlifted directory
mkdir -p unlifted
mv panTro2_to_panTro4_CTCF_unlifted.bed unlifted
mv panTro4_to_panTro5_CTCF_unlifted.bed unlifted
mv panTro5_to_panTro6_CTCF_unlifted.bed unlifted

rm panTro2_CTCF.bed && rm panTro4_CTCF.bed && rm panTro5_CTCF.bed

# sort the file again
sort -k1,1 -k2n,2 panTro6_CTCF.bed > panTro6_CTCF_0.bed
awk -F '[\t,]' '{print $1,$2,$3,$4,$5,$6,$7}' OFS='\t' panTro6_CTCF_0.bed > panTro6_CTCF.bed
rm panTro6_CTCF_0.bed 
