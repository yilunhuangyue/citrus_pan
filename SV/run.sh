ngmlr -t 20 -r ref.fa -q longreads.fasta -o map.sam -x ont
samtools view -@ 10 map.sam -o map.bam
samtools sort -@ 10 map.bam -o map.sort.bam
sniffles -m map.sort.bam --min_support 5 -t 30 -v SV.vcf
