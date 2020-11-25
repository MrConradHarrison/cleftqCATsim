#' scaleInfo
#'
#' Gets all scale information required for Monte Carlo CAT simulations
#' @param chr The name of a scale included in the 2017 ICHOM Standard Set for cleft lip and/or palate. Possible arguments include: "Face", "Jaw", "Teeth", "School", "Psych", "SDistress", "SFunction" or "Social"
#' @return A list containing scale name, validation response file name, calibration dataset columns corresponding to item responses, minimum factor score (EAP), maximum factor score (EAP) and total number of items.
#' @export


scaleInfo <- function(chr){

  if(chr == "Face"){
    x = 1
  } else {
    if(chr == "Jaw"){
      x = 2
    } else {
      if(chr == "Teeth"){
        x = 3
      } else {
        if(chr == "School"){
          x = 4
        } else {
          if(chr == "Psych"){
            x = 5
          } else {
            if(chr == "SDistress"){
              x = 6
            } else {
              if(chr == "SFunction"){
                x = 7
              } else {
                if(chr == "Social"){
                  x = 8
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



  input_vectors <- read.csv(system.file("extdata", "input_vectors.csv", package = "cleftqCATsim"))
  scale_name <- input_vectors[x,1]
  validation_filename <- input_vectors[x,2]
  first_col <- input_vectors[x,3]
  last_col <- input_vectors[x,4]
  col_range <- c(as.numeric(first_col):as.numeric(last_col))
  minimum_theta <- input_vectors[x,5]
  maximum_theta <- input_vectors[x,6]
  total_items <- input_vectors[x,7]

  list <- list(scale_name, validation_filename, col_range, minimum_theta, maximum_theta, total_items)
  names(list) <- c("scale_name", "validation_filename", "col_range", "minimum_theta", "maximum_theta", "total_items")
  return(list)

}

