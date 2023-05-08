#Sandra Neubert
#Create Probability Matrices based on particle tracking data globally 
#Jase adapted this script later to run it parallel on the HPC

library(sf)
library(tidyverse)
library(tidync)
library(ncdf4)
library(lubridate)

###### Set paths ######
Data_path <- "/srv/scratch/z5278054/particle-tracking-sandra/Output"
# Figure_path <- "../Figures"
BoatsPath <- file.path("..", "Data", "maskGlobal.csv")#dont use just ocean cells, filter the cells later (takes longer though?)

LatLon <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"

###### Functions #########
convert_time <- function(particles, particles.info) { #Function from Dan Hewitt
  
  # particles is the actual data
  # particles.info is the link to the netcdf
  
  # extract the time.origin
  time.origin <- ymd(str_sub(particles.info$var$time$units, 15, 24))
  
  # convert time to a readable format (i.e. not in seconds since...)
  particles <- particles %>%
    mutate(date = time.origin + duration(time, units = "seconds"))
}

##### Load BOATS Data #####
BOATSdf <-  read_csv(BoatsPath, col_names = c("lon", "lat", "ind")) %>%
  dplyr::filter((lat <=75)&(lat >(-75))) #OFES only near-global

BOATSsf <- BOATSdf %>%
  sf::st_as_sf(coords = c("lon", "lat"), crs = LatLon) 

##### Calculate Prob Matrices ######
uniqueMonths <- 1:12 #Sys.glob(file.path(Data_path, "1950*.nc"))#just to get number of months, should be 12 later anyway
uniqueYears <- 1950:2019

uniqueDate <- expand.grid(Month = uniqueMonths, Year = uniqueYears)

# This the HPC run number index
idx <-as.integer(Sys.getenv('PBS_ARRAY_INDEX'))

trajectoryCount <- 1 #otherwise problems with 0 later

parcelsDataMonth <- paste0(uniqueDate$Year[idx],"-",uniqueDate$Month[idx],"-ParcelsOutput")

## load parcels data
particles.info <- nc_open(file.path(Data_path, paste0(parcelsDataMonth,".nc")))

parcelsData <- hyper_tibble(file.path(Data_path, paste0(parcelsDataMonth,".nc")))%>% 
  convert_time(particles.info) %>%
  #dplyr::mutate(Month = month(as.POSIXlt(.data$date, format="%Y-%m-%d"))) %>% #to select by month later 
  dplyr::filter(age == 0| age == 86400) %>% #filter for start and after 24h
  dplyr::mutate(trajectoryID = trajectory + trajectoryCount) %>%
  dplyr::select(-age, -z)

### some particles are on land (mostly on ice in Antarctica) --> no current information: only have start but not end observation: get rid of those
onLandData <- data.frame(table(parcelsData$trajectoryID)) %>% 
  dplyr::filter(Freq != 2) #all that have fewer than 2 observations (start and end location)

onLandData <- onLandData$Var1

parcelsData <- parcelsData %>%
  dplyr::filter(!trajectoryID %in% onLandData) #delete trajectories with fewer than 2 obs (bit hacky but works)
####

#to avoid getting some trajectory number twice and messing up data: assign new ID
trajectoryCount <- max(parcelsData$trajectoryID)

# Save raw rds for each month/year combo as an interim file.
saveRDS(parcelsData, file.path("","srv","scratch","z9902002","Movement","Output", 
                                 paste0("ParcelsData_", uniqueDate$Year[idx],
                                        "_",uniqueDate$Month[idx], ".rds")))
