#Sandra Neubert
#Calculates the distance to the closest MPA for each cell in BOATS to use this information in the GLM later
#For both Waldron scenarios (Cheapest and Top 30)

library(sf)
library(tidyverse)
library(units)

LatLon <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
Data_path <- "../Data"
Figure_path <- "../Figures"
BoatsPath <- file.path(Data_path, "maskGlobal.csv")#"oceanCellsBOATS.csv") #dont use just ocean cells, filter the cells later (takes longer though?)

mpa_scenarios <- read_csv("~/Github/ThesisSandra/Analysis/BOATS/sneubert-boats_v1/input/mpaWaldron/mpasWaldronNew.csv",
                          col_names = c("Lon", "Lat", "CurrentMPAs", "Cheapest_Half", 
                                        "Cheapest_Full", "Top30_Half", "Top30_Full")) %>%
  dplyr::select(Lon, Lat, Top30_Full)%>%
  dplyr::mutate(Lon = case_when(Lon > 180 ~ Lon -360,
                                Lon < 180 ~ Lon)) %>%
  dplyr::filter((Lat <=75)&(Lat >(-75)))%>%
  sf::st_as_sf(coords = c("Lon", "Lat"), crs = LatLon) %>%
  dplyr::filter(Top30_Full == 1)

# ggplot(data = mpa_scenarios) +
#   geom_sf()

BOATSsf <- read_csv("~/GitHub/ThesisSandra/Analysis/Movement/Data/maskGlobal.csv",
                    col_names = c("Lon", "Lat", "ind")) %>%
  dplyr::mutate(lon = case_when(Lon > 0 ~ Lon -180 ,
                                Lon < 0 ~ Lon +180) ) %>%
  dplyr::filter((Lat <=75)&(Lat >(-75)))%>%
  sf::st_as_sf(coords = c("lon", "Lat"), crs = LatLon) %>%
  dplyr::filter(ind == 0)  

# ggplot(data = BOATSsf) +
#   geom_sf()

nearest <- sf::st_nearest_feature(BOATSsf, mpa_scenarios) 

dist <- st_distance(BOATSsf, mpa_scenarios[nearest,], by_element=TRUE) %>%
  data.frame() %>%
  dplyr::rename(dist = ".") %>%
  drop_units() %>%
  dplyr::mutate(dist = dist/1000)

BOATSsfTest  <-BOATSsf %>%
  dplyr::mutate(distance = unlist(dist)) %>%
  dplyr::select(distance) %>%
  st_as_sf()

BOATSsfLand <- read_csv("~/GitHub/ThesisSandra/Analysis/Movement/Data/maskGlobal.csv",
                    col_names = c("Lon", "Lat", "ind")) %>%
  dplyr::mutate(lon = case_when(Lon > 0 ~ Lon -180 ,
                                Lon < 0 ~ Lon +180) ) %>%
  dplyr::filter((Lat <=75)&(Lat >(-75)))%>%
  sf::st_as_sf(coords = c("lon", "Lat"), crs = LatLon) %>%
  dplyr::filter(ind == 1)  

distPlot1 <- ggplot(data = BOATSsfTest) +
  geom_sf(aes(color = distance), size = 0.2) +
  #
  labs(title = "Distance to MPAs (Top 30)",color='Distance (km)') +
  
  theme_bw() +
  theme(plot.title = element_text(size=12, colour = "black"),
    legend.background = element_blank(),
    legend.text = element_text(size = 12, colour = "black"),
    legend.title = element_text(size = 12, colour = "black"),
    axis.title = element_text(size = 12, colour = "black"),
    axis.text.y = element_text(size = 12, colour = "black"),
    axis.text.x = element_text(size = 12, colour = "black"))

ggsave(plot = distPlot1,
       filename = file.path(Figure_path, paste0("DistToMPATop30.png")),
       width = 8, height = 6, dpi = 200)

