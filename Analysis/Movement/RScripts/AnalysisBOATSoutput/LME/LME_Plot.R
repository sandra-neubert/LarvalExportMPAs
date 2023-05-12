library(tidyverse)
library(sf)
library(patchwork)

Figure_path <- "../Figures"
Data_path <- "../Data/ChangesMoveNH"

LatLon <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"

lmes <- mregions::mr_shp(key = "MarineRegions:lme") %>%
  filter(sf::st_is_valid(.)) %>% # Temporarily remove invalid geometries because they cause trouble (n = 2)
  dplyr::filter(lme_name != "Black Sea" & lme_name != "Central Arctic" & lme_name != "Canadian High Arctic - North Greenland") %>%
  dplyr::select(lme_name, grouping, geometry)

# Check LME data
ggplot(data = lmes, aes(fill = lme_name)) +
  geom_sf()


## Get Fish Biomass
PCB <- read_csv(file.path(Data_path, "PCB.csv"),
                col_names = c("lon", "lat", "change")) %>%
  na.omit() %>%
  dplyr::mutate(lon = case_when(lon > 180 ~ lon -360,
                                lon < 180 ~ lon)) %>%
  sf::st_as_sf(coords = c("lon", "lat"), crs = "EPSG:4326")

## Get Egg Biomass
PCE <- read_csv(file.path(Data_path, "PCEggs.csv"),
                col_names = c("lon", "lat", "change")) %>%
  na.omit() %>%
  dplyr::mutate(lon = case_when(lon > 180 ~ lon -360,
                                lon < 180 ~ lon)) %>%
  sf::st_as_sf(coords = c("lon", "lat"), crs = "EPSG:4326")

# Intersect biomass with lmes
intFish <- st_intersection(PCB, lmes)
intEggs <- st_intersection(PCE, lmes)

gg1 <- ggplot() +
  geom_hline(yintercept = 0, colour = "black") +
  geom_boxplot(data = intEggs, aes(x = reorder(lme_name, change, FUN = median), y = change, colour = reorder(lme_name, change, FUN = median)), show.legend = FALSE) +
  coord_cartesian(ylim = c(-20, 20)) +
  theme_bw() +
  ylab("Egg biomass change (%)") +
  xlab("Large Marine Ecosystem") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1,size = 15, colour = "black"),
        axis.title = element_text(size = 15, colour = "black"),
        axis.text.y = element_text(size = 15, colour = "black"),
        plot.margin = margin(1, 1, 1, 1.5, "cm"))


gg2 <- ggplot() +
  geom_hline(yintercept = 0, colour = "black") +
  geom_boxplot(data = intFish, aes(x = reorder(lme_name, change, FUN = median), y = change, colour = reorder(lme_name, change, FUN = median)), show.legend = FALSE) +
  coord_cartesian(ylim = c(-20, 20)) +
  theme_bw() +
  ylab("Fish biomass change (%)") +
  xlab("Large Marine Ecosystem") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1,size = 15, colour = "black"),
        axis.title = element_text(size = 15, colour = "black"),
        axis.text.y = element_text(size = 15, colour = "black"),
        plot.margin = margin(1, 1, 1, 1.5, "cm"))

ggsave("PCE.pdf", gg1, width = 420, height = 297, units = "mm")
ggsave("PCB.pdf", gg2, width = 420, height = 297, units = "mm")
ggsave(plot = gg1,
       filename = file.path(Figure_path, paste0("PCE.png")),
       width = 420, height = 265, units = "mm", dpi = 300) 
ggsave(plot = gg2,
       filename = file.path(Figure_path, paste0("PCB.png")),
       width = 420, height = 265, units = "mm", dpi = 300) 


##########
#FOR OA
## Get Fish Biomass
PCB_OA <- read_csv(file.path(Data_path, "PCB_OA.csv"),
                col_names = c("lon", "lat", "change")) %>%
  na.omit() %>%
  dplyr::mutate(change = case_when(change > quantile(change, 0.97) ~ quantile(change, 0.97),
                                   change <= quantile(change, 0.97)~ change)) %>%
  dplyr::mutate(lon = case_when(lon > 180 ~ lon -360,
                                lon < 180 ~ lon)) %>%
  sf::st_as_sf(coords = c("lon", "lat"), crs = "EPSG:4326")

## Get Egg Biomass
PCH <- read_csv(file.path(Data_path, "PCH_OA.csv"),
                col_names = c("lon", "lat", "change")) %>%
  na.omit() %>%
  dplyr::mutate(change = case_when(change > quantile(change, 0.97) ~ quantile(change, 0.97),
                                     change <= quantile(change, 0.97)~ change)) %>%
  dplyr::mutate(lon = case_when(lon > 180 ~ lon -360,
                                lon < 180 ~ lon)) %>%
  sf::st_as_sf(coords = c("lon", "lat"), crs = "EPSG:4326")

# Intersect biomass with lmes
intFish <- st_intersection(PCB_OA, lmes)
intH <- st_intersection(PCH, lmes)

gg1 <- ggplot() +
  geom_hline(yintercept = 0, colour = "black") +
  geom_boxplot(data = intH, aes(x = reorder(lme_name, change, FUN = median), y = change, colour = reorder(lme_name, change, FUN = median)), show.legend = FALSE) +
  coord_cartesian(ylim = c(-90, 90)) +
  theme_bw() +
  ylab("Harvest change (%)") +
  xlab("Large Marine Ecosystem") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1,size = 13, colour = "black"),
        axis.title = element_text(size = 14, colour = "black"),
        axis.text.y = element_text(size = 13, colour = "black"),
        plot.margin = margin(1, 1, 1, 1.5, "cm"))


gg2 <- ggplot() +
  geom_hline(yintercept = 0, colour = "black") +
  geom_boxplot(data = intFish, aes(x = reorder(lme_name, change, FUN = median), y = change, colour = reorder(lme_name, change, FUN = median)), show.legend = FALSE) +
  coord_cartesian(ylim = c(-90, 90)) +
  theme_bw() +
  ylab("Fish biomass change (%)") +
  xlab("Large Marine Ecosystem") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1,size = 13, colour = "black"),
        axis.title = element_text(size = 14, colour = "black"),
        axis.text.y = element_text(size = 13, colour = "black"),
        plot.margin = margin(1, 1, 1, 1.5, "cm"))

#ggsave("PCE.pdf", gg1, width = 420, height = 297, units = "mm")
#ggsave("PCB.pdf", gg2, width = 420, height = 297, units = "mm")
ggsave(plot = gg1,
       filename = file.path(Figure_path, paste0("PCH_OA.png")),
       width = 420, height = 265, units = "mm", dpi = 300) 
ggsave(plot = gg2,
       filename = file.path(Figure_path, paste0("PCB_OA.png")),
       width = 420, height = 265, units = "mm", dpi = 300) 