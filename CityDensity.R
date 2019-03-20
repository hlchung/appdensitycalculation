population <- read.csv("population.csv")
regionArea <- read.csv("regionarea.csv")
regionAreaAndPopulation <- merge(population, regionArea, by = "Region")
library(dplyr)

AreaOfCityPerRegion <- regionArea$Area/count(regionAreaAndPopulation, Region)$n
AreaOfCityPerRegion <- data.frame(regionArea$Region, AreaOfCityPerRegion)
PopulationByCity <- aggregate(population$Population, by = list(population$CityProvince), FUN = sum, na.rm = TRUE)
colnames(PopulationByCity) <- c('CityProvince', 'Total Population')
colnames(AreaOfCityPerRegion) <- c('Region', 'Area')

merge(population,
      PopulationByCity, by = 'CityProvince')

CityProvinceRegion <- data.frame(population$CityProvince,population$Region)
colnames(CityProvinceRegion) <- c('CityProvince', 'Region')

PopulationByRegionCity <- merge(CityProvinceRegion, PopulationByCity, by='CityProvince')
PopulationByRegionCity<-distinct(PopulationByRegionCity)


FinalCityDensity <- merge(PopulationByRegionCity,AreaOfCityPerRegion, by = 'Region')
FinalCityDensity$CityDensity <- FinalCityDensity$`Total Population`/FinalCityDensity$Area

FinalCityDensity <- arrange(FinalCityDensity, desc(CityDensity))
write.csv(file = "Top5City.csv",FinalCityDensity[1:5,])
