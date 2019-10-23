#!/usr/bin/perl

# Input file format "ALL_fpkm1_screened.txt" (It contains all isoform which has fpkm > 1 in at least one sample)
# XLOC_000001
# XLOC_000004
# XLOC_000006
# XLOC_000015
# XLOC_000024
# XLOC_000030
# XLOC_000033
# XLOC_000047
# XLOC_000054

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
