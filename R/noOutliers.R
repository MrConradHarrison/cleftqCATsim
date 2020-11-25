#' noOutliers
#'
#' Remove outliers from a validation dataset by Mahalanobis distance
#' @param matrix A matrix of response options, where each column represents an item and each row represents a respondent
#' @return Returns a matrix with outliers removed
#' @export

noOutliers <- function(matrix) {

  mahal <- mahalanobis(matrix,
                       colMeans(matrix, na.rm = T),
                       cov(matrix, use = "pairwise.complete.obs"))

  cutoff = qchisq(1-.001, ncol(matrix))

  return(subset(matrix, mahal < cutoff))

}

