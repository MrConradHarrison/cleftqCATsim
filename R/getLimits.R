#' getLimits
#'
#' Calculates 95% limits of agreement
#' @param BAtable A dataframe produced by the BAtable() function
#' @return Lower and upper 95% limits of agreement (LoA)
#' @export

getLimits <- function (BAtable) {

  lower_LoA <- mean(BAtable$Difference) - 1.96*sd(BAtable$Difference)
  upper_LoA <- mean(BAtable$Difference) + 1.96*sd(BAtable$Difference)

  limits = c(lower_LoA, upper_LoA)
  names(limits) = c("Lower 95% LoA", "Upper 95% LoA")
  return(limits)
}
