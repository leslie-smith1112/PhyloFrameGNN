## SCRIPT TO CALCULATE EAF FOR 1000 GENOMES ## 

library(tibble)
require(readr)  # for read_csv()
require(dplyr) #data frame handling 
library(tidyr)
library(here)
library(testthat)

rawFile <- readr::read_tsv(here("raw-data", "ALL.chr.phase3.parsed.compiled.vcf"))

#CHROM	POS	RSID	REF	ALT	AC	AN	AF	EAS_AF	AMR_AF	AFR_AF	EUR_AF	SAS_AF

eafFile <- rawFile
eafFile$EAS_AF <- rawFile$EAS_AF - ((rawFile$AMR_AF + rawFile$AFR_AF + rawFile$EUR_AF + rawFile$SAS_AF)/4)
eafFile$EAS_AF <- rawFile$AMR_AF - ((rawFile$EAS_AF + rawFile$AFR_AF + rawFile$EUR_AF + rawFile$SAS_AF)/4)
eafFile$EAS_AF <- rawFile$AFR_AF - ((rawFile$AMR_AF + rawFile$EAS_AF + rawFile$EUR_AF + rawFile$SAS_AF)/4)
eafFile$EAS_AF <- rawFile$EUR_AF - ((rawFile$AMR_AF + rawFile$AFR_AF + rawFile$EAS_AF + rawFile$SAS_AF)/4)
eafFile$EAS_AF <- rawFile$SAS_AF - ((rawFile$AMR_AF + rawFile$AFR_AF + rawFile$EUR_AF + rawFile$EAS_AF)/4)
write.table(eafFile, here("processed-data/1000_Genomes_EAF.tsv"), sep = "\t", col.names = TRUE, row.names = FALSE)
head(eafFile)
head(rawFile)

## small test to make sure we are getting expected value here ## 
