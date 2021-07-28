#!/usr/bin/bash
# Sars-Cov-2 assembly pipeline
# Developing by Wilson Junior
# Version 1.0

echo "Sars-Cov-2 assembly pipeline v1.0"

#Create folder structure
mkdir -p 0.fastq 1.fastQC 2.fastq_trimmed 3.denovo_assembly 4.reference_assembly 4.reference_assembly/tmp

# Take sample file name
FILE1=$(basename *_R1_* .fastq.gz)
FILE2=$(basename *_R2_* .fastq.gz)
FILE=$(basename *R1* _R1_001.fastq.gz)
# General Variables
THREADS='12'
REFERENCE="/media/labbe-x/HD2/Projetos/Sars-Cov-2_Reference/GCF_009858895.2_ASM985889v3_genomic.fna"
# Move raw data to appropriate folder
mv *.fastq.gz 0.fastq/

##
# QUALITY CONTROL
##

# Quality check for raw reads
echo "Quality check of raw reads"
fastqc 0.fastq/${FILE1}.fastq.gz 0.fastq/${FILE2}.fastq.gz -o 1.fastQC/ -t 10

# Quality filter and trimming
echo "Quality Trimming"
# Filtering raw reads by length and quality
echo "Filtering raw reads"
sickle pe -f 0.fastq/${FILE1}.fastq.gz -r 0.fastq/${FILE2}.fastq.gz -o 2.fastq_trimmed/${FILE1}.fastq.gz -p 2.fastq_trimmed/${FILE2}.fastq.gz -s 2.fastq_trimmed/single.fastq.gz -t sanger -g

# de novo assembly using Spades
echo "denovo assembly using spades"
spades.py -1 2.fastq_trimmed/${FILE1}.fastq.gz -2 2.fastq_trimmed/${FILE2}.fastq.gz -s 2.fastq_trimmed/single.fastq.gz -t ${THREADS} -o 3.denovo_assembly

# Mapping paired reads
# Previously bwa index GCF_009858895.2_ASM985889v3_genomic.fna
echo "mapping reads on reference NC_045512 (indexed)"
bwa mem -k 17 -B 2 -O 3 -t ${THREADS} -M -R "@RG\tID:${FILE}\tSM:${FILE}\tPL:Illumina\tCN:GNMK-HIAE" -K 100000000 $REFERENCE \
2.fastq_trimmed/${FILE1}.fastq.gz 2.fastq_trimmed/${FILE2}.fastq.gz | samtools view -b > 4.reference_assembly/${FILE}.bam

# mapping single reads
bwa mem -k 17 -B 2 -O 3 -t ${THREADS} -M -R "@RG\tID:${FILE}\tSM:${FILE}\tPL:Illumina\tCN:GNMK-HIAE" -K 100000000 $REFERENCE \
2.fastq_trimmed/single.fastq.gz | samtools view -b > 4.reference_assembly/${FILE}_s.bam

# merging bam files paired plus single
samtools merge 4.reference_assembly/${FILE}_merged.bam 4.reference_assembly/${FILE}.bam 4.reference_assembly/${FILE}_s.bam

# sorting bam file
samtools sort 4.reference_assembly/${FILE}_merged.bam > 4.reference_assembly/${FILE}_merged_sorted.bam

# indexing bam files
samtools index 4.reference_assembly/${FILE}_merged_sorted.bam

# Picard for mark duplicates
picard MarkDuplicates I=4.reference_assembly/${FILE}_merged_sorted.bam M=4.reference_assembly/picard.duplication_metrics_${FILE}.txt \
O=4.reference_assembly/${FILE}_mapped_2gatk_sorted_MKD.bam

# Index final BAM
samtools index 4.reference_assembly/${FILE}_mapped_2gatk_sorted_MKD.bam

# Run GATK - Haplotype caller
gatk --java-options "-Xmx12g" HaplotypeCaller --tmp-dir 4.reference_assembly/tmp --sample-ploidy 1 --input 4.reference_assembly/${FILE}_merged_sorted.bam \
--output 4.reference_assembly/${FILE}_haplotypecaller.vcf \
--reference $REFERENCE --bam-output 4.reference_assembly/${FILE}_gatk_realigned_bamout.bam

# run freebayes to call variants
freebayes -f $REFERENCE 4.reference_assembly/${FILE}_mapped_2gatk_sorted_MKD.bam | vcffilter -f "QUAL > 20" > 4.reference_assembly/${FILE}_freebayes.vcf
##
# metrics calculation
# calculate mapped reads
echo -n "${FILE} " && echo $(zcat 0.fastq/*.fastq.gz | wc -l)/4|bc > 4.reference_assembly/${FILE}_count_reads.txt
echo -n "${FILE} " && samtools view -F 0x04 -c 4.reference_assembly/${FILE}_mapped_2gatk_sorted_MKD.bam > 4.reference_assembly/${FILE}_mapped_reads.txt
echo -n "${FILE} " && echo $(zcat 2.fastq_trimmed/*.fastq.gz | wc -l)/4|bc > 4.reference_assembly/${FILE}_count_trimmed_reads.txt

# consensus assemly
samtools mpileup -uf $REFERENCE 4.reference_assembly/${FILE}_mapped_2gatk_sorted_MKD.bam | bcftools call -c --ploidy 1 | vcfutils.pl vcf2fq > 4.reference_assembly/${FILE}.fastq

# convert fastq to fasta
seqtk seq -A 4.reference_assembly/${FILE}.fastq > 4.reference_assembly/${FILE}_unamed.fasta

# convert fastq to fasta and rename sequence by bash
while IFS= read -r line
do
    case "$line" in
       *NC_045512.2*) printf "%s\n" "${line/NC_045512.2/${FILE}}" ;;
       *) printf "%s\n" "$line" ;;
    esac
done < 4.reference_assembly/${FILE}_unamed.fasta > 4.reference_assembly/${FILE}.fasta

# indexing assembly as reference
# gatk CreateSequenceDictionary --REFERENCE 4.reference_assembly/${FILE}.fasta --OUTPUT 4.reference_assembly/${FILE}.dict
# samtools faidx 4.reference_assembly/${FILE}.fasta

# getting consensus sequence from gatk calling
# gatk --java-options "-Xmx12g" FastaAlternateReferenceMaker -R 4.reference_assembly/${FILE}.fasta -O 4.reference_assembly/${FILE}_gatk.fasta -V 4.reference_assembly/${FILE}_haplotypecaller.vcf

# getting consensus sequence from freebays calling
# gatk --java-options "-Xmx12g" FastaAlternateReferenceMaker -R 4.reference_assembly/${FILE}.fasta -O 4.reference_assembly/${FILE}_freebayes.fasta -V 4.reference_assembly/${FILE}_freebayes.vcf

# getting consensus sequence from gatk calling from reference
# gatk --java-options "-Xmx12g" FastaAlternateReferenceMaker -R $REFERENCE -O 4.reference_assembly/${FILE}_ref_gatk.fasta -V 4.reference_assembly/${FILE}_haplotypecaller.vcf

# genome assembled!
echo "done"