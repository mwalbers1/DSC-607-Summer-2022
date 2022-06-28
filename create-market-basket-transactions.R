## Create a synthetic market basket for Apriori algorithm

#library(stringr)

create_market_basket <- function(source.df, colname, filename) {
  # Description: Create market basket transactions from ACS data frame. 
  #              Write output csv file
  # 
  # args: source.df:  source data frame 
  #       colname:    The name of the column in ACS data frame
  #       filename:   The name of output file to create
  #

  # split column name on underscore character
  col.tokens <- str_split(colname, "_", simplify=TRUE )
  
  number.cols <- length(col.tokens) + 1
  
  # create data frame with 0 rows
  output.df <- data.frame(matrix(ncol = number.cols, nrow = 0))
  row.number <- nrow(output.df) + 1
  
  # iterate through source.df data frame
  for (i in 1:nrow(source.df))
  {
    county.name <- source.df[i, "County"]
    
    source.df.value <- source.df[i, colname]
    row.count <- ifelse(is.na(source.df.value), 0, source.df.value)
    
    if (row.count != 0) {
      if (length(col.tokens) == 1) {
        output.df[row.number,] <- c(county.name, col.tokens[1])
      }
      else if (length(col.tokens) == 2) {
        output.df[row.number,] <- c(county.name, col.tokens[1], col.tokens[2])
      } 
      else if (length(col.tokens) == 3) {
        output.df[row.number,] <- c(county.name, col.tokens[1], col.tokens[2], col.tokens[3])
      }
      else if (length(col.tokens) == 4) {
        output.df[row.number,] <- c(county.name, col.tokens[1], col.tokens[2], col.tokens[3], col.tokens[4])
      }
    
      # replicate new row
      final.df <- output.df[rep(row.number, row.count),]
      
      # write final.df to csv file
      write.table(final.df, file=filename, eol = "\n", quote = FALSE, sep = ",", 
                  row.names = FALSE, col.names = FALSE, append = TRUE)
  
    }
  }
}


market_basket_wrapper <- function(input.filename, output.filename) {
  # Description: Wrapper function for creating new market basket CSV file
  #
  # args: input.filename
  #       output.filename
  #
  #
  
  # set output file name and remove file from previous run
  unlink(output.filename)
  
  # create data frame
  acs.df <- read.csv(input.filename)
  
  # Create Household.Income_Less50k
  acs.df$Household.Income_Less50k <- acs.df$Household.Income_Less10k + acs.df$Household.Income_10to15k + 
                                    acs.df$Household.Income_15to25k + acs.df$Household.Income_25to35k +
                                    acs.df$Household.Income_35to50k
  
  acs.df.subset <- subset(acs.df,
                          select = -c(Households_WithUnder18,
                                      Households_WithOver65,
                                      Over16,
                                      Over16_Female,
                                      Over16_Female_Employed,
                                      Over16_Employed,
                                      Over16_ArmedForces,
                                      Under5,
                                      Age5to9,
                                      Age10to14,
                                      Age15to19,
                                      Age20to24,
                                      Age25to34,
                                      Age35to44,
                                      Age45to54,
                                      Age55to59,
                                      Age60to64,
                                      Over65,
                                      Under18,
                                      Over18,
                                      Over18_Male,
                                      Over18_Female,
                                      Over15_Male,
                                      Over15_Female,
                                      Over15_Male_Married,
                                      Over15_Female_Married,
                                      Nursery.preschool.enrollment,
                                      Kindergarten.enrollment,
                                      Householder_Children6to17,
                                      Total.Population,
                                      Total.Population.Male,
                                      Total.Population.Female,
                                      White,
                                      Asian,
                                      Native.American,
                                      BusinessOccupation,
                                      SalesOccupation,TransportationOccupation,
                                      NaturalResourcesOccupation,ServiceOccupation,
                                      AgricultureIndustry,
                                      MfgIndustry,
                                      WholesaleIndustry,
                                      WarehousingIndustry,
                                      InformationIndustry, 
                                      InsuranceIndustry, 
                                      OtherServicesIndustry,
                                      EntertainmentIndustry,
                                      WasteManagementIndustry,
                                      Household.Income_Less10k, Household.Income_10to15k, 
                                      Household.Income_15to25k, Household.Income_25to35k,
                                      Household.Income_35to50k,
                                      Age19to64_Employed,
                                      Elementary.school.enrollment,
                                      Householder_ChildrenUnder6,
                                      Cohabiting.household))
  
  colval.names <- colnames(acs.df.subset)
  
  for (c in colval.names[-c(1)]) {
    create_market_basket(acs.df, c, output.filename)
  }

}


# Create Market basket file for NY other
census.filename <- "data/Census_Ny_Other.csv"
market_basket.filename <- "data/market_basket_ny_other.csv"
market_basket_wrapper(census.filename, market_basket.filename)

# Create Market basket file for NYC
# census.filename.nyc <- "data/Census_Nyc.csv"
# market_basket.nyc.filename <- "data/market_basket_nyc.csv"
# market_basket_wrapper(census.filename.nyc, market_basket.nyc.filename)



