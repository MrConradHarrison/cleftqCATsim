#' scoreDistribution
#'
#' Plots factor scores as a kernal density plot
#' @param scale Specifies which scale to use. Options are: "Face", "Jaw", "Teeth", "School", "Psych", "SDistress" (for speech distress), "SFunction" (for speech functin), or "Social"
#' @param result A list resturned by the linearAssessmet() function
#' @return A kernal density plot of factor scores
#' @export

scoreDistribution <- function(scale, result){

  linear_theta <- as.numeric(lapply(result, function(x) x$thetas[1]))
  linear_SEM <- as.numeric(lapply(result, function(x) x$SE_thetas[1]))
  theta_by_SEM <- as.data.frame(cbind(linear_theta, linear_SEM))


  if (scale == "Face"){
    title <-"Face scale score density"
  } else {
    if (scale == "Jaw"){
      title <- "Jaw scale score density"
    } else {
      if (scale == "Teeth"){
        title <- "Teeth scale score density"
      } else {
        if (scale == "School"){
          title <- "School Function score density"
        } else {
          if (scale == "Psych"){
            title <- "Psychological Function score density"
          } else {
            if (scale == "SDistress"){
              title <- "Speech Distress score density"
            } else {
              if (scale == "SFunction"){
                title <- "Speech Function score density"
              } else {
                if (scale == "Social"){
                  title <- "Social Function score density"
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



  plot <- ggplot(theta_by_SEM, aes(x=linear_theta)) +
    geom_density(color = "darkblue", fill = "skyblue", alpha = 0.2) +
    theme_minimal() +
    labs(title=title,x="Factor score", y = "Density")

  return(plot)



}
