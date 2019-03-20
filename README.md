# AppDensityCalculation
This file provides an explanation on the calculations made to come up with the population densities according to barangay and by cities. 
### Population Density 
Population density is defined as the population per unit area, which is calculated by dividing the population by an area.
## Barangay Density
For the Barangay Density problem, the goal is to output a CSV file that will list down the top 5 cities with the highest densities.
In the code BarangayDensity.R, the population.csv and regionarea.csv files were called using the read.csv function and assigned to 'population' and 'regionarea' variables respectively. The dplyr package was also called.

      population = read.csv("population.csv")
      regionarea = read.csv("regionarea.csv")
      library(dplyr)

The 'population' dataframe was grouped in terms of the Region column, which was assigned to 'Region' variable, in order to count the number of barangay per region.      

      by_Region = group_by(population, Region)
      Region = summarise(by_Region, countBarangay = n())

The 'Region' and 'regionarea' dataframes were merged using the merge function in terms of the Region attribute in order to match the area per region to its corresponding region. The area per region was divided to the number of barangay per region in order to get the area of the each barangay. 

      RegionDensity = merge(Region, regionarea, by.x = "Region", by.y = "Region")
      RegionDensity$AreaPerBarangay = RegionDensity$Area / RegionDensity$countBarangay

From the results, the population per barangay was divided to the area per barangay in order to get the density per barangay.

      BarangayDensity = merge(population, RegionDensity, by.x = "Region", by.y = "Region")
      BarangayDensity$PopulationDensity = BarangayDensity$Population / BarangayDensity$AreaPerBarangay

The results were arranged by descending order and the top 5 barangay with the highest barangay density was saved as a CSV file named 'BarangayDensity.csv'

      BarangayDensity = head(arrange(BarangayDensity, desc(PopulationDensity)), n = 5)
      View(BarangayDensity)
      write.csv(BarangayDensity, 'BarangayDensity.csv')
      read.csv("BarangayDensity.csv")


## City Density
