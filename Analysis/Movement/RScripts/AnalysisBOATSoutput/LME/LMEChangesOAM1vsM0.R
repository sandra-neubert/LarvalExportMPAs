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

PCB <- read_csv(file.path(Data_path, "PCB_OA.csv"), 
                col_names = c("lon", "lat", "change")) %>%
  na.omit() %>%
  dplyr::mutate(change = case_when(change > quantile(change, 0.99) ~ quantile(change, 0.99),
                                   change <= quantile(change, 0.99)~ change)) %>%
  dplyr::mutate(lon = case_when(lon > 180 ~ lon -360,
                                lon < 180 ~ lon)) %>%
  sf::st_as_sf(coords = c("lon", "lat"), crs = LatLon) 

PCBSummary <- getSummary(PCB, ROI, lmes, decimalDigit = 2, logAnswer = FALSE)%>%
  dplyr::mutate(LME = ROI) %>%
  dplyr::rename(MedianPercentageFishChange = change)


PCH <- read_csv(file.path(Data_path, "PCH_OA.csv"), 
                  col_names = c("lon", "lat", "change")) %>%
  na.omit() %>%
  dplyr::mutate(change = case_when(change > quantile(change, 0.99) ~ quantile(change, 0.99),
                                   change <= quantile(change, 0.99)~ change)) %>%
  dplyr::mutate(lon = case_when(lon > 180 ~ lon -360,
                                lon < 180 ~ lon)) %>%
  sf::st_as_sf(coords = c("lon", "lat"), crs = LatLon) 

PCHSummary <- getSummary(PCH, ROI, lmes, decimalDigit = 2, logAnswer = FALSE)%>%
  dplyr::mutate(LME = ROI) %>%
  dplyr::rename(MedianPercentageHChange = change)


DiffB <- read_csv(file.path(Data_path, "DiffB_OA.csv"), 
                  col_names = c("lon", "lat", "change")) %>%
  na.omit() %>%
  dplyr::mutate(lon = case_when(lon > 180 ~ lon -360,
                                lon < 180 ~ lon)) %>%
  sf::st_as_sf(coords = c("lon", "lat"), crs = LatLon) 

DiffBSummary <- getSummary(DiffB, ROI, lmes, decimalDigit = 13, logAnswer = TRUE) %>%
  dplyr::mutate(LME = ROI) %>%
  dplyr::rename(MedianTotalFishChange = change)


DiffH <- read_csv(file.path(Data_path, "DiffH_OA.csv"), 
                    col_names = c("lon", "lat", "change")) %>%
  na.omit() %>%
  dplyr::mutate(lon = case_when(lon > 180 ~ lon -360,
                                lon < 180 ~ lon)) %>%
  sf::st_as_sf(coords = c("lon", "lat"), crs = LatLon) 

DiffHSummary <- getSummary(DiffH, ROI, lmes, decimalDigit = 13, logAnswer = TRUE)%>%
  dplyr::mutate(LME = ROI) %>%
  dplyr::rename(MedianTotalHChange = change)


df_list <- list(DiffHSummary, PCHSummary, DiffBSummary, PCBSummary)
combOAChanges <- df_list %>%
  reduce(full_join, by='LME')

combOAChanges <- combOAChanges[, c(2,1,3,4,5)] %>%
  arrange(LME)

write.csv(combOAChanges, file.path(Data_path, "combOAChangesMedian.csv"), row.names=FALSE)
write.xlsx(combOAChanges, file.path(Data_path, "combOAChangesMedian.xlsx"))
