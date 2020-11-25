#' BAtable
#'
#' Creates a data frame of linear assessment factor scores, CAT factor scores, and the mean and difference of paired scores. Used for calculating limits of agreement and creating Bland Altman plots.
#' @param x A vector of linear assessment scores
#' @param y A vector of CAT assessment scores
#' @return A data frame
#' @export

BAtable <- function (x,y) {

  compare_thetas <- as.data.frame(cbind(x, y))
  colnames(compare_thetas) <- c("Linear theta", "CAT theta")
  compare_thetas$Mean <- rowSums(compare_thetas)/2
  compare_thetas$Difference <- compare_thetas$"Linear theta" - compare_thetas$"CAT theta"
  return(compare_thetas)
}
