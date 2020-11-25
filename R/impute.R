#' impute
#'
#' Imputes missing item responses using multiple imputation with chained equations
#' @param df A dataframe containing item responses with missing data labelled as NA
#' @return Returns the imputed dataset
#' @importFrom mice mice
#' @export





impute <- function(df){

  tempmice <- mice(df)
  return(as.matrix(mice::complete(tempmice, 1)))

}
