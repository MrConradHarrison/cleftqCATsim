#' showOutliers
#'
#' Counts outliers by Mahalanobis distance in a sample of item responses
#' @param matrix A matrix of item responses, where each row represents a respondent and each column represents an item
#' @return Returns sample size, number of outliers, X2 test statistic and degrees of freedom
#' @export


showOutliers <- function(matrix) {

  mahal <- mahalanobis(matrix,
                       colMeans(matrix, na.rm = T),
                       cov(matrix, use = "pairwise.complete.obs"))

  cutoff = qchisq(1-.001, ncol(matrix))

  sample_size <- nrow(matrix)
  outliers <- summary(mahal < cutoff)[[2]]
  x2 <- cutoff
  df <- ncol(matrix)


  list <- list(sample_size, outliers, x2, df)
  names(list) <- c("sample_size", "outliers", "x2", "df")

  return(list)

}
