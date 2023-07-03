($in1,$in2,$out)=@ARGV;
open IN1,"$in1";
open IN2,"$in2";
open OUT,">$out";
while(chomp($line=<IN1>)){
	@tmp=split(" ",$line);
	$chr=$tmp[0];
	$pos=$tmp[1];
	$id=$chr."_".$pos;
	$hash{$id}++;
}
while(chomp($line=<IN2>)){
	if($line=~/#/){
		print OUT "$line\n";
	}
	else{
		@tmp=split(" ",$line);
		$chr=$tmp[0];
		$pos=$tmp[1];
		$id=$chr."_".$pos;
		if(exists($hash{$id})){
			print OUT "$line\n";
		}
	}
}