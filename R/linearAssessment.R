#' linearAssessment
#'
#' Simulates a linear assessment for a specified CLEFT-Q scale and set of responses
#' @param scale Specifies which scale to use. Options are: "Face", "Jaw", "Teeth", "School", "Psych", "SDistress" (for speech distress), "SFunction" (for speech functin), or "Social"
#' @param responses A matrix of responses, where each column represents an item from the full-length scale (ordered 1, 2, 3...) and each row represents a respondent
#' @return Returns a list of results from the mirtCAT::mirtCAT() function
#' @export

linearAssessment <- function (scale, responses){

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

  # Linear assessment
  design <- list(max_items = total_items)
  result <- mirtCAT(mo = rasch_model, method="EAP", criteria ="MEPV", start_item = "MEPV",
                    local_pattern = na.omit(responses), design = design, progress = TRUE)
  return(result)

}

