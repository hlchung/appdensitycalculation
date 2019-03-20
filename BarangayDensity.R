population = read.csv("population.csv")
regionarea = read.csv("regionarea.csv")
library(dplyr)
by_Region = group_by(population, Region)
Region = summarise(by_Region, countBarangay = n())
RegionDensity = merge(Region, regionarea, by.x = "Region", by.y = "Region")
RegionDensity$AreaPerBarangay = RegionDensity$Area / RegionDensity$countBarangay

BarangayDensity = merge(population, RegionDensity, by.x = "Region", by.y = "Region")
BarangayDensity$PopulationDensity = BarangayDensity$Population / BarangayDensity$AreaPerBarangay
BarangayDensity = head(arrange(BarangayDensity, desc(PopulationDensity)), n = 5)
View(BarangayDensity)
write.csv(BarangayDensity, 'BarangayDensity.csv')
read.csv("BarangayDensity.csv")
