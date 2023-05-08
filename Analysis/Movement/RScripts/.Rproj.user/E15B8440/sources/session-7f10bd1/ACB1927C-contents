
library(tidyverse)
library(sf)
#use number 32 (Agulhas) and 41 (East Central Australian Shelf)

LatLon <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"

Figure_path <- "../Figures"
library(mregions)
#########
#Functions
getSumHarvestLME <- function(BOATSDat, lmes, CurrentLME) {
  BOATSDat <- BOATSDat %>%
    na.omit() %>%
    dplyr::filter(lat < 0) %>%
    dplyr::mutate(lon = case_when(lon > 180 ~ lon -360,
                                  lon < 180 ~ lon)) %>%
    sf::st_as_sf(coords = c("lon", "lat"), crs = LatLon) 
  
  currLME <- lmes %>%
    dplyr::filter(lme_name == CurrentLME)
  
  BOATScurrLME <- st_intersection(BOATSDat, currLME) %>%
    dplyr::select(harvest, year) 
  
  sumBOATS <- BOATScurrLME %>%
    group_by(year) %>% 
    summarise(tonnes_year=sum(harvest),
              .groups = 'drop') %>%
    dplyr::filter(year <= 204 & year > 106) #1950 - 2020 based on catch peak in year 179 that dates to year 1995
    #dplyr::filter(year <= 218 & year > 120) #1950 - 2020 based on catch peak in year 193 that dates to year 1995
  
  return(sumBOATS)
}

plotRegionHarvest <- function(long) {
  p <- ggplot(long,aes(year,value, group=movement)) +
    geom_line(aes(color = movement)) +
    labs(x="Model year", y=parse(text='Harvest~(twB~yr^-1)'),
         colour = " ") +
    scale_colour_manual(values = c("#0072BD", "#EDB120"), 
                        labels=c("no movement","movement")) +
    theme_bw() +
    theme(
      plot.title = element_text(size=12, colour = "black"),
      legend.background = element_blank(),
      legend.text = element_text(size = 12, colour = "black"),
      legend.title = element_text(size = 12, colour = "black"),
      axis.title = element_text(size = 12, colour = "black"),
      axis.text.y = element_text(size = 12, colour = "black"),
      axis.text.x = element_text(size = 12, colour = "black"))
      
      return(p)
}

plotSAUDat <- function(sauDat) {
  p <- ggplot(data=sauDat, aes(x=year, y=tonnes_year, group=1)) +
    geom_line() +    
    labs(x="Year", y="Catch (t)",
         colour = " ") +
    theme_bw() +
    theme(
      plot.title = element_text(size=12, colour = "black"),
      legend.background = element_blank(),
      legend.text = element_text(size = 12, colour = "black"),
      legend.title = element_text(size = 12, colour = "black"),
      axis.title = element_text(size = 12, colour = "black"),
      axis.text.y = element_text(size = 12, colour = "black"),
      axis.text.x = element_text(size = 12, colour = "black"))
  
  return(p)
}
###########

lmes <- mregions::mr_shp(key = "MarineRegions:lme") %>%
  sf::st_as_sf(crs = LatLon) 

BOATSLMEm1 <- read_csv("~/Github/ThesisSandra/Analysis/Movement/Data/SAU/BOATSLMEHarvestm1.csv", 
                       col_names = c("lon", "lat", "harvest", "year"))

sumBOATSm1Ag <- getSumHarvestLME(BOATSDat = BOATSLMEm1, lmes, CurrentLME = "Agulhas Current") %>% 
  st_drop_geometry()%>%
  dplyr::rename(tonnes1 = tonnes_year)
sumBOATSm1ECAS <- getSumHarvestLME(BOATSDat = BOATSLMEm1, lmes, CurrentLME = "East Central Australian Shelf")  %>% 
  st_drop_geometry()%>%
  dplyr::rename(tonnes1 = tonnes_year)
sumBOATSm1P <- getSumHarvestLME(BOATSDat = BOATSLMEm1, lmes, CurrentLME = "Patagonian Shelf")  %>% 
  st_drop_geometry()%>%
  dplyr::rename(tonnes1 = tonnes_year)


BOATSLMEm0 <- read_csv("~/Github/ThesisSandra/Analysis/Movement/Data/SAU/BOATSLMEHarvestm0.csv", 
                       col_names = c("lon", "lat", "harvest", "year"))

sumBOATSm0Ag <- getSumHarvestLME(BOATSDat = BOATSLMEm0, lmes, CurrentLME = "Agulhas Current") %>% 
  st_drop_geometry() %>%
  dplyr::rename(tonnes0 = tonnes_year)
sumBOATSm0ECAS <- getSumHarvestLME(BOATSDat = BOATSLMEm0, lmes, CurrentLME = "East Central Australian Shelf")%>% 
  st_drop_geometry() %>%
  dplyr::rename(tonnes0 = tonnes_year)
