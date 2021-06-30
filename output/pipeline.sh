#Verificação da qualidade dos reads
fastqc 510-7-BRCA_S8_L001_R*_001.fastq.gz

#Contagem do número de sequências 
grep -e "Total Sequences" 510-7-BRCA_S8_L001_R1_001_fastqc.html | awk -F "<td>" {'print $9'}| awk -F "<" {'print $1'}
grep -e "Total Sequences" 510-7-BRCA_S8_L001_R2_001_fastqc.html | awk -F "<td>" {'print $9'}| awk -F "<" {'print $1'}

#Indexação do genoma referência e mapeamento
bwa index hg19.fasta
bwa mem hg19.fasta 510-7-BRCA_S8_L001_R1_001.fastq.gz 510-7-BRCA_S8_L001_R2_001.fastq.gz > BRCA_aln.sam

#Conversão do arquivo sam em bam, ordenamento e indexação.
samtools view -S -b BRCA_aln.sam >BRCA_aln.bam
samtools sort BRCA_aln.bam -o BRCA_aln_sorted.bam
samtools index BRCA_aln_sorted.bam

#Contagem para resposta das perguntas
samtools view BRCA_aln_sorted.bam chr17:41197694-41197819 | wc -l
samtools view -F 0x2 BRCA_aln_sorted.bam | wc -l

#Chamada de variantes
freebayes -f hg19.fasta BRCA_aln_sorted.bam --target BRCA.list >BRCA_freebayes.vcf

#Anotação das variantes
snpEff hg19 BRCA_freebayes.vcf >BRCA_snpEff.vcf

#Contagem para resposta das perguntas
grep -e "LOW" BRCA_snpEff.vcf |awk {'print $1":"$2" "$4">"$5'}
grep -e "MODERATE" BRCA_snpEff.vcf |awk {'print $1":"$2" "$4">"$5'}
grep -e "HIGH" BRCA_snpEff.vcf |awk {'print $1":"$2" "$4">"$5'}