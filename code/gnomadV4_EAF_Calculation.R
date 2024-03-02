## EAF CALCULATION FOR GNOMADV4 ## 
library(stringr)
library(tibble)
require(readr)  # for read_csv()
require(dplyr) #data frame handling 
library(tidyr)
library(here)
library(testthat)
library("optparse") # command line arguments 

option_list <- list(
  make_option(c("-c", "--chromosome"), type="character", default=NULL, 
              help="Current chromosome file", metavar="character")
); 
opt_parser <- OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

chr <- opt$chromosome
#rawFile <- readr::read_tsv(here("processed-data/","chr.head"))

#rawFile <- readr::read_tsv(here("processed-data", "chromosome_head_value.head"))
rawFile <- readr::read_tsv(here("processed-data","gnomADv4","parsed",chr))
#, "gnomADv4"
#[1] "CHROM"               "POS"                 "RSID"                "REF"                 "ALT"                 "AFR_AC"              "AFR_AN"              "AFR_AF"             
#[9] "AMR_AC"              "AMR_AN"              "AMR_AF"              "AMI_AC"              "AMI_AN"              "AMI_AF"              "ASJ_AC"              "ASJ_AN"             
#[17] "ASJ_AF"              "EAS_AC"              "EAS_AN"              "EAS_AF"              "FIN_AC"              "FIN_AN"              "FIN_AF"              "MID_AC"             
#[25] "MID_AN"              "MID_AF"              "NFE_AC"              "NFE_AN"              "NFE_AF"              "SAS_AC"              "SAS_AN"              "SAS_AF"             
#[33] "CADD_PHRED"          "REVEL_MAX"           "SPLICEAI_DS_MAX"     "PANGOLIN_LARGEST_DS" "PHYLOP"              "SIFT_MAX"            "POLYPHEN_MAX"        "VEP_VAL"        


#AFR AMR AMI ASJ EAS FIN MID NFE SAS 
eafFile <- rawFile

eafFile <- eafFile %>% dplyr::select(CHROM, POS, RSID, REF, ALT, AFR_AF, AMR_AF, AMI_AF, ASJ_AF, EAS_AF, FIN_AF, MID_AF, NFE_AF, SAS_AF, VEP_VAL)
print("Selection Complete")
eafFile$AFR_AF <- rawFile$AFR_AF - ((rawFile$AMR_AF + rawFile$AMI_AF + rawFile$ASJ_AF + rawFile$EAS_AF + rawFile$FIN_AF + rawFile$MID_AF + rawFile$NFE_AF + rawFile$SAS_AF)/8)
eafFile$AMR_AF <- rawFile$AMR_AF - ((rawFile$AFR_AF + rawFile$AMI_AF + rawFile$ASJ_AF + rawFile$EAS_AF + rawFile$FIN_AF + rawFile$MID_AF + rawFile$NFE_AF + rawFile$SAS_AF)/8)
eafFile$AMI_AF <- rawFile$AMI_AF - ((rawFile$AFR_AF + rawFile$AMR_AF + rawFile$ASJ_AF + rawFile$EAS_AF + rawFile$FIN_AF + rawFile$MID_AF + rawFile$NFE_AF + rawFile$SAS_AF)/8)
eafFile$ASJ_AF <- rawFile$ASJ_AF - ((rawFile$AFR_AF + rawFile$AMR_AF + rawFile$AMI_AF + rawFile$EAS_AF + rawFile$FIN_AF + rawFile$MID_AF + rawFile$NFE_AF + rawFile$SAS_AF)/8)
eafFile$EAS_AF <- rawFile$EAS_AF - ((rawFile$AFR_AF + rawFile$AMR_AF + rawFile$AMI_AF + rawFile$ASJ_AF + rawFile$FIN_AF + rawFile$MID_AF + rawFile$NFE_AF + rawFile$SAS_AF)/8)
eafFile$FIN_AF <- rawFile$FIN_AF - ((rawFile$AFR_AF + rawFile$AMR_AF + rawFile$AMI_AF + rawFile$ASJ_AF + rawFile$EAS_AF + rawFile$MID_AF + rawFile$NFE_AF + rawFile$SAS_AF)/8)
eafFile$MID_AF <- rawFile$MID_AF - ((rawFile$AFR_AF + rawFile$AMR_AF + rawFile$AMI_AF + rawFile$ASJ_AF + rawFile$EAS_AF + rawFile$FIN_AF + rawFile$NFE_AF + rawFile$SAS_AF)/8)
eafFile$NFE_AF <- rawFile$NFE_AF - ((rawFile$AFR_AF + rawFile$AMR_AF + rawFile$AMI_AF + rawFile$ASJ_AF + rawFile$EAS_AF + rawFile$FIN_AF + rawFile$MID_AF + rawFile$SAS_AF)/8)
eafFile$SAS_AF <- rawFile$SAS_AF - ((rawFile$AFR_AF + rawFile$AMR_AF + rawFile$AMI_AF + rawFile$ASJ_AF + rawFile$EAS_AF + rawFile$FIN_AF + rawFile$MID_AF + rawFile$NFE_AF)/8)
colnames(eafFile) <- c("CHROM", "POS","RSID","REF","ALT","AFR_EAF", "AMR_EAF", "AMI_EAF", "ASJ_EAF","EAS_EAF", "FIN_EAF","MID_EAF","NFE_EAF", "SAS_EAF","VEP_VAL")
file_name <- paste0(str_sub(chr, end=-13),"EAF.tsv")
print("EAF calculation and file name creation complete")
write.table(eafFile, here("processed-data","gnomADv4",file_name), sep = "\t", col.names = TRUE, row.names = FALSE)
