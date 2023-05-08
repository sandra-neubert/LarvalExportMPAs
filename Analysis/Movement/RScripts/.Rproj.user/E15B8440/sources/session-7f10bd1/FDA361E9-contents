#Sandra Neubert
#To compare which ocean cells in BOATS don't have hydrodynamic model data (and other way round)

library(sf)
library(tidyverse)

# Set paths
Data_path <- "C:/Users/sandr/Documents/Github/ThesisSandra/Analysis/Movement/Data"
Figure_path <- "C:/Users/sandr/Documents/Github/ThesisSandra/Analysis/Movement/Figures"
BoatsPath <- file.path(Data_path, "oceanCellsBOATS.csv")
OfesPath <- file.path(Data_path, "dfOFESOcean.csv")

cCRS <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"

get_Boundary <- function(Limits){
  
  # Create function for creating polygon
  polygon <- function(x){
    x <- x %>%
      as.matrix() %>%
      list() %>%
      st_polygon() %>%
      st_sfc(crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0") #%>%
    #st_transform(crs = cCRS)
  }
  
  Bndry <- tibble(x = seq(Limits["xmin"], Limits["xmax"], by = 1), y = Limits["ymin"]) %>%
    bind_rows(tibble(x = Limits["xmax"], y = seq(Limits["ymin"], Limits["ymax"], by = 1))) %>%
    bind_rows(tibble(x = seq(Limits["xmax"], Limits["xmin"], by = -1), y = Limits["ymax"])) %>%
    bind_rows(tibble(x = Limits["xmin"], y = seq(Limits["ymax"], Limits["ymin"], by = -1))) %>%
    polygon()
  
  return(Bndry)
}

Limits <- c(xmin = 0, xmax = 360, ymin = -75, ymax = 74)
#Limits <- c(xmin = -180, xmax = 180, ymin = -75, ymax = 74)

box <- get_Boundary(Limits)

# First create planning units for the whole region
grid <- st_make_grid(box,
                     square = TRUE,
                     cellsize = c(1,1),
                     what = "polygons") %>%
  st_as_sf() %>%
  dplyr::rename(geometry = x) %>%
  st_make_valid()
# 
# ggplot() +
#   geom_sf(data = grid)

#load BOATS
BOATSCentr <- read_csv(BoatsPath, 
                       col_names = c("lon", "lat", "ind")) %>%
  # dplyr::mutate(lon = case_when(lon > 180 ~ lon -360,
  #                               lon <= 180 ~ lon)) %>%
  dplyr::filter((lat <74)&(lat >(-75))) %>%
  sf::st_as_sf(coords = c("lon", "lat"), crs = cCRS) 

#######
#label all BOATS ocean cells as 1 in grid 

# test1 <- st_intersects(grid, BOATSCentr) #%>%
#   #data.frame()

maskBoats <- lengths(st_intersects(grid, BOATSCentr)) > 0


gridBOATS <- grid %>%
  mutate(mask = case_when(maskBoats ~ 1,
                          !maskBoats ~ 0)) 

gridBOATSOcean <- gridBOATS %>%
  dplyr::filter(mask == 1)

# ggplot2::ggplot() +
#   ggplot2::geom_sf(data = gridBOATS, ggplot2::aes(fill = mask), colour = NA)


####### load ofes

ofestest <- read_csv(OfesPath) %>%
  #dplyr::filter((lat <75)&(lat >(-75))) %>%
  # dplyr::mutate(lon = case_when(lon > 180 ~ lon -360,
  #                               lon <= 180 ~ lon)) %>%
  sf::st_as_sf(coords = c("lon", "lat"), crs = cCRS) 

maskOfes <- lengths(st_intersects(ofestest, gridBOATSOcean)) > 0

OfesBOATSInter <- ofestest  %>%
  mutate(mask = case_when(maskOfes  ~ 1,
                          !maskOfes  ~ 0)) %>%
  dplyr::filter(mask == 1)

OfesBOATSInterNA <- OfesBOATSInter %>% #gives all cells in BOATS for which there is no OFES data
  dplyr::filter(is.na(uvel))

# closestCentrBOATS <- sf::st_nearest_feature(OfesBOATSInterNA, BOATSCentr) 
# length(unique(closestCentrBOATS))
tableNoDataOfes <- data.frame(table(unlist(sf::st_within(OfesBOATSInterNA, gridBOATSOcean)))) #> 100 because values on border line of grid cell are put into both cells
#tableNoDataOfes <- data.frame(table(closestCentrBOATS))

ggCounts <- ggplot(tableNoDataOfes, aes(x=Freq)) + 
                  geom_histogram(color="black", fill="white", bins =50) +
                  labs(title = "Number of OFES NAs in BOATS grid cells (total = 1515)", x = "# NA in a grid cell", y = "Counts") +
                  theme_bw() +
                  theme(legend.key = element_rect(fill = NA, colour = NA, size = 2),
                        #legend.position = c(0.3, 0.11),
                        legend.background = element_blank(),
                        legend.text = element_blank(),
                        #legend.title = element_blank(),
                        axis.title = element_text(size = 14, colour = "black"),
                        axis.text.y = element_text(size = 14, colour = "black"),
                        axis.text.x = element_text(size = 14, colour = "black"))# +

ggsave(plot = ggCounts,
       filename = file.path(Figure_path, paste0("NAsOfesVSBoats.png")),
       width = 8, height = 6, dpi = 200)


NAthreshold <- tableNoDataOfes %>%
  dplyr::filter(Freq >30 )

BOATSCentrNew <- BOATSCentr %>%
  dplyr::filter(!(row.names(BOATSCentr) %in% NAthreshold$Var1))
#test2 <- data.frame(sf::st_contains(gridBOATSOcean, OfesBOATSInterNA))

maskBoatsNew <- lengths(st_intersects(grid, BOATSCentrNew)) > 0


gridBOATSNew <- grid %>%
  mutate(mask = case_when(maskBoatsNew ~ 1,
                          !maskBoatsNew ~ 0)) %>%
  st_as_sf() %>%
  st_make_valid()


ggplot2::ggplot() +
  ggplot2::geom_sf(data = gridBOATSNew, ggplot2::aes(fill = mask), colour = NA)
