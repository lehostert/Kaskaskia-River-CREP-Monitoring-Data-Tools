library(tidyverse)

# otu_RPMC <- read.csv() 

RPMC_file_path <- "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Invert_Analysis/CREP_Invert_Species_Matrix_LEH_RPMC.csv"
L_RPMC_file_path <- "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Invert_Analysis/CREP_Invert_Species_Matrix_LEH_RPMC_LarvaeOnly.csv"
  
otu_RPMC <- tibble::as_tibble(read.csv(RPMC_file_path, header = T, na = c("NA",".")))
otu_RPMC_L <- tibble::as_tibble(read.csv(L_RPMC_file_path, header = T, na = c("NA",".")))

######### RPMC All Life Stages
df <- otu_RPMC %>% filter(OTU_Suggestion != "REMOVE")

RPMC_summary <-  df%>%
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

df_num <- aggregate(OTU_Abundance~Resolution_Level,RPMC_summary,length)
names(df_num)[2] <- "Frequency"
df_sum <- aggregate(OTU_Abundance~Resolution_Level,RPMC_summary,sum)
names(df_sum)[2] <- "Total_Abundance"

Summary_OTU <- merge(df_num, df_sum) 
Summary_OTU$Percent_Abundance <- round(Summary_OTU$Total_Abundance/sum(Summary_OTU$Total_Abundance)*100, digits = 2)

######### RPMC Larvae
df2 <- otu_RPMC_L %>% filter(OTU_Suggestion != "REMOVE")

L_RPMC_summary <-  df2 %>%
  dplyr::group_by(OTU_Suggestion) %>%
  dplyr::summarise(OTU_Abundance=sum(Total_Abundance),
                   Resolution_Level =unique(OTU_Level),
                   Kingdom =unique(Kingdom),
                   Phylum =unique(Phylum),
                   Subphylum =unique(Subphylum),
                   Class =unique(Class),
                   Subclass =unique(Subclass),
                   Subclass =unique(Subclass),
                   Infraclass =unique(Infraclass),
                   Superorder =unique(Superorder),
                   Order =unique(Order),
                   Suborder =unique(Suborder),
                   Infraorder =unique(Infraorder),
                   Superfamily =unique(Superfamily),
                   Family =unique(Family),
                   Subfamily =unique(Subfamily),
                   Tribe =unique(Tribe),
                   Subtribe =unique(Subtribe),
                   # Genus =unique(Genus),
                   # Subgenus =unique(Subgenus),
                   # Species =unique(Species),
  )

df2_num <- aggregate(OTU_Abundance~Resolution_Level,L_RPMC_summary,length)
names(df2_num)[2] <- "Frequency"
df2_sum <- aggregate(OTU_Abundance~Resolution_Level,L_RPMC_summary,sum)
names(df2_sum)[2] <- "Total_Abundance"

Summary_OTU_Larvae <- merge(df2_num, df2_sum) 
Summary_OTU_Larvae$Percent_Abundance <- round(Summary_OTU_Larvae$Total_Abundance/sum(Summary_OTU_Larvae$Total_Abundance)*100, digits = 2)
#########

x <- sum(otu_RPMC$Total_Abundance)
xx <- sum(otu_RPMC_L$Total_Abundance)
y <- sum(Summary_OTU$Total_Abundance)
z <- sum(Summary_OTU_Larvae$Total_Abundance)

#Number of unique taxon
# a <-otu_RPMC %>% summarise(count=n())
# b <-RPMC_summary %>% summarize(count=n())
# c <- L_RPMC_summary %>% summarize(count=n())
# aa<- otu_RPMC_L %>% summarise(count=n())

A <- 351
AA <- 331
B <- 259
C <- 248

OTU_Methods<- matrix(c(x,xx,y,z,A,AA,B,C), ncol = 2, byrow = F)
colnames(OTU_Methods) <- c("Abundance","Unique_Taxa")
rownames(OTU_Methods) <- c("NONE", "NONE_Larvae_Only", "RPMC", "RPMC_Larvae_Only")
OTU_Methods <- as.table(OTU_Methods)
OTU_Methods

# library(xlsx)
# write.xlsx(OTU_Methods, file = "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Invert_Analysis/CREP_OTU_Summary.xlsx", sheetName = "OTU_Summary", col.names = T, append = F, showNA = F)
# write.xlsx(otu_RPMC, file = "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Invert_Analysis/CREP_OTU_Summary.xlsx", sheetName = "RPKC", col.names = T, row.names = T, append = T, showNA = F)
# write.xlsx(Summary_OTU, file = "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Invert_Analysis/CREP_OTU_Summary.xlsx", sheetName = "RPKC_Summary", col.names = T, append = T, showNA = F)
# write.xlsx(otu_RPMC_L, file = "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Invert_Analysis/CREP_OTU_Summary.xlsx", sheetName = "RPKC_LarvaeOnly", col.names = T, append = T, showNA = F)
# write.xlsx(Summary_OTU_Larvae, file = "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Invert_Analysis/CREP_OTU_Summary.xlsx", sheetName = "RPKC_LarvaeOnly_Summary", col.names = T, append = T, showNA = F)
