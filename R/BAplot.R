#' BAplot
#'
#' Draws a Bland Altman plot using the output of the BAtable() function
#' @param df A data frame returned by the BAtable() function
#' @return A Bland Altman plot
#' @import ggplot2
#' @export


BAplot <- function (df){

  limits <- getLimits(df)

  plot <- ggplot(df, aes(x = Mean, y = Difference)) +
    geom_point(alpha = 0.3, color = "darkblue") +
    theme_light() +
    geom_hline(yintercept = mean(df$Difference), colour = "black", size = 0.5) +
    geom_hline(linetype = "longdash", yintercept = limits[1], colour = "grey30", size = 0.5) +
    geom_hline(linetype = "longdash", yintercept = limits[2], colour = "grey30", size = 0.5) +
    annotate("text", label = paste0(round((mean(df$Difference) - (1.96 * sd(df$Difference))), digits = 2)), x = (0.9 * min(df$Mean)), y = 0.9 * (mean(df$Difference) - (1.96 * sd(df$Difference)))) +
    annotate("text", label = paste0(round((mean(df$Difference) + (1.96 * sd(df$Difference))), digits = 2)), x = (0.9 * min(df$Mean)), y = 1.1 * (mean(df$Difference) + (1.96 * sd(df$Difference)))) +
    annotate("text", label = paste0(round(mean(df$Difference), digits = 2)), x = (0.9 * min(df$Mean)), y = (mean(df$Difference))+ 0.1*(mean(df$Difference) + 1.96 * sd(df$Difference))) +
    ylab("Difference") +
    xlab("Mean")

  return(plot)

}
