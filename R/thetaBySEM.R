#' thetaBySEM
#'
#' Plots standard error of measurement (SEM) against factor score
#' @param scale Specifies which scale to use. Options are: "Face", "Jaw", "Teeth", "School", "Psych", "SDistress" (for speech distress), "SFunction" (for speech functin), or "Social"
#' @param result A list resturned by the linearAssessmet() function
#' @return A scatterplot of SEM by factor score
#' @export



thetaBySEM <- function(scale, result){

  theta <- as.numeric(lapply(result, function(x) x$thetas[1]))
  SEM <- as.numeric(lapply(result, function(x) x$SE_thetas[1]))

  theta_by_SEM <- as.data.frame(cbind(theta, SEM))

  if (scale == "Face"){
    title <- "Face scale"
  } else {
    if (scale == "Jaw"){
      title <- "Jaw scale"
    } else {
      if (scale == "Teeth"){
        title <- "Teeth scale"
      } else {
        if (scale == "School"){
          title <- "School Function"
        } else {
          if (scale == "Psych"){
            title <- "Psychological Function"
          } else {
            if (scale == "SDistress"){
              title <- "Speech Distress"
            } else {
              if (scale == "SFunction"){
                title <- "Speech Function"
              } else {
                if (scale == "Social"){
                  title <- "Social Function"
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

  plot <- ggplot(theta_by_SEM, aes(x=theta, y=SEM)) +
    geom_point(alpha = 0.5, cex=2, color="darkblue") +
    theme_light() +
    labs(title=title,x="Factor score", y = "Standard error of measurement")

  return(plot)

}


