## fastq-mcf (Version 1.05): raw fastq screening
```
$ fastq-mcf -t 0.01 -q 15 -l 60 adapters.fa "RAW_INPUT_R1.fq" "RAW_INPUT_R2.fq" -o "OUTPUT_R1.trimmed.fq" -o "OUTPUT_R2.trimmed.fq" 2>INPUT_trim.log &
  # -t N     % occurance threshold before adapter clipping
  # -q N     quality threshold causing base removal
  # -l N     Minimum remaining sequence length
```

## GSNAP (Version 2016-08-16): Mapping to reference genome
```
#<1. Generate genome map>#
$ gmap_build -k 13 -D . -d /PATH_TO_GENOME/SPECIES.gmap /PATH_TO_GENOME/SPECIES.fa
  # -k 13: genome k-mer 13bp
  # -D .: output in current directory
  # -d PATH: gmap directory path
  # PATH/fasta: input genome fasta to build gmap

#<2. Generate known splicing database>#
$ gffread SPECIES_exons.gff3 -T -o SPECIES_exons.gtf 
$ cat SPECIES_exons.gtf | gtf_splicesites > SPECIES.splicesites
$ cat SPECIES.splicesites | iit_store -o SPECIES.splicesites
$ cp SPECIES.splicesites.iit /PATH_TO_GENOME/SPECIES.gmap/SPECIES.gmap.maps

#<3. Map reads to genome guided by known junctions>#
$ gsnap -D . -d SPECIES.gmap --nthreads=5 -k 13 -B 5 -m 0.05 -n 5 -Q -N 1 -s SPECIES.splicesites -w 13000 --nofails --format=sam --sam-multiple-primaries --pairmax-rna=13000 --split-output=SAMPLE_NAME.sam /PATH_TO_FASTQ/SAMPLE_NAME_R1.trimed.fastq /PATH_TO_FASTQ/SAMPLE_NAME_R2.trimed.fastq
  # -D .: output in current directory
  # -d PATH: gmap directory path
  # --nthreads 5: use 5 threads to run
  # -k 13: genome k-mer size
  # -B 5: batch model 5
  # -m 0.05: maximum mismatch allowed is 5%
  # -n 5: maximum hits to print in mult file
  # -Q: together with –n 5, if multi-hit exceed number 5, print in mult_ex file
  #-N 1: look for novel splicing
  # -s NAME: look for known splicing documented in NAME.iit
  # -w maximum length for intron (13000 for P. balsamifera; 17000 for S. viminalis; 10000 for A. officinalis)
  # --nofails: exclude printing of failed alignments
  # --format=sam: output sam file
  # --sam-multiple-primaries: allows multiple alignments to be marked as primary if they have equally good mapping scores
  # -pairmax-rna=13000: max total genomic length 13000bp for RNA-Seq paired reads, should match the value for -w (13000 for P. balsamifera; 17000 for S. viminalis; 10000 for A. officinalis).
  # --split-output=female_flower1.sam: split output files with shared string “female_flower1.sam”
  # PATH/R1: one of the pair-end reads
  # PATH/R2: the other pair-end reads
  ```
  
## cufflinks (Version 2.2.1): Transcript assembly and differential expression analysis
```
#<1.cufflinks: generate assembly from each sample>#
$ cufflinks -g /PATH_TO_GENOME/SPECIES_exons.gff3 -b /PATH_TO_GENOME/SPECIES.fa -u -p 4 -F 0.08 -I 13000 --min-intron-length 10 -N /PATH_TO_BAM/BAM
  # -g: genome guided assembly
  # -b: provide genome fasta file to correct bias in transcript abundance estimates
  # -u: multi read correction
  # -F: min-isoform fraction, 0.08 or 8% of the most abundant isoform (the major isoform) of the gene.
  # -I: max-intron-length 13000 (13000 for P. balsamifera; 17000 for S. viminalis; 10000 for A. officinalis)
  # --min-intron-length: minimum intron length 10
  # -N: upper quartile normalization, this can improve robustness of differential expression calls for less abundant genes and transcripts

#<2.cuffmerge: merge assemblies into a single reference>#
$ cuffmerge -g /PATH_TO_GENOME/SPECIES_exons.gff3 -s /PATH_TO_GENOME/SPECIES.fa -p 5 --keep-tmp gtf.list
  # -g: genome guided 
  # -s: provide genome fasta file
  # -p: use 5 threads to run
  # --keep-tmp: Keep all intermediate files during merge

#<3.screening transcripts>#
 <3.1 screen by transcript direction>
 $ perl correct_direction.pl
 # It will screen out the transcript with a direction which is different from the annotated genes in the same locus.
 
 <3.2 screen by fpmk>
 $ perl screen_fpkm1.pl
 # It will screen out transcript which has fpkm value lower than 1 in all samples.

#<4.differential expression>#
$ cuffdiff -b /PATH_TO_GENOME/SPECIES.fa -p 4 -L TREATMENT1,TREATMENT2 /PATH_TO_SCREENED_GTF/SCREENED.gtf /PATH_TO_BAM/TREATMENT1_REP1.bam,/PATH_TO_BAM/TREATMENT1_REP2.bam,/PATH_TO_BAM/TREATMENT1_REP3.bam,/PATH_TO_BAM/TREATMENT1_REP4.bam,/PATH_TO_BAM/TREATMENT1_REP5.bam /PATH_TO_BAM/TREATMENT2_REP1.bam,/PATH_TO_BAM/TREATMENT2_REP2.bam,/PATH_TO_BAM/TREATMENT2_REP3.bam,/PATH_TO_BAM/TREATMENT2_REP4.bam,/PATH_TO_BAM/TREATMENT2_REP5.bam 2>log.txt &
  # -b: genome fasta file
  # -p: use 4 threads to run
  # -L: comma-separated list of condition labels
 ``` 
 
