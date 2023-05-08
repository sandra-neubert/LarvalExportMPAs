library(stringr)
library(tidyverse)
library(sf)
library(openxlsx)

Data_path <- "../Data/ChangesMoveNH"

LatLon <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"

library(mregions)
lmes <- mregions::mr_shp(key = "MarineRegions:lme") %>%
  dplyr::filter(lme_name != "Black Sea" & lme_name != "Central Arctic" & lme_name != "Canadian High Arctic - North Greenland") %>%
  sf::st_as_sf(crs = LatLon) 

ROI <- lmes$lme_name

getSummary <- function(BOATSDat, ROI, lmes, decimalDigit, logAnswer) {
  SummaryDF<- data.frame() #save probs
  for (i in 1:length(ROI)) {
    print(i)
    currLME <- lmes %>%
      dplyr::filter(lme_name == ROI[i]) %>%
      st_make_valid()
    
    roiName <- as.data.frame(ROI[i])
    
    BOATSLME <- st_intersection(BOATSDat, currLME) %>%
      dplyr::select(change)
    
    currSum <- BOATSLME %>%
      as.data.frame() %>%
      dplyr::select(change) %>%
      summarise_all(list(~ str_c(format(round(median(change), digits = decimalDigit), scientific = logAnswer),
                                 " (", format(round(sd(change), digits = decimalDigit), scientific = logAnswer), ")")))
    
    
    if (i == 1){
      SummaryDF <- currSum
    } else {
      SummaryDF <- rbind(SummaryDF, currSum)
    }
  }
  
  # SummaryDF <- SummaryDF %>%
  #   dplyr::rename(LME = `ROI[i]`, Max = `format(round(max(BOATSLME$change), digits = decimalDigit), scientific = logAnswer)`,
  #                 Min = `format(round(min(BOATSLME$change), digits = decimalDigit), scientific = logAnswer)`,
  #                 Mean = `format(round(mean(BOATSLME$change), digits = decimalDigit), scientific = logAnswer)`,
  #                 Median = `format(round(median(BOATSLME$change), digits = decimalDigit), scientific = logAnswer)`,
  #                 SD = `format(round(sd(BOATSLME$change), digits = decimalDigit), scientific = logAnswer)`) %>%
  #   dplyr::select(LME, Mean, SD)
  
  return(SummaryDF)
}

PCB <- read_csv(file.path(Data_path, "PCB.csv"), 
                col_names = c("lon", "lat", "change")) %>%
  na.omit() %>%
  dplyr::mutate(lon = case_when(lon > 180 ~ lon -360,
                                lon < 180 ~ lon)) %>%
  sf::st_as_sf(coords = c("lon", "lat"), crs = LatLon) 

PCBSummary <- getSummary(PCB, ROI, lmes, decimalDigit = 2, logAnswer = FALSE)%>%
  dplyr::mutate(LME = ROI) %>%
  dplyr::rename(MedianPercentageFishChange = change)


PCEgg <- read_csv(file.path(Data_path, "PCEggs.csv"), 
                  col_names = c("lon", "lat", "change")) %>%
  na.omit() %>%
  dplyr::mutate(lon = case_when(lon > 180 ~ lon -360,
                                lon < 180 ~ lon)) %>%
  sf::st_as_sf(coords = c("lon", "lat"), crs = LatLon) 

PCEggSummary <- getSummary(PCEgg, ROI, lmes, decimalDigit = 2, logAnswer = FALSE)%>%
  dplyr::mutate(LME = ROI) %>%
  dplyr::rename(MedianPercentageEggChange = change)


DiffB <- read_csv(file.path(Data_path, "DiffB.csv"), 
                  col_names = c("lon", "lat", "change")) %>%
  na.omit() %>%
  dplyr::mutate(lon = case_when(lon > 180 ~ lon -360,
                                lon < 180 ~ lon)) %>%
  sf::st_as_sf(coords = c("lon", "lat"), crs = LatLon) 

DiffBSummary <- getSummary(DiffB, ROI, lmes, decimalDigit = 2, logAnswer = FALSE) %>%
  dplyr::mutate(LME = ROI) %>%
  dplyr::rename(MedianTotalFishChange = change)


DiffEgg <- read_csv(file.path(Data_path, "DiffEggs.csv"), 
                    col_names = c("lon", "lat", "change")) %>%
  na.omit() %>%
  dplyr::mutate(lon = case_when(lon > 180 ~ lon -360,
                                lon < 180 ~ lon)) %>%
  sf::st_as_sf(coords = c("lon", "lat"), crs = LatLon) 

DiffEggSummary <- getSummary(DiffEgg, ROI, lmes, decimalDigit = 7, logAnswer = TRUE)%>%
  dplyr::mutate(LME = ROI) %>%
  dplyr::rename(MedianTotalEggChange = change)


df_list <- list(DiffEggSummary, PCEggSummary, DiffBSummary, PCBSummary)
combNHChanges <- df_list %>%
  reduce(full_join, by='LME')

combNHChanges <- combNHChanges[, c(2,1,3,4,5)] %>%
  arrange(LME)

write.csv(combNHChanges, file.path(Data_path, "combNHChangesMedian.csv"), row.names=FALSE)
write.xlsx(combNHChanges, file.path(Data_path, "combNHChangesMedian.xlsx"))

library(gt)


library(kableExtra)
kable(combNHChanges) %>% 
  kable_styling(latex_options = 'striped', full_width = F) %>%
  #as_image()  %>%
  save_kable(file.path(Data_path, "combNHChanges2.png"))

library("gridExtra")
pdf(file.path(Data_path, "combNHChanges.pdf"))       # Export PDF
grid.table(combNHChanges)
dev.off()