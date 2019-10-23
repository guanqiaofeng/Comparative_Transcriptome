#!/usr/bin/perl

%hash = ();

open FH, "<ALL_fpkm1_screened.txt";
while (<FH>)
{
    $seq = $_;
    chomp $seq;
    $hash{$seq} = 0;
}
close FH;

open FH, "<merged_dir_correctDIR.gtf";
open OUT, ">merged_dir_correctDIR_fpkm1.gtf";
while (<FH>)
{
    $seq = $_;
    chomp $seq;
    if (/gene_id\s\"(\S+)\";/)
    {
        $gene = $1;
	      if (exists ($hash{$gene}))
	      {
	        print OUT "$seq\n";
	      }
    }
}
close FH;
close OUT;
