library(tidyverse)

# otu_RPMC <- read.csv() 

# RPMC_file_path <- "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Invert_Analysis/CREP_Invert_Species_Matrix_LEH_RPMC.csv"
# L_RPMC_file_path <- "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Invert_Analysis/CREP_Invert_Species_Matrix_LEH_RPMC_LarvaeOnly.csv"
OTU_file_path <- "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Invert_Analysis/CREP_Invert_Species_Matrix_OTU.csv"
  
# otu_RPMC <- tibble::as_tibble(read.csv(RPMC_file_path, header = T, na = c("NA",".")))
# otu_RPMC_L <- tibble::as_tibble(read.csv(L_RPMC_file_path, header = T, na = c("NA",".")))
otu<- tibble::as_tibble(read.csv(OTU_file_path, header = T, na = c("NA",".")))
######### RPMC All Life Stages
df <- otu %>% filter(OTU_Suggestion != "REMOVE")

otu_summary <-  df%>%
   dplyr::group_by(OTU_Suggestion) %>%
   dplyr::summarise(OTU_Abundance=sum(Total_Abundance),
            Resolution_Level =unique(OTU_Level),
            # Kingdom =unique(Kingdom),
            # Phylum =unique(Phylum),
            # Subphylum =unique(Subphylum),
            # Class =unique(Class),
            # Subclass =unique(Subclass),
            # Subclass =unique(Subclass),
            # Infraclass =unique(Infraclass),
            # Superorder =unique(Superorder),
            # Order =unique(Order),
            # Suborder =unique(Suborder),
            # Infraorder =unique(Infraorder),
            # Superfamily =unique(Superfamily),
            # Family =unique(Family),
            # Subfamily =unique(Subfamily),
            # Tribe =unique(Tribe),
            # Subtribe =unique(Subtribe),
            # Genus =unique(Genus),
            # Subgenus =unique(Subgenus),
            # Species =unique(Species),
            )

otu_summary$OTU_Code <- ifelse(str_detect(otu_summary$OTU_Suggestion, "[:punct:]|[:blank:]"), 
                               paste(toupper(str_sub(otu_summary$OTU_Suggestion, 1, 4)), toupper(str_sub(str_extract(otu_summary$OTU_Suggestion,"(?<=[:punct:]|[:blank:])[:alpha:]+"),1,4)), sep = ""), 
                               ifelse(str_detect(otu_summary$OTU_Suggestion, "[a-z]{7,}"), 
                                      paste(toupper(str_sub(otu_summary$OTU_Suggestion, 1, 8))),
                                      paste(toupper(str_sub(otu_summary$OTU_Suggestion, 1, 4)), "2019", sep = "")     
                                      )
                                )
## Test to verify the OTU codes are unique for each OTU taxon
# nd <- data.frame(table(otu_summary$OTU_Code))
# nd[nd$Freq> 1,]
##data.frame[row_number, column_number] = new_value
otu_summary[199,4]="STEMELLA"
otu_summary[198,4]="STEMLINA"

otu_summary$OTU_SN <- paste("2019",str_pad(seq.int(from =  1, to = nrow(otu_summary) ),3,pad = "0"), sep = "")

###### Summary of the OTU Resolution

df_num <- aggregate(OTU_Abundance~Resolution_Level,otu_summary,length)
names(df_num)[2] <- "Frequency"
df_sum <- aggregate(OTU_Abundance~Resolution_Level,otu_summary,sum)
names(df_sum)[2] <- "Total_Abundance"

resolution_sum<- merge(df_num, df_sum) 
resolution_sum$Percent_Abundance <- round(resolution_sum$Total_Abundance/sum(resolution_sum$Total_Abundance)*100, digits = 2)

######### Summary of how the Abundance and Total Unique Taxa have changed in each OTU step

#Total Abundance
# x <- sum(otu_RPMC$Total_Abundance)
# xx <- sum(otu_RPMC_L$Total_Abundance)
# y <- sum(Summary_OTU$Total_Abundance)
# z <- sum(Summary_OTU_Larvae$Total_Abundance)

x <- 65322
xx <-63037
z <- 61129
ZZ <- sum(otu_summary$OTU_Abundance)


#Number of unique taxon
# a <-otu_RPMC %>% summarise(count=n())
# b <-RPMC_summary %>% summarize(count=n())
# c <- L_RPMC_summary %>% summarize(count=n())
# aa<- otu_RPMC_L %>% summarise(count=n())

A <- 351
AA <- 331
C <- 248
D <- 223

OTU_Methods<- matrix(c(x,xx,z,ZZ,A,AA,C,D), ncol = 2, byrow = F)
colnames(OTU_Methods) <- c("Abundance","Unique_Taxa")
rownames(OTU_Methods) <- c("Raw", "Larvae_Only", "OTU_via_RPMC", "OTU_via_RPMC_Extra_Rules")
OTU_Methods <- as.data.frame(OTU_Methods)

library(xlsx)
write.xlsx(otu_summary, file = "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Invert_Analysis/CREP_OTU_Summary.xlsx", sheetName = "OTU_Summary", col.names = T, append = F, showNA = F)
write.xlsx(resolution_sum, file = "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Invert_Analysis/CREP_OTU_Summary.xlsx", sheetName = "Resolution", col.names = T, append = T, showNA = F)
write.xlsx(OTU_Methods, file = "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Invert_Analysis/CREP_OTU_Summary.xlsx", sheetName = "OTU_Methods", col.names = T, append = T, showNA = F)
