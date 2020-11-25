#' simCATtransformed
#'
#' Similar to simCATlogits, but returns RMSE and 95% limits of agreement in transformed 0-100 CLEFT-Q units
#' @param scale Specifies which scale to use. Options are: "Face", "Jaw", "Teeth", "School", "Psych", "SDistress" (for speech distress), "SFunction" (for speech functin), or "Social"
#' @param responses A matrix of responses, where each column represents an item from the full-length scale (ordered 1, 2, 3...) and each row represents a respondent
#' @param linear_result A list returned by the linearAssessment() function
#' @return A data frame of results
#' @export


simCATtransformed <- function(scale, responses, linear_result){

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

  minimum_theta <- scaleInfo(scale)[[4]]
  maximum_theta <- scaleInfo(scale)[[5]]
  total_items <- scaleInfo(scale)[[6]]

  # Create a results table with placeholders

  results_table <- data.frame("Number of items" = rep("NA", total_items),
                              "Correlation" = rep("NA", total_items),
                              "RMSE" = rep("NA", total_items),
                              "Lower LoA" = rep("NA", total_items),
                              "Upper LoA" = rep("NA", total_items))

  # Linear assessment result

  linear_theta <- as.numeric(lapply(linear_result, function(x) x$thetas[1]))
  transformed_linear_theta <- round((100*(linear_theta - minimum_theta)/(maximum_theta - minimum_theta)), digits = 0)

  # Set fixed-length stopping rules
  stopping_rule <- c((total_items):1)

  message(paste0(total_items, " simulations to go!"))

  for (i in stopping_rule){

    design <- list(max_items = i)

    result <- mirtCAT(mo = rasch_model, method="EAP", criteria ="MEPV", start_item = "MEPV",
                      local_pattern = na.omit(responses), design = design, progress = TRUE)

    # Results
    cat_theta <- as.numeric(lapply(result, function(x) x$thetas[1]))
    transformed_cat_theta <- round((100*(cat_theta - minimum_theta)/(maximum_theta - minimum_theta)), digits = 0)
    r <- cor(transformed_linear_theta, transformed_cat_theta)
    RMSE <- sqrt(mean((transformed_linear_theta - transformed_cat_theta)^2))


    # Calculate 95% limits of agreement
    compare_thetas <- BAtable(transformed_linear_theta, transformed_cat_theta)
    LoA <- getLimits(compare_thetas)
    lower_LoA <- LoA[[1]]
    upper_LoA <- LoA[[2]]

    # Results table
    results <- c(i, r, RMSE, lower_LoA, upper_LoA)
    results_table[i,] <- results

    message(paste0(i-1, " simulations to go!"))

  }

  results_table

}
