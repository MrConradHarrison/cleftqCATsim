#' getRasch
#'
#' Provides Rasch model item parameters
#' @param list A value returned from the scaleInfo() function
#' @param df A dataframe containing calibration item responses where each row represents a respondent and each column represents an item
#' @return Returns Rasch model fit statistics and item parameters
#' @export


getRasch <- function(list, df){


  col_range <- list[[3]]
  item_responses <- na.omit(calibration_responses[,col_range])
  rasch_model <- mirt(item_responses, model = 1, itemtype = "Rasch")
  print(as.list(M2(rasch_model)))
  print(coef(rasch_model, IRT = TRUE, simplify = TRUE))
  return(rasch_model)

}
