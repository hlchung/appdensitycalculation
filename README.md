# AppDensityCalculation by SixRs
### *Created by Chung, De Vera, Nagallo, Naputo, and Pagaduan*
This file provides an explanation on the calculations made to come up with the population densities according to barangay and by cities. 
### Population Density 
Population density is defined as the population per unit area, which is calculated by dividing the population by an area.
## Barangay Density
For the Barangay Density problem, the goal is to output a CSV file that will list down the top 5 barangays with the highest densities.
In the code BarangayDensity.R, the *population.csv* and *regionarea.csv* files were called using the **read.csv** function and assigned to **population** and **regionarea** variables, respectively. The **dplyr** package was also called.

      population = read.csv("population.csv")
      regionarea = read.csv("regionarea.csv")
      library(dplyr)

The **population** dataframe was grouped in terms of the Region column, which was assigned to **Region** variable, in order to count the number of barangay per region.      

      by_Region = group_by(population, Region)
      Region = summarise(by_Region, countBarangay = n())

The **Region** and **regionarea** dataframes were merged using the *merge function* in terms of the Region attribute in order to match the area per region to its corresponding region. The area per region was divided to the number of barangay per region in order to get the area of the each barangay. 

      RegionDensity = merge(Region, regionarea, by.x = "Region", by.y = "Region")
      RegionDensity$AreaPerBarangay = RegionDensity$Area / RegionDensity$countBarangay

From the results, the population per barangay was divided to the area per barangay in order to get the density per barangay.

      BarangayDensity = merge(population, RegionDensity, by.x = "Region", by.y = "Region")
      BarangayDensity$PopulationDensity = BarangayDensity$Population / BarangayDensity$AreaPerBarangay

The results were arranged by descending order and the top 5 barangay with the highest barangay density was saved as a CSV file named *BarangayDensity.csv*

      BarangayDensity = head(arrange(BarangayDensity, desc(PopulationDensity)), n = 5)
      View(BarangayDensity)
      write.csv(BarangayDensity, 'BarangayDensity.csv')
      read.csv("BarangayDensity.csv")


## City Density
In the City Density problem, the goal is to produce a CSV file that will list down the top 5 cities with the highest densities.
In the code CityDensity.R, the *population.csv* and *regionarea.csv* files were called using the read.csv function and assigned to **population** and **regionArea** variables, respectively. The two csv files were *merged through the Region column* and was named as **regionAreaAndPopulation**. Furthermore, the **dplyr** package was called.

      population <- read.csv("population.csv")
      regionArea <- read.csv("regionarea.csv")
      regionAreaAndPopulation <- merge(population, regionArea, by = "Region")
      library(dplyr)

After merging the two files, they were grouped according to **Region and CityProvince**, where the number of city per region was counted. The same method was used when the **NumberOfCity and Region** were merged and the **NumberOfCityPerRegion** was counted.

      by_region <- group_by(regionAreaAndPopulation, Region, CityProvince)
      NumberOfCity <- summarise(by_region, Cityn = n())
      by_City <- group_by(NumberOfCity, Region)
      NumberOfCityPerRegion <- summarise(by_City, cityn = n())

To compute for the **AreaOfCityPerRegion**, the area of the region was divided by the number of city per region. 

      AreaOfCityPerRegion <- regionArea$Area/NumberOfCityPerRegion$cityn #Area per Region  
      AreaOfCityPerRegion <- data.frame(regionArea$Region, AreaOfCityPerRegion)

The **PopulationByCity** was also aggregated, while the column names were renamed to *CityProvince, Total Population, Region, and Area* for consistency. 

      PopulationByCity <- aggregate(population$Population, by = list(population$CityProvince), FUN = sum,  
            na.rm = TRUE)
      colnames(PopulationByCity) <- c('CityProvince', 'Total Population')
      colnames(AreaOfCityPerRegion) <- c('Region', 'Area')

The files were then *merged* according to **CityProvince**

      merge(population,
            PopulationByCity, by = 'CityProvince')

The following codes indicate how the columns were *merged*. Also, the computation for the **FinalCityDensity** is indicated by *dividing the TotalPopulation by the Area of the City*.

      CityProvinceRegion <- data.frame(population$CityProvince,population$Region)
      colnames(CityProvinceRegion) <- c('CityProvince', 'Region')

      PopulationByRegionCity <- merge(CityProvinceRegion, PopulationByCity, by='CityProvince')
      PopulationByRegionCity<-distinct(PopulationByRegionCity)

      FinalCityDensity <- merge(PopulationByRegionCity,AreaOfCityPerRegion, by = 'Region')
      FinalCityDensity$CityDensity <- FinalCityDensity$`Total Population`/FinalCityDensity$Area

Using the **FinalCityDensity**, they were arranged in descending order according to the *CityDensity* and the top 5 cities with the highest city density was saved as a CSV file named *Top5City.csv* 

      FinalCityDensity <- arrange(FinalCityDensity, desc(CityDensity))
      write.csv(file = "Top5City.csv",FinalCityDensity[1:5,])
      read.csv("Top5City.csv")
