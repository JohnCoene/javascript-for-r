
<!-- badges: start -->
<!-- badges: end -->

# ml

Example of using JavaScript for machine learning computations.

## Example

``` r
library(ml)

# first model
model_cars <- ml_simple_lm(cars$speed, cars$dist)

predict(model_cars, 15)
```

