#' simCATlogits
#'
#' Performs a series of Monte Carlo simulations, using CATs developed from the Rasch models in the project folder. All possible fixed length stopping rules are tested for each scale. Expected a posteriori factor scores are generated and presented as logits. Item selection is by minimum expected posterior variance. CAT scores are compared to linear assessment scores through Pearson's correlation coefficient, RMSE and 95% limits of agreement. Standard error of measurement values for each score are also presented.
#' @param scale Specifies which scale to use. Options are: "Face", "Jaw", "Teeth", "School", "Psych", "SDistress" (for speech distress), "SFunction" (for speech functin), or "Social"
#' @param responses A matrix of responses, where each column represents an item from the full-length scale (ordered 1, 2, 3...) and each row represents a respondent
#' @param linear_result A list returned by the linearAssessment() function
#' @return A data frame of results
#' @import mirt
#' @import mirtCAT
#' @export

simCATlogits <- function(scale, responses, linear_result){

  # Import corresponding Rasch model

  if (scale == "Face"){
    rasch_model <- readRDS(system.file("extdata", "face_model.RDS", package = "cleftqCATsim"))
  } else {
    if (scale == "Jaw"){
      rasch_model <- readRDS(system.file("extdata", "jaw_model.RDS", package = "cleftqCATsim"))
    } else {
      if (scale == "Teeth"){
        rasch_model <- readRDS(system.file("extdata", "teeth_model.RDS", package = "cleftqCATsim"))
      } else {
        if (scale == "School"){
          rasch_model <- readRDS(system.file("extdata", "school_model.RDS", package = "cleftqCATsim"))
        } else {
          if (scale == "Psych"){
            rasch_model <- readRDS(system.file("extdata", "psych_model.RDS", package = "cleftqCATsim"))
          } else {
            if (scale == "SDistress"){
              rasch_model <- readRDS(system.file("extdata", "SD_model.RDS", package = "cleftqCATsim"))
            } else {
              if (scale == "SFunction"){
                rasch_model <- readRDS(system.file("extdata", "SF_model.RDS", package = "cleftqCATsim"))
              } else {
                if (scale == "Social"){
                  rasch_model <- readRDS(system.file("extdata", "social_model.RDS", package = "cleftqCATsim"))
                } else {
                  stop("Invalid scale name")
                }
              }
            }
          }
        }
      }
    }
  }

  # Import scale information from the input .csv file

  total_items <- scaleInfo(scale)[[6]]

  # Create a results table with placeholders

  results_table <- data.frame("Number of items" = rep("NA", total_items),
                              "Median SEM" = rep("NA", total_items),
                              "SEM IQR"= rep("NA", total_items),
                              "Correlation" = rep("NA", total_items),
                              "RMSE" = rep("NA", total_items),
                              "Lower LoA" = rep("NA", total_items),
                              "Upper LoA" = rep("NA", total_items))

  # Linear assessment results

  linear_theta <- as.numeric(lapply(linear_result, function(x) x$thetas[1]))
  linear_SEM <- as.numeric(lapply(linear_result, function(x) x$SE_thetas[1]))

  # Set fixed-length stopping rules
  stopping_rule <- c((total_items):1)

  message(paste0(total_items, " simulations to go!"))

  for (i in stopping_rule){

    design <- list(max_items = i)

    result <- mirtCAT(mo = rasch_model, method="EAP", criteria ="MEPV", start_item = "MEPV",
                      local_pattern = na.omit(responses), design = design, progress = TRUE)

    # Results
    cat_theta <- as.numeric(lapply(result, function(x) x$thetas[1]))
    cat_SEM <- as.numeric(lapply(result, function(x) x$SE_thetas[1]))
    r <- cor(linear_theta, cat_theta)
    RMSE <- sqrt(mean((linear_theta - cat_theta)^2))
    median_SEM <- median(cat_SEM)
    iqr_SEM <- IQR(cat_SEM)

    # Calculate 95% limits of agreement
    compare_thetas <- BAtable(linear_theta, cat_theta)
    LoA <- getLimits(compare_thetas)
    lower_LoA <- LoA[[1]]
    upper_LoA <- LoA[[2]]

    # Results table
    results <- c(i, median_SEM, iqr_SEM, r, RMSE, lower_LoA, upper_LoA)
    results_table[i,] <- results

    message(paste0(i-1, " simulations to go!"))

  }

  return(results_table)

}
