#Sandra Neubert
#To define the time step we later want to run BOATS in: check the porportion of particles that move further than one grid cell
#in some high current areas (after 24 h and 48 h)
#requires particle tracking input for those areas

library(tidyverse)
library(sf)
library(RColorBrewer)

# Set paths
Data_path <- "C:/Users/sandr/Documents/Github/ThesisSandra/Analysis/Movement/Data"
Figure_path <- "C:/Users/sandr/Documents/Github/ThesisSandra/Analysis/Movement/Figures"

######## function 
count_howFar <- function(BoatsCentrPath, ParcelsDataPath, LatLon, EndTime) {
  BOATSCentr <- read_csv(BoatsCentrPath, 
                         col_names = c("lon", "lat", "ind")) %>%
    dplyr::filter((lat <75)&(lat >(-75))) %>%
    # dplyr::mutate(lon = case_when(lon > 180 ~ lon -360,
    #                               lon < 180 ~ lon)) %>%
    sf::st_as_sf(coords = c("lon", "lat"), crs = LatLon) 
  
  #load parcels output
  parcelsData <- read_csv(ParcelsDataPath) 
  numCentroids <- length(unique(parcelsData$trajectory)) #= numrow(BoatsCentrAghulas)*100
  increments <- seq(100, numCentroids, 100) #for subsetting the parcels data
  
  dfHowFar <- data.frame() #init data frame
  
  incrStart = 0 #set initial start location in data set
  
  for (i in (1:length(increments))){ #loop through the particles, one grid cell at a time (20*100)
    
    incrEnd = increments[i] #set where to end subsetting (meaning: 100 steps)
    
    SubsetParcStart <- parcelsData %>% #get data at time == 0
      dplyr::filter(obs==0, (trajectory>=incrStart & trajectory<incrEnd)) %>%
      sf::st_as_sf(coords = c("lon", "lat"), crs = LatLon)
    
    SubsetParcEnd <- parcelsData %>% #get data at time after 24 h
      dplyr::filter(obs==EndTime, (trajectory>=incrStart & trajectory<incrEnd)) %>%
      drop_na() %>% #becomes NA when hitting land or out of bonds (>75°)
      sf::st_as_sf(coords = c("lon", "lat"), crs = LatLon)
    
    StartCentr <- sf::st_nearest_feature(SubsetParcStart, BOATSCentr) #just sanity check, find nearest neighbor of all starting locations and BOATS centroids
    
    #sanity check
    # if (length(unique(StartCentr)) != 1 ) { #should all be the same if we look at starting cells one after other
    #   print("Error")
    # }
    
    dfStart <- data.frame(BOATSCentr$geometry[StartCentr])%>%
      st_as_sf()
    
    StartCoord <- data.frame(st_coordinates(dfStart)) %>%
      dplyr::rename(lon = X, lat = Y)
    
    EndCentr <- sf::st_nearest_feature(SubsetParcEnd, BOATSCentr) #get the nearest neigh of end location
    
    EndCentr <- sf::st_nearest_feature(SubsetParcEnd, BOATSCentr)
    
    dfEnd <- data.frame(BOATSCentr$geometry[EndCentr])%>%
      st_as_sf()
    
    EndCoord <- data.frame(st_coordinates(dfEnd)) %>%
      dplyr::rename(lon = X, lat = Y)
    
    lonCurr <- StartCoord$lon[1] #doesnt matter which one to index, should all be same
    latCurr <- StartCoord$lat[1]
    
    for (j in (1:nrow(EndCoord))){
      lonEnd <- EndCoord$lon[j] #for each cell, loop through 100 released particles
      latEnd <- EndCoord$lat[j] 
      
      #to get how far particles actually moved
      lonDiff = abs(lonCurr - lonEnd) #get start centroid lon - end centroid lon
      latDiff = abs(latCurr - latEnd)
      
      #now check how far particles moved: if either one of lon or lat is this much, assign this number
      if  (lonDiff > 4 | latDiff > 4) { 
        neighDist = 9999
      } else if (lonDiff == 4 | latDiff == 4){
        neighDist = 4
      } else if (lonDiff == 3 | latDiff == 3){
        neighDist = 3
      } else if (lonDiff == 2 | latDiff == 2){
        neighDist = 2
      } else if (lonDiff == 1 | latDiff == 1){
        neighDist = 1
      } else if (lonDiff == 0 & latDiff == 0){
        neighDist = 0
      } else {
        print("Error Distance")
      }
      
      dfHowFar = rbind(dfHowFar, data.frame(neighDist))
      rm(neighDist)
    }
    
    incrStart = incrEnd
    #incrEnd = increments[i+1]
  }
  
  countsHowFar <- count(dfHowFar, neighDist) 
  
  return(countsHowFar)
}

