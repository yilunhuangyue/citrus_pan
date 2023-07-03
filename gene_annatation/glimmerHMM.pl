my ($genome,$output)=@ARGV;
system("touch $output");

use Bio::SeqIO;
my $in = Bio::SeqIO->new(-file => "$genome",-format => 'Fasta');

while(my $inseq=$in->next_seq){
     my $tmp = Bio::SeqIO->new(-file => ">tmp.fa",-format => 'Fasta');
	 $tmp->write_seq($inseq);
     system("/home/huangyue/software/GlimmerHMM/bin/glimmerhmm_linux_x86_64 tmp.fa /home/huangyue/software/GlimmerHMM/trained_dir/rice -f -n 1 -g -o mid.txt");
	 system("cat mid.txt >>$output");
}

system("rm mid.txt");

