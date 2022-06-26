# MSDS 460 Homework Assignment 3: Algorithmic Redistricting
# 
# preliminary county calculations with New Jersey 
# using data from US Census of Population for 2020
countydata = read.csv("nj-population.csv", stringsAsFactors = FALSE)

#pulled fips from 
#https://www.nrcs.usda.gov/wps/portal/nrcs/detail/nj/about/?cid=nrcs143_013697
fipsdata = read.csv("nj-fips.csv", stringsAsFactors = FALSE)

# compute the New Jersey state population
statepop = sum(countydata$population)
countydata$popprop = countydata$population/statepop
# sort by population,highest first
countydata = countydata[sort.list(countydata$population, decreasing = TRUE),]

# New Jersey has 12 representatives
# ideally, each would have the same population
# which is the state population divided by 14
idealpop = round(statepop/12, digits = 0)

# set the lower and upper limits on population for a district
# plus or minus ten percent, rounded to the nearest thousand
over_lowerlimit = (0.9 * idealpop)%%1000  # modulus function employed
lowerlimit = (0.9 * idealpop) - over_lowerlimit
over_upperlimit = (1.1 * idealpop)%%1000  # modulus function employed
upperlimit = (1.1 * idealpop) - over_upperlimit
cat("\nideal population in each voting district:", idealpop, "\n")
cat("\npopulation lower and upper limits:", lowerlimit, upperlimit)

# county-by-county numbers of representatives
countydata$idealreps = countydata$population / idealpop
cat("\n\nCounties with the highest population\n")
print(head(countydata))

# sort by county name prior to merge with FIPS data
countysorted = countydata[(sort.list(countydata$county)),c("county","population","popprop","idealreps")]
fipssorted = fipsdata[(sort.list(fipsdata$countyname)),c("fips","countyname")]

# check for matching county names
for (icounty in seq(along = countysorted$county)) {
    if (countysorted$county[icounty] != fipssorted$countyname[icounty]) 
        cat("\n",countysorted$county[icounty], "not the same as", fipsdata$countyname[icounty])
}

# merge fips into the county data frames
fips = fipssorted$fips
allcountydata = cbind(countysorted, fips)


# define a data frame of county name and population
# data to go into the set partitioning problem
selectdata = allcountydata[(allcountydata$idealreps < 1), c("county", "population")]

# alphabetize by county name
selectdata = selectdata[(sort.list(selectdata$county)),]
cat("\n", nrow(selectdata), "counties to be assigned with set partitioning\n")

write.csv(selectdata, file = "data-for-set-partitioning.csv", row.names = FALSE)
