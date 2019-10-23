#!/usr/bin/perl

%hash = ();

open FH, "<gene_ann_dir.txt";
while (<FH>)
{
    if (/(\S+)\s+(\S+)/)
    {
	  $dir = $1;
	  $gene = $2;
	  $hash{$gene} = $dir;
    }
}
close FH;

open FH, "<merged_dir.gtf";
open OUT, ">merged_dir_correctDIR.gtf";
open OUT1, ">merged_dir_wrongDIR.gtf";
while (<FH>)
{
    $seq = $_;
    chomp $seq;
    if (/\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+(\S+)\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+\s+"(\S+)";/)
    {
	    $dir = $1;
	    $gene = $2;
	    $ref = $hash{$gene};
	    if ($dir eq $ref)
	    {
	      print OUT "$seq\n";
	    }
	    else
	    {
	      print OUT1 "$seq\n";
	    }
    }
    else
    {
	    print OUT "$seq\n";
    }
}
close FH;
close OUT;
close OUT1;
