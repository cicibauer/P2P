#####################################
## global file: read and process data
#####################################


library(shiny);library(leaflet)
library(tmap);library(ggplot2);library(tidyverse);library(clipr); library(rgdal); library(sf);library(stringi)

# read in and process data
datalist <- readRDS("Data/pred_2021.rds")
#datalist <- readRDS("../MA_prediction_run3.rds")
d <- datalist$d ### polygon files - order of the data.pred (id=1-537) is the same as the polygon orders
dat.pred <- datalist$dat.pred ### data used for prediction 2005-2019 observed, prediction is for 2020 and 2021
dat.pred1 <- dat.pred
# create quantiles
#define quantiles of interest
q = c(.2, .4, .6, .8)
#calculate quantiles by grouping variable
dat.pred <- dat.pred %>%
  #group_by(year) %>%
  filter(!is.na(rate)) %>% 
  mutate(quant20 = quantile(rate, probs = q[1]), 
         quant40 = quantile(rate, probs = q[2]),
         quant60 = quantile(rate, probs = q[3]),
         quant80 = quantile(rate, probs = q[4])) #%>% ungroup()

dat.pred <- dat.pred %>% #group_by(year) %>% 
  mutate(rate_q=ifelse(rate<=quant20, "Q1", ifelse(rate>quant20 & rate<=quant40, "Q2",ifelse(rate>quant40 & rate <= quant60, "Q3", ifelse(rate>quant60 & rate<=quant80, "Q4", "Q5"))))) %>%
  select(-c(quant20,quant40, quant60, quant80)) 

# group data by year
yearly <- dat.pred %>% group_by(year) %>% summarise(mean_rate=mean(rate)) %>% filter(!is.na(mean_rate))

# read in shapefiles
# us <- readOGR("MappingObjects/tl_2019_us_zcta510", "tl_2019_us_zcta510", verbose=F)
# shp <- subset(us, us$ZCTA5CE10 %in% d$ZCTA5CE10)
# writeOGR(obj=shp,dsn="MappingObjects",layer="MA_ZCTA",driver="ESRI Shapefile")
shp <- rgdal::readOGR("MappingObjects", "MA_ZCTA", verbose=F)


#poulation data
pop <- read.csv("Data/MA_ACS_Data_byYear.csv")
pop <- pop %>% mutate(npop20= npop-M_under5-M_5to9-M_10to14-M_15to19-F_under5-F_5to9-F_10to14-F_15to19,
                      zipcode=stri_pad_left(Zipcode, 5, pad="0"),
                      year=ifelse(Year=="2007-2011", 2010, ifelse(Year=="2011-2015", 2015, 2019)))
data <- merge(dat.pred[,c(1:2,15,18)], pop[,c(4,51:53)], by=c("year", "zipcode"))
data2 <- dat.pred[,c(1,15,30)]
# convert data from long to wide
library(reshape2)

data_w1 <- dcast(melt(data, id.vars=c("year", "zipcode")), zipcode~variable+year)
data_w2 <- dcast(melt(data2, id.vars=c("year", "zipcode")), zipcode~variable+year)
data_w <- left_join(data_w1, data_w2, by="zipcode")

shp@data$myID <- 1:nrow(shp@data)
shp@data <- merge(shp@data[,c(2,6:10)], data_w, by.x="GEOID10", by.y="zipcode")
shp@data <- shp@data[order(shp$myID),]

shp$lat <- as.numeric(as.character(shp$INTPTLAT10))
shp$long <- as.numeric(as.character(shp$INTPTLON10))
shp$GEOID10 <- as.character(shp$GEOID10)