BoatsPath <- file.path(Data_path, "oceanCellsBOATS.csv")
cCRS <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"


######### 48 hours
AghulasCount48 <- count_howFar(BoatsCentrPath = BoatsPath,
                             ParcelsDataPath = file.path(Data_path, "PT48hFastCurrentAreas" , "dfParcelsAghulas48.csv"),
                             LatLon = cCRS, 
                             EndTime = 48) %>%
  dplyr::mutate(region = as.factor("Agulhas"), 
                neighDist = factor(neighDist, level = c("0", "1", "2", "3"))) 

NorthSeaCount48 <- count_howFar(BoatsCentrPath = BoatsPath,
                              ParcelsDataPath = file.path(Data_path, "PT48hFastCurrentAreas" ,"dfParcelsNorthSea48.csv"),
                              LatLon = cCRS, 
                              EndTime = 48) %>%
  dplyr::mutate(region = "North Sea", 
                neighDist = factor(neighDist, level = c("0", "1")))

SthAmCount48 <- count_howFar(BoatsCentrPath = BoatsPath,
                           ParcelsDataPath = file.path(Data_path, "PT48hFastCurrentAreas" ,"dfParcelsSthAm48.csv"),
                           LatLon = cCRS, 
                           EndTime = 48) %>%
  dplyr::mutate(region = "ACC", 
                neighDist = factor(neighDist, level = c("0", "1", "2", "3"))) 

PhilippinesCount48 <- count_howFar(BoatsCentrPath = BoatsPath,
                                 ParcelsDataPath = file.path(Data_path, "PT48hFastCurrentAreas" ,"dfParcelsPhilippines48.csv"),
                                 LatLon = cCRS, 
                                 EndTime = 48)  %>%
  dplyr::mutate(region = "NECC", 
                neighDist = factor(neighDist, level = c("0", "1", "2"))) 

JapanCount48 <- count_howFar(BoatsCentrPath = BoatsPath,
                           ParcelsDataPath = file.path(Data_path, "PT48hFastCurrentAreas" ,"dfParcelsJapan48.csv"),
                           LatLon = cCRS, 
                           EndTime = 48) %>%
  dplyr::mutate(region = "Kuroshio", 
                neighDist = factor(neighDist, level = c("0", "1", "2", "3"))) 

GulfCount48 <- count_howFar(BoatsCentrPath = BoatsPath,
                          ParcelsDataPath = file.path(Data_path, "PT48hFastCurrentAreas" ,"dfParcelsGulf48.csv"),
                          LatLon = cCRS, 
                          EndTime = 48) %>%
  dplyr::mutate(region = "Gulf", 
                neighDist = factor(neighDist, level = c("0", "1", "2", "3", "4"))) 


countsdf48 <- do.call("rbind", list(SthAmCount48, AghulasCount48, GulfCount48, 
                                JapanCount48, PhilippinesCount48, NorthSeaCount48))

my_palette <- brewer.pal(name="Blues",n=9)
my_palette <- my_palette[c(2,4,6,8,9)]

ggCounts48 <- ggplot(countsdf48, aes(fill=forcats::fct_rev(neighDist), y=n, x=region)) + 
                      geom_bar(position="stack", stat="identity") +
                      #scale_fill_viridis_d(option = "rocket") +
                      scale_fill_manual("Distance after \n48h (cells)",
                                        values = rev(my_palette))+#
                      labs(title = " ", x = "", y = "Particles") +
                      theme_bw() +
                      theme(#legend.key = element_rect(fill = NA, colour = NA, size = 2),
                        #legend.position = c(0.3, 0.11),
                        legend.background = element_blank(),
                        legend.text = element_text(size = 12, colour = "black"),
                        legend.title = element_text(size = 14, colour = "black"),
                        axis.title = element_text(size = 14, colour = "black"),
                        axis.text.y = element_text(size = 12, colour = "black"),
                        axis.text.x = element_text(size = 12, colour = "black"))

