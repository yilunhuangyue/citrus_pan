perl select_snp.pl 4dsite.txt all.vcf 4dsite.vcf # extracted SNPs at four-fold degenerate sites
vcf2phylip.py -i 4dsite.vcf  # transfer the vcf format to phy format
modeltest-ng -i 4dsite.min4.phy -d nt -p 10  # test for the best model
raxml-ng  --bs-trees 1000 --model TVM+G4 --outgroup huajiao -msa 4dsite.min4.phy  --thread 20  --all --prefix tree  #construct phylogenetic trees
r8s -b -f r8s_in.txt > r8s_out.txt  #estimated divergence time 