sumBOATSm0P <- getSumHarvestLME(BOATSDat = BOATSLMEm0, lmes, CurrentLME = "Patagonian Shelf") %>% 
  st_drop_geometry() %>%
  dplyr::rename(tonnes0 = tonnes_year)

long <- merge(sumBOATSm1Ag, sumBOATSm0Ag, by = "year")  %>% 
  pivot_longer(
    cols = tonnes1:tonnes0, 
    names_to = "movement",
    values_to = "value"
  ) 

ggAg <- plotRegionHarvest(long) +
  ggtitle( "Agulhas Current \n(BOATS simulation)")

ggsave(plot = ggAg,
       filename = file.path(Figure_path, paste0("HarvestPeakAgulhas.png")),
       width = 6, height = 6, dpi = 200)
 
###############
long <- merge(sumBOATSm1ECAS, sumBOATSm0ECAS, by = "year")  %>% 
  pivot_longer(
    cols = tonnes1:tonnes0, 
    names_to = "movement",
    values_to = "value"
  ) 

ggECAS <- plotRegionHarvest(long) +
  ggtitle("East Central Australian Shelf \n(BOATS simulation)")

ggsave(plot = ggECAS,
       filename = file.path(Figure_path, paste0("HarvestPeakECAS.png")),
       width = 6, height = 6, dpi = 200)

####
long <- merge(sumBOATSm1P, sumBOATSm0P, by = "year")  %>% 
  pivot_longer(
    cols = tonnes1:tonnes0, 
    names_to = "movement",
    values_to = "value"
  ) 

ggP <- plotRegionHarvest(long) +
  ggtitle("Patagonian Shelf \n(BOATS simulation)")
# 
ggsave(plot = ggP,
       filename = file.path(Figure_path, paste0("HarvestPeakPatagonia.png")),
       width = 6, height = 6, dpi = 200)


library(patchwork)
#add three SAU data plots in row 1 and 3 BOATS predicted harvest plots in row 2
pComb <- (ggAg + ggECAS + ggP) +
  plot_layout(guides = "collect", widths = c(1, 1, 1)) +
  plot_annotation(tag_levels = "A") 

ggsave(plot = pComb,
       filename = file.path(Figure_path, paste0("combinedRegionalPeaks.png")),
       width = 12, height = 5, dpi = 400) 

########## SAU data
sauDat30 <- read_csv("~/Github/ThesisSandra/Analysis/Movement/Data/SAU/SAU LME 30 v50-0.csv") %>%
  dplyr::select(area_name, year, tonnes) %>% #, landed_value
  na.omit() %>%
  group_by(year) %>% 
  summarise(tonnes_year=sum(tonnes),
            .groups = 'drop') #Agulhas

ggAgSAU <- plotSAUDat(sauDat30)+
  ggtitle("Agulhas Current (SAU)")

# ggplot(data=sauDat30, aes(x=year, y=tonnes_year, group=1)) +
#   geom_line() +    
#   labs(x="Year", y="Catch (t)",
#                         colour = " ") +
#   theme_bw() +
#   theme(
#     plot.title = element_text(size=12, colour = "black"),
#     legend.background = element_blank(),
#     legend.text = element_text(size = 12, colour = "black"),
#     legend.title = element_text(size = 12, colour = "black"),
#     axis.title = element_text(size = 12, colour = "black"),
#     axis.text.y = element_text(size = 12, colour = "black"),
#     axis.text.x = element_text(size = 12, colour = "black"))

sauDat41 <- read_csv("~/Github/ThesisSandra/Analysis/Movement/Data/SAU/SAU LME 41 v50-0.csv") %>%
  dplyr::select(area_name, year, tonnes) %>% #, landed_value
  na.omit() %>%
  group_by(year) %>% 
  summarise(tonnes_year=sum(tonnes),
            .groups = 'drop') #ECAS

ggECASSAU <- plotSAUDat(sauDat41)+
  ggtitle("East Central Australian Shelf (SAU)")


sauDat14 <- read_csv("~/Github/ThesisSandra/Analysis/Movement/Data/SAU/SAU LME 14 v50-0.csv") %>%
  dplyr::select(area_name, year, tonnes) %>% #, landed_value
  na.omit() %>%
  group_by(year) %>% 
  summarise(tonnes_year=sum(tonnes),
            .groups = 'drop') #ECAS

ggPSAU <- plotSAUDat(sauDat14)+
  ggtitle("Patagonian Shelf (SAU)")


pComb2 <- ((ggAg + ggECAS + ggP) / (ggAgSAU + ggECASSAU + ggPSAU)) +
  plot_layout(guides = "collect", widths = c(1, 1, 1)) +
  plot_annotation(tag_levels = "A") 

ggsave(plot = pComb2,
       filename = file.path(Figure_path, paste0("combinedRegionalPeaksWithSAU.png")),
       width = 12, height = 5, dpi = 400) 
