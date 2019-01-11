library(tidyverse)

# otu_RPMC <- read.csv() 

RPMC_file_path <- "//INHS-Bison/ResearchData/Groups/Kaskaskia CREP/Invert_Analysis/CREP_Invert_Species_Matrix_LEH_RPMC.csv"
otu_RPMC <- tibble::as_tibble(read.csv(RPMC_file_path, header = T, na = c("NA",".")))

 df <- otu_RPMC %>% filter(OTU_Suggestion != "REMOVE")

RPMC_summary <-  df%>%
   dplyr::group_by(OTU_Suggestion) %>%
   dplyr::summarise(OTU_Abundance=sum(Total_Abundance),
            Resolution_Level =unique(OTU_Level),
            Kingdom =unique(Kingdom),
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

