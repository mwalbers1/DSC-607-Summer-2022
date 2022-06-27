## Create a synthetic market basket for Apriori algorithm

#library(stringr)

create_market_basket <- function(colname) {
  # Description: Create market basket transactions from ACS data frame. 
  #              Write output csv file
  # 
  # args: colname - The name of the column in ACS data frame
  #

  # split column name on underscore character
  col.tokens <- str_split(colname, "_", simplify=TRUE )
  
  number.cols <- length(col.tokens) + 1
  
  # create data frame with 0 rows
  output.df <- data.frame(matrix(ncol = number.cols, nrow = 0))
  row.number <- nrow(output.df) + 1
  
  # iterate through acs.df data frame
  for (i in 1:nrow(acs.df))
  {
    county.name <- acs.df[i, "County"]
    
    acs.df.value <- acs.df[i, colname]
    row.count <- ifelse(is.na(acs.df.value), 0, acs.df.value)
    
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
      write.table(final.df, file="data/market_basket_nyc.csv", eol = "\n", quote = FALSE, sep = ",", 
                  row.names = FALSE, col.names = FALSE, append = TRUE)
  
    }
  }
}

# create data frame (for testing)
acs.df <- read.csv("data/Census_Nyc.csv")

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
                                    SalesOccupation,
                                    NaturalResourcesOccupation,
                                    AgricultureIndustry,
                                    MfgIndustry,
                                    WholesaleIndustry,
                                    WarehousingIndustry,
                                    InformationIndustry, 
                                    InsuranceIndustry, 
                                    OtherServicesIndustry,
                                    EntertainmentIndustry,
                                    Household.Income_Less10k, Household.Income_10to15k, 
                                    Household.Income_15to25k, Household.Income_25to35k,
                                    Household.Income_35to50k ))

colval.names <- colnames(acs.df.subset)


for (c in colval.names[-c(1)]) {
  create_market_basket(c)
}


# txn <- read.transactions("data/acs_market_basket.csv")
# inspect(txn)