ggsave(plot = ggCounts48,
       filename = file.path(Figure_path, paste0("Counts48New.png")),
       width = 8, height = 6, dpi = 200)


####### 24 h
AghulasCount <- count_howFar(BoatsCentrPath = BoatsPath,
                               ParcelsDataPath = file.path(Data_path, "dfParcelsAghulas48.csv"),
                               LatLon = cCRS, 
                               EndTime = 24) %>%
  dplyr::mutate(region = as.factor("Agulhas"), 
                neighDist = factor(neighDist, level = c("0", "1", "2", "3"))) 

NorthSeaCount <- count_howFar(BoatsCentrPath = BoatsPath,
                                ParcelsDataPath = file.path(Data_path, "dfParcelsNorthSea48.csv"),
                                LatLon = cCRS, 
                                EndTime = 24) %>%
  dplyr::mutate(region = "North Sea", 
                neighDist = factor(neighDist, level = c("0", "1")))

SthAmCount <- count_howFar(BoatsCentrPath = BoatsPath,
                             ParcelsDataPath = file.path(Data_path, "dfParcelsSthAm48.csv"),
                             LatLon = cCRS, 
                             EndTime = 24) %>%
  dplyr::mutate(region = "ACC", 
                neighDist = factor(neighDist, level = c("0", "1", "2", "3"))) 

PhilippinesCount <- count_howFar(BoatsCentrPath = BoatsPath,
                                   ParcelsDataPath = file.path(Data_path, "dfParcelsPhilippines48.csv"),
                                   LatLon = cCRS, 
                                   EndTime = 24)  %>%
  dplyr::mutate(region = "NECC", 
                neighDist = factor(neighDist, level = c("0", "1", "2"))) 

JapanCount <- count_howFar(BoatsCentrPath = BoatsPath,
                             ParcelsDataPath = file.path(Data_path, "dfParcelsJapan48.csv"),
                             LatLon = cCRS, 
                             EndTime = 24) %>%
  dplyr::mutate(region = "Kuroshio", 
                neighDist = factor(neighDist, level = c("0", "1", "2", "3"))) 

GulfCount <- count_howFar(BoatsCentrPath = BoatsPath,
                            ParcelsDataPath = file.path(Data_path, "dfParcelsGulf48.csv"),
                            LatLon = cCRS, 
                            EndTime = 24) %>%
  dplyr::mutate(region = "Gulf", 
                neighDist = factor(neighDist, level = c("0", "1", "2", "3", "4"))) 


countsdf <- do.call("rbind", list(SthAmCount, AghulasCount, GulfCount, 
                                    JapanCount, PhilippinesCount, NorthSeaCount))

my_palette <- brewer.pal(name="Blues",n=9)
my_palette <- my_palette[c(2,5,9)]

ggCounts24 <- ggplot(countsdf, aes(fill=forcats::fct_rev(neighDist), y=n, x=region)) + 
  geom_bar(position="stack", stat="identity") +
  #scale_fill_viridis_d(option = "rocket") +
  scale_fill_manual("Distance after \n24h (cells)",
                    values = rev(my_palette))+#
  labs(title = " ", x = "", y = "Particles") +
  theme_bw() +
  theme(#legend.key = element_rect(fill = NA, colour = NA, size = 2),
    #legend.position = c(0.3, 0.11),
    legend.background = element_blank(),
    legend.text = element_text(size = 12, colour = "black"),
    legend.title = element_text(size = 14, colour = "black"),
    axis.title = element_text(size = 14, colour = "black"),
    axis.text.y = element_text(size = 12, colour = "black"),
    axis.text.x = element_text(size = 12, colour = "black"))

ggsave(plot = ggCounts24,
       filename = file.path(Figure_path, paste0("Counts24New.png")),
       width = 8, height = 6, dpi = 200)

##combined Plot
library(patchwork)
combMovedPlot <- (ggCounts24 + ggCounts48) +
  plot_annotation(tag_levels = "A") +
  plot_layout(guides = "collect", widths = c(1, 1)) 

ggsave(plot = combMovedPlot,
       filename = file.path(Figure_path, paste0("combMovedCellsPlot.png")),
       width = 14, height = 6, dpi = 200)