#############
mpa_scenarios <- read_csv("~/Github/ThesisSandra/Analysis/BOATS/sneubert-boats_v1/input/mpaWaldron/mpasWaldronNew.csv",
                          col_names = c("Lon", "Lat", "CurrentMPAs", "Cheapest_Half", 
                                        "Cheapest_Full", "Top30_Half", "Top30_Full")) %>%
  dplyr::select(Lon, Lat, Cheapest_Full)%>%
  dplyr::mutate(Lon = case_when(Lon > 180 ~ Lon -360,
                                Lon < 180 ~ Lon)) %>%
  dplyr::filter((Lat <=75)&(Lat >(-75)))%>%
  sf::st_as_sf(coords = c("Lon", "Lat"), crs = LatLon) %>%
  dplyr::filter(Cheapest_Full == 1)

# ggplot(data = mpa_scenarios) +
#   geom_sf()


BOATSsf <- read_csv("~/GitHub/ThesisSandra/Analysis/Movement/Data/maskGlobal.csv",
                    col_names = c("Lon", "Lat", "ind")) %>%
  dplyr::mutate(lon = case_when(Lon > 0 ~ Lon -180 ,
                                Lon < 0 ~ Lon +180) ) %>%
  dplyr::filter((Lat <=75)&(Lat >(-75)))%>%
  sf::st_as_sf(coords = c("lon", "Lat"), crs = LatLon) %>%
  dplyr::filter(ind == 0)  

# ggplot(data = BOATSsf) +
#   geom_sf()

nearest <- sf::st_nearest_feature(BOATSsf, mpa_scenarios) #%>%
# data.frame() %>%
# dplyr::rename(End = ".")

dist <- st_distance(BOATSsf, mpa_scenarios[nearest,], by_element=TRUE) %>%
  data.frame() %>%
  dplyr::rename(dist = ".") %>%
  drop_units() %>%
  dplyr::mutate(dist = dist/1000)

BOATSsfTest  <-BOATSsf %>%
  dplyr::mutate(distance = unlist(dist)) %>%
  dplyr::select(distance) %>%
  st_as_sf()# %>%
#dplyr::filter(distance < 50)
saveRDS(BOATSsfTest, file.path(Data_path, "DistToMPACheapest.rds"))

BOATSsfLand <- read_csv("~/GitHub/ThesisSandra/Analysis/Movement/Data/maskGlobal.csv",
                        col_names = c("Lon", "Lat", "ind")) %>%
  dplyr::mutate(lon = case_when(Lon > 0 ~ Lon -180 ,
                                Lon < 0 ~ Lon +180) ) %>%
  #dplyr::mutate(lon = Lon + 180) %>%
  dplyr::filter((Lat <=75)&(Lat >(-75)))%>%
  sf::st_as_sf(coords = c("lon", "Lat"), crs = LatLon) %>%
  dplyr::filter(ind == 1)  

distPlot2 <- ggplot(data = BOATSsfTest) +
  geom_sf(aes(color = distance), size = 0.2) +
  labs(title = "Distance to MPAs (Cheapest)",color='Distance (km)') +
  
  theme_bw() +
  theme(
    plot.title = element_text(size=12, colour = "black"),
    legend.background = element_blank(),
    legend.text = element_text(size = 12, colour = "black"),
    legend.title = element_text(size = 12, colour = "black"),
    axis.title = element_text(size = 12, colour = "black"),
    axis.text.y = element_text(size = 12, colour = "black"),
    axis.text.x = element_text(size = 12, colour = "black"))

ggsave(plot = distPlot2,
       filename = file.path(Figure_path, paste0("DistToMPACheapest.png")),
       width = 8, height = 6, dpi = 200)

##########
library(patchwork)
combDistPlot <- (distPlot2 / distPlot1) +
  plot_annotation(tag_levels = "A") 

ggsave(plot = combDistPlot,
       filename = file.path(Figure_path, paste0("combDistPlot.png")),
       width = 8, height = 6, dpi = 200)
