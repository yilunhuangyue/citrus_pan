cd workspace
genome="ref.fa"
reads1="spe_trim_R1.fq.gz"
reads2="spe_trim_R2.fq.gz"
name="spe"
#bwa index -a bwtsw ${genome}
#samtools faidx ${genome}
#java -Xmx40g -jar ~/software/picard/picard.jar CreateSequenceDictionary R=ref.fa O=ref.dict
bwa mem  -M -t 20 ${genome} ${reads1} ${reads2} > ${name}_reads.sam
samtools view -@ 20 -bS ${name}_reads.sam | samtools flagstat -> maping.stat
samtools view -@ 20 -q 30 -bS ${name}_reads.sam -o ${name}_reads.bam
rm ${name}_reads.sam
java -Xmx40g -jar ~/software/picard/picard.jar SortSam SORT_ORDER=coordinate INPUT=${name}_reads.bam OUTPUT=${name}_reads_sort.bam
java -Xmx40g -jar ~/software/picard/picard.jar MarkDuplicates INPUT=${name}_reads_sort.bam OUTPUT=${name}_reads_sort_dedup.bam M=${name}_markdup_metrics.txt
java -Xmx40g -jar ~/software/picard/picard.jar AddOrReplaceReadGroups I=${name}_reads_sort_dedup.bam O=${name}_reads_sort_dedup.adgr.bam SORT_ORDER=coordinate RGID=${name} RGLB=${name} RGPL=illumina RGPU=${name} RGSM=${name} CREATE_INDEX=True     VALIDATION_STRINGENCY=LENIENT
java -Xmx40g -jar ~/software/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar -T  RealignerTargetCreator  -R ${genome} -I ${name}_reads_sort_dedup.adgr.bam  -nt 40 -o ${name}.realign.intervals -allowPotentiallyMisencodedQuals
java -Xmx40g -jar ~/software/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar -T IndelRealigner  -I ${name}_reads_sort_dedup.adgr.bam  -R ${genome} -allowPotentiallyMisencodedQuals  -targetIntervals  ${name}.realign.intervals   -o ${name}.fixed.bam 
java -Xmx40g -jar ~/software/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar -T UnifiedGenotyper -allowPotentiallyMisencodedQuals -R ${genome} -I ${name}.fixed.bam -o ${name}.raw.vcf -nt 5
java -Xmx40g -jar ~/software/GenomeAnalysisTK-3.8-1-0-gf15c1c3ef/GenomeAnalysisTK.jar -T VariantFiltration -R ${genome} --filterExpression "MQ0 >= 4 && ((MQ0 / (1.0 * DP)) > 0.1)" --filterExpression "FS>=10.0" --filterExpression "AN>=4" --filterExpression "DP>150 || DP<4" --filterName HARD_TO_VALIDATE --filterName SNPSBFilter --filterName SNPNalleleFilter --filterName SNPDPFilter -cluster 3 -window 10 -V ${name}.raw.vcf -o ${name}.filt.vcf
grep "PASS" ${name}.filt.vcf > ${name}.pass.vcf
