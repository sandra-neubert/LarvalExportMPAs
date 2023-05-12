#Sandra Neubert
#Harvest Peaks of highest change areas after BOATS results
#movement vs no-movement

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
    #dplyr::filter(lat < 0) %>%
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
    #dplyr::filter(year <= 204 & year > 106) #1950 - 2020 based on catch peak in year 179 that dates to year 1995
    dplyr::filter(year > 128)%>%#(year <= 218 & year > 110) #1950 - 2020 based on catch peak in year 193 that dates to year 1995
    dplyr::mutate(year = year +1802)
  
  return(sumBOATS)
}

plotRegionHarvest <- function(long) {
  p <- ggplot(long,aes(year,value, group=movement)) +
    geom_line(aes(color = movement)) +
    labs(x="Years", y=parse(text='Harvest~(twB~yr^-1)'),
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


lmes <- mregions::mr_shp(key = "MarineRegions:lme") %>%
  sf::st_as_sf(crs = LatLon) 

BOATSLMEm1 <- read_csv("~/Github/ThesisSandra/Analysis/Movement/Data/SAU/BOATSLMEHarvestm1.csv", 
                       col_names = c("lon", "lat", "harvest", "year"))

sumBOATSm1NB <- getSumHarvestLME(BOATSDat = BOATSLMEm1, lmes, CurrentLME = "North Brazil Shelf") %>% 
  st_drop_geometry()%>%
  dplyr::rename(tonnes1 = tonnes_year)
gc()
gc()
sumBOATSm1Sulu <- getSumHarvestLME(BOATSDat = BOATSLMEm1, lmes, CurrentLME = "Sulu-Celebes Sea")  %>% 
  st_drop_geometry()%>%
  dplyr::rename(tonnes1 = tonnes_year)
gc()
gc()
sumBOATSm1Scot <- getSumHarvestLME(BOATSDat = BOATSLMEm1, lmes, CurrentLME = "Scotian Shelf")  %>% 
  st_drop_geometry()%>%
  dplyr::rename(tonnes1 = tonnes_year)
gc()
gc()

BOATSLMEm0 <- read_csv("~/Github/ThesisSandra/Analysis/Movement/Data/SAU/BOATSLMEHarvestm0.csv", 
                       col_names = c("lon", "lat", "harvest", "year"))

sumBOATSm0NB <- getSumHarvestLME(BOATSDat = BOATSLMEm0, lmes, CurrentLME = "North Brazil Shelf") %>% 
  st_drop_geometry() %>%
  dplyr::rename(tonnes0 = tonnes_year)
gc()
sumBOATSm0Sulu <- getSumHarvestLME(BOATSDat = BOATSLMEm0, lmes, CurrentLME = "Sulu-Celebes Sea")%>% 
  st_drop_geometry() %>%
  dplyr::rename(tonnes0 = tonnes_year)
gc()
sumBOATSm0Scot <- getSumHarvestLME(BOATSDat = BOATSLMEm0, lmes, CurrentLME = "Scotian Shelf") %>% 
  st_drop_geometry() %>%
  dplyr::rename(tonnes0 = tonnes_year)
gc()

long <- merge(sumBOATSm1NB, sumBOATSm0NB, by = "year")  %>% 
  pivot_longer(
    cols = tonnes1:tonnes0, 
    names_to = "movement",
    values_to = "value"
  ) 

ggNB <- plotRegionHarvest(long) +
  ggtitle( "North Brazil Shelf")

# ggsave(plot = ggNB,
#        filename = file.path(Figure_path, paste0("HarvestPeakNorthBrazil.png")),
#        width = 6, height = 6, dpi = 200)

long <- merge(sumBOATSm1Sulu, sumBOATSm0Sulu, by = "year")  %>% 
  pivot_longer(
    cols = tonnes1:tonnes0, 
    names_to = "movement",
    values_to = "value"
  ) 

ggSulu <- plotRegionHarvest(long) +
  ggtitle( "Sulu-Celebes Sea")

# ggsave(plot = ggSulu,
#        filename = file.path(Figure_path, paste0("HarvestPeakSulu.png")),
#        width = 6, height = 6, dpi = 200)

long <- merge(sumBOATSm1Scot, sumBOATSm0Scot, by = "year")  %>% 
  pivot_longer(
    cols = tonnes1:tonnes0, 
    names_to = "movement",
    values_to = "value"
  ) 

ggScot <- plotRegionHarvest(long) +
  ggtitle( "Scotian Shelf")

# ggsave(plot = ggScot,
#        filename = file.path(Figure_path, paste0("HarvestPeakScotian.png")),
#        width = 6, height = 6, dpi = 200)
library(patchwork)

pComb <- (ggNB + ggSulu + ggScot) +
  plot_layout(guides = "collect", widths = c(1, 1, 1)) +
  plot_annotation(tag_levels = "A") 

ggsave(plot = pComb,
       filename = file.path(Figure_path, paste0("combinedRegionalPeaksHighest.png")),
       width = 12, height = 5, dpi = 400) 
