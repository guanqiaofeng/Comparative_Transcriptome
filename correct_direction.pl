#!/usr/bin/perl

# Input file format "gene_ann_dir.txt"
# -	Potri.001G000200
# +	Potri.001G000300
# -	Potri.001G000400
# -	Potri.001G000500
# +	Potri.001G000600
# -	Potri.001G000700
# -	Potri.001G000800
# -	Potri.001G000900
# +	Potri.001G001000

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
