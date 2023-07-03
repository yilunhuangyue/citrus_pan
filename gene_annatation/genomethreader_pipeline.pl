foreach $i(1..18){
    open OUT,">gth_$i.sh";
    print OUT "cd ~/annotation/HKC/homologous\n";
    print OUT "gth -genomic seq/$i.fa  -protein ~/annotation/homologous/db/homologous_protein.fasta -intermediate -gff3out  > gth_$i.gff3";
    close OUT;
    system("nohup sh gth_$i.sh &");
    system("sleep 5m")
}

