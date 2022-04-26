bgzip merged_200_format.vcf
tabix -p vcf merged_200_format.vcf.gz
vg construct -rref.fa -v merged_200_format.vcf.gz >x.vg
vg view x.vg >x.gfa
vg index -x x.xg -g x.gcsa -k 16 x.vg

vg map -t 20 -x x.xg -g x.gcsa -f ${spe}_trim_R1.fq.gz -f ${spe}_trim_R2.fq.gz > ${spe}.gam #maping illumina reads to pan-genome
vg pack -x x.xg -g ${spe}.gam -Q 5 -o ${spe}.pack
vg call x.xg -k ${spe}.pack -s ${spe} -a > ${spe}_genotype.vcf #genotype SVs by mapping results of illumina
bgzip ${spe}_genotype.vcf
tabix -p vcf ${spe}_genotype.vcf.gz
