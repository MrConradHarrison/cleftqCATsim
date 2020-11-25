#' rescore
#'
#' Rescore item responses in the Speech Distress and Speech Function scales (collapses response options 2 and 3, then reverses scoring)
#' @param df A dataframe containing item responses (1,2,3 and 4) to the field test version of CLEFT-Q Speech Distress and Speech Function scales
#' @return The rescored item responses
#' @export


rescore <- function(df){

  df[df == 3] <- 2
  df[df == 4] <- 3
  df[df == 1] <- 4
  df[df == 3] <- 1
  df[df == 4] <- 3

  return(df)

}
