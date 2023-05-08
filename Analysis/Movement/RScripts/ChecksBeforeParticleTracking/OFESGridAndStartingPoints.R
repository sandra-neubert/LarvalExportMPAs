library(sf)
library(tidyverse)

# Set paths
Data_path <- "C:/Users/sandr/Documents/Github/ThesisSandra/Analysis/Movement/Data"
Figure_path <- "C:/Users/sandr/Documents/Github/ThesisSandra/Analysis/Movement/Figures"
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
                     cellsize = c(0.1,0.1),
                     what = "polygons") %>%
  st_as_sf() %>%
  dplyr::rename(geometry = x) %>%
  st_make_valid()
# 
# ggplot() +
#   geom_sf(data = grid)


ofesDat <- read_csv(OfesPath) %>%
  # dplyr::mutate(lon = case_when(lon > 180 ~ lon -360,
  #                               lon <= 180 ~ lon)) %>%
  sf::st_as_sf(coords = c("lon", "lat"), crs = cCRS) 

ofesNotNA <- ofesDat %>% #gives all cells in BOATS for which there is no OFES data
  dplyr::filter(!is.na(uvel))

maskOfes <- lengths(st_intersects(grid, ofesNotNA)) > 0

OfesBOATSInter <- grid %>%
  mutate(mask = case_when(maskOfes  ~ 1,
                          !maskOfes  ~ 0)) %>%
  dplyr::filter(mask == 1) %>%
  st_as_sf() %>%
  st_make_valid()


OfesBOATSInter <- OfesBOATSInter %>%
  st_as_sf() %>%
  st_make_valid()

centroidsGridOFES <- st_centroid(OfesBOATSInter) %>%
  dplyr::select(-mask)

startingLocsOFES <- centroidsGridOFES  %>%
  mutate(lon = unlist(map(centroidsGridOFES $geometry,1)),
         lat = unlist(map(centroidsGridOFES $geometry,2))) %>%
  data.frame() %>%
  dplyr::select(-geometry)

write.csv(startingLocsOFES, file.path(Data_path, "OFESStartLoc.csv"), row.names=FALSE)

# p <- ggplot() +
#         geom_sf(data = OfesBOATSInter)
# 
# ggsave(plot = p,
#        filename = file.path(Figure_path, paste0("OfesGrid.png")),
#        width = 8, height = 6, dpi = 200)

