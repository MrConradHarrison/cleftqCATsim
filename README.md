
# cleftqCATsim

Welcome to cleftqCATsim, an R package for evaluating the performance of the CLEFT-Q computerised adaptive test. Please follow this vignette to recreate our validation study from your own data, or explore the functions above for a more in-depth understanding of our methodology.

## Installation 

Install and load the cleftqCATsim package using the following code

``` 
devtools::install_github("MrConradHarrison/cleftqCATsim")
library(cleftqCATsim)
```

## Load scale information

Extract scale information from input CSV file using the scaleInfo function

```
face <- scaleInfo("Face")
jaw <- scaleInfo("Jaw")
teeth <- scaleInfo("Teeth")
school <- scaleInfo("School")
psych <- scaleInfo("Psych")
speech_distress <- scaleInfo("SDistress")
speech_function <- scaleInfo("SFunction")
social <- scaleInfo("Social")
```

## Import validation responses

Import your CLEFT-Q CAT validation responses. These should be csv files without row or column names. In these files, each row should represent a respondent and each column should represent an item from the scale. The columns should be arranged left to right in order from first to last item. Missing responses can be left blank. 

```
face_val <- as.matrix(na.omit(read.csv("file name.csv", header = FALSE)))
```

## Simulate a linear assessment

Linear assessments can be performed using the linearAssessment function.
Store the results as an object, for example

```
linear_results <- linearAssessment("Face", face_val)
```

At this point, the you can produce a kernel density plot of validation dataset factor scores using the scoreDistribution function. Factor scores are presented in logits.

```
scoreDistribution("Face", linear_results)
```

<img src="https://raw.githubusercontent.com/MrConradHarrison/cleftqCATsim/main/man/figures/KDplot.png" width="500">


Standard error of measurement can be plotted against factor score using the thetaBySEM function

```
thetaBySEM("Face", linear_results)
```

<img src="https://raw.githubusercontent.com/MrConradHarrison/cleftqCATsim/main/man/figures/thetaBySEM.png" width="500">

## CAT simulation

The CAT Monte Carlo simulations can be performed using the simCATlogits function

```
results <- simCATlogits("Face", face_val, linear_results)
results
```

This returns RMSE and 95% limits of agreement in logits. Alternatively, RMSE and limits of agreement can be presented as transformed, 0-100, CLEFT-Q units by using the the simCATtransformed function

```
results <- simCATtransformed("Face", face_val, linear_results)
results
```
```
 Number.of.items       Correlation             RMSE         Lower.LoA        Upper.LoA
1               1 0.811859111854437 12.6420064340581 -23.7021368059622 25.7384344466156
2               2 0.912089764302661 8.79520988256692 -17.4163877516852 17.0860792217396
3               3 0.949474241464606 6.76451185893374   -13.48649353589 13.0400325558537
4               4 0.963663880753248 5.70875088444198  -11.557034217027 10.7911539992411
5               5 0.971782033367089 5.06527267734184 -10.4109255434765 9.35466420046376
6               6 0.982813292737257 4.01471883599878 -8.48249557721829 6.99792207449597
7               7 0.989170257410496  3.1945393517206  -6.7974220879093 5.45803914780041
8               8   0.9971349005677 1.66745293008444  -3.5162826372423 2.92100133052724
9               9                 1                0                 0                0
```

Bland Altman plots can be created using the plotBA function, for example the following plot compares transformed linear assessment and CAT scores for the Face scale, with CAT assessments terminating after 7 items

```
plotBA("Face", face_val, stopping_rule = 7)
```
<img src="https://raw.githubusercontent.com/MrConradHarrison/cleftqCATsim/main/man/figures/BA.png" width="500">
