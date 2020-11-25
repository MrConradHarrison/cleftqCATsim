#' plotBA
#'
#' Draws a Bland Altamn plot comparing transformed (0-100) CAT scores and linear assessments, for a given scale at a given fixed length stopping rule
#' @param scale Specifies which scale to use. Options are: "Face", "Jaw", "Teeth", "School", "Psych", "SDistress" (for speech distress), "SFunction" (for speech functin), or "Social"
#' @param responses A matrix of responses, where each column represents an item from the full-length scale (ordered 1, 2, 3...) and each row represents a respondent
#' @param stopping_rule A fixed-length stopping rule (number of items as an integer value)
#' @return A Bland Altman plot
#' @export

plotBA <- function (scale, responses, stopping_rule){

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

  # Linear assessment
  design <- list(max_items = total_items)
  result <- mirtCAT(mo = rasch_model, method="EAP", criteria ="MEPV", start_item = "MEPV",
                    local_pattern = responses, design = design, progress = TRUE)
  linear_theta <- as.numeric(lapply(result, function(x) x$thetas[1]))
  transformed_linear_theta <- round((100*(linear_theta - minimum_theta)/(maximum_theta - minimum_theta)), digits = 0)

  # Set fixed-length stopping rules

  design <- list(max_items = stopping_rule)

  result <- mirtCAT(mo = rasch_model, method="EAP", criteria ="MEPV", start_item = "MEPV",
                    local_pattern = responses, design = design, progress = TRUE)

  # Results
  cat_theta <- as.numeric(lapply(result, function(x) x$thetas[1]))
  transformed_cat_theta <- round((100*(cat_theta - minimum_theta)/(maximum_theta - minimum_theta)), digits = 0)

  # Calculate 95% limits of agreement
  compare_thetas <- BAtable(transformed_linear_theta, transformed_cat_theta)

  plot <- BAplot(compare_thetas)
  return(plot)

}

