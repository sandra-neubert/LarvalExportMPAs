library(tidyverse)
library(sf)

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
    
    maxLme <- as.data.frame(format(round(max(BOATSLME$change), digits = decimalDigit), scientific = logAnswer))
    minLme <- as.data.frame(format(round(min(BOATSLME$change), digits = decimalDigit), scientific = logAnswer))
    meanLme <- as.data.frame(format(round(mean(BOATSLME$change), digits = decimalDigit), scientific = logAnswer))
    medianLme <- as.data.frame(format(round(median(BOATSLME$change), digits = decimalDigit), scientific = logAnswer))
    sdLme <- as.data.frame(format(round(sd(BOATSLME$change), digits = decimalDigit), scientific = logAnswer))
    
    combCols <- cbind(roiName, maxLme, minLme, meanLme, medianLme, sdLme)
    
    if (i == 1){
      SummaryDF <- combCols
    } else {
      SummaryDF <- rbind(SummaryDF, combCols)
    }
  }
  
  SummaryDF <- SummaryDF %>%
    dplyr::rename(LME = `ROI[i]`, Max = `format(round(max(BOATSLME$change), digits = decimalDigit), scientific = logAnswer)`,
                  Min = `format(round(min(BOATSLME$change), digits = decimalDigit), scientific = logAnswer)`,
                  Mean = `format(round(mean(BOATSLME$change), digits = decimalDigit), scientific = logAnswer)`,
                  Median = `format(round(median(BOATSLME$change), digits = decimalDigit), scientific = logAnswer)`,
                  SD = `format(round(sd(BOATSLME$change), digits = decimalDigit), scientific = logAnswer)`) #%>%
    #dplyr::select(LME, Mean, SD)

  return(SummaryDF)
}

PCB <- read_csv(file.path(Data_path, "PCB.csv"), 
                col_names = c("lon", "lat", "change")) %>%
  na.omit() %>%
  dplyr::mutate(lon = case_when(lon > 180 ~ lon -360,
                                lon < 180 ~ lon)) %>%
  sf::st_as_sf(coords = c("lon", "lat"), crs = LatLon) 

PCBSummary <- getSummary(PCB, ROI, lmes, decimalDigit = 2, logAnswer = FALSE)
#write.csv(PCBSummary, file.path(Data_path, "PCBSummary.csv"), row.names=FALSE)

PCEgg <- read_csv(file.path(Data_path, "PCEggs.csv"), 
                col_names = c("lon", "lat", "change")) %>%
  na.omit() %>%
  dplyr::mutate(lon = case_when(lon > 180 ~ lon -360,
                                lon < 180 ~ lon)) %>%
  sf::st_as_sf(coords = c("lon", "lat"), crs = LatLon) 

PCEggSummary <- getSummary(PCEgg, ROI, lmes, decimalDigit = 2, logAnswer = FALSE)
#write.csv(PCEggSummary, file.path(Data_path, "PCEggSummary.csv"), row.names=FALSE)


DiffB <- read_csv(file.path(Data_path, "DiffB.csv"), 
                    col_names = c("lon", "lat", "change")) %>%
  na.omit() %>%
  dplyr::mutate(lon = case_when(lon > 180 ~ lon -360,
                                lon < 180 ~ lon)) %>%
  sf::st_as_sf(coords = c("lon", "lat"), crs = LatLon) 

DiffBSummary <- getSummary(DiffB, ROI, lmes, decimalDigit = 5, logAnswer = FALSE)
#write.csv(DiffBSummary, file.path(Data_path, "DiffBSummary.csv"), row.names=FALSE)



DiffEgg <- read_csv(file.path(Data_path, "DiffEggs.csv"), 
                  col_names = c("lon", "lat", "change")) %>%
  na.omit() %>%
  dplyr::mutate(lon = case_when(lon > 180 ~ lon -360,
                                lon < 180 ~ lon)) %>%
  sf::st_as_sf(coords = c("lon", "lat"), crs = LatLon) 

DiffEggSummary <- getSummary(DiffEgg, ROI, lmes, decimalDigit = 7, logAnswer = TRUE)
#write.csv(DiffEggSummary, file.path(Data_path, "DiffEggSummary.csv"), row.names=FALSE)



DiffEggSummary <- DiffEggSummary %>%
  dplyr:: rename(MeanDifferenceEggs = Mean, SDDifferenceEggs = SD)

DiffBSummary <- DiffBSummary %>%
  dplyr:: rename(MeanDifferenceFish = Mean, SDDifferenceFish = SD)

PCEggSummary <- PCEggSummary %>%
  dplyr:: rename(MeanPCEggs = Mean, SDPCEggs = SD)

PCBSummary <- PCBSummary %>%
  dplyr:: rename(MeanPCFish = Mean, SDPCFish = SD)


df_list <- list(DiffEggSummary, PCEggSummary, DiffBSummary, PCBSummary)
combNHChanges <- df_list %>%
  reduce(full_join, by='LME')

combNHChanges <- combNHChanges %>%
  arrange(LME)

test1 <- as.numeric(PCEggSummary$Median)
test2 <- as.numeric(PCBSummary$Median)
test3 <- test1/test2
median(test3)
mean(test3)

test4 <- test2/test1
mean(test4)

write.csv(combNHChanges, file.path(Data_path, "combNHChangesSepCols.csv"), row.names=FALSE)
write.xlsx(combNHChanges, file.path(Data_path, "combNHChangesSepCols.xlsx"))

ggplot(data = BOATSAgulhas) +
  geom_sf(aes(color = change), size = 2)

ggplot(data = currLME) +
  geom_sf()

ggplot(data = PCB) +
  geom_sf(aes(color = change), size = 2)
