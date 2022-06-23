## Create a synthetic market basket for Apriori algorithm


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
    row.count <- acs.df[i, colname]
    
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
    write.table(final.df, file="data/acs_market_basket.csv", eol = "\n", quote = FALSE, sep = ",", 
                row.names = FALSE, col.names = FALSE, append = TRUE)
  
  }
}

# create data frame (for testing)
acs.df <- data.frame(County = c("Rockland County","Yates County"), Over65_Male_Employed = c(1,1))
colval.names <- colnames(acs.df)

for (c in colval.names[-c(1)]) {
  create_market_basket(c)
}

#txn <- read.transactions("data/acs_market_basket.csv")
#inspect(txn)


