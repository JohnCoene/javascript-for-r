\mainmatter

# (PART) Basics & Roadmap {-}

# Overview {#intro-overview}



This book starts with a rationale for integrating JavaScript with R and supports it with examples, namely packages that use JavaScript and are available on CRAN. Then, we list the various ways in which one might go about making both languages work together. In the next chapter, we go over prerequisites and a review of concepts fundamental to fully understand the more advanced topics residing in the forthcoming chapters. 

## Rationale {#intro-overview-rationale}

Why blend two languages seemingly so far removed from each other? Well, precisely because they are fundamentally different languages that each have their strengths and weaknesses, combining the two allows making the most of their consolidated advantages and circumvent their respective limitations to produce software altogether better for it. 

Nevertheless, a fair reason to use JavaScript might be that the thing one wants to achieve in R has already been realised in JavaScript. Why reinvent the wheel when the solution already exists and that it can be made accessible from R? The R package [rmapshaper](https://github.com/ateucher/rmapshaper) [@R-rmapshaper] by Andy Teucher that integrates [mapshaper](https://github.com/mbloch/mapshaper/), a library to edit geo-spatial-related files such as GeoJSON, or TopoJSON. JavaScript is by no means required to make those computations, they could be rewritten solely in R, but that would be vastly more laborious than wrapping the JavaScript API in R as done by the package rmapshaper.


```r
library(rmapshaper)

# get data
data(states, package = "geojsonio")

states_json <- geojsonio::geojson_json(
  states, 
  geometry = "polygon", 
  group = "group"
)
#> Registered S3 method overwritten by 'dplyr':
#>   method         from       
#>   print.location geojsonlint
#> Registered S3 method overwritten by 'geojsonsf':
#>   method        from   
#>   print.geojson geojson
#> Assuming 'long' and 'lat' are longitude and latitude, respectively

states_sp <- geojsonio::geojson_sp(states_json)

# print shape file size
print(object.size(states_sp), units = "Mb")
#> 0.4 Mb

# simplify with rmapshaper
states_sm <- rmapshaper::ms_simplify(states_sp, keep = 0.05)

# print reduced size
print(object.size(states_sm), units = "Mb")
#> 0.2 Mb
```

Another great reason is that JavaScript can do things that R cannot, e.g., run in the browser. Therefore one cannot natively create interactive visualisations with R. [Plotly](https://plotly-r.com/) [@R-plotly] by Carson Sievert packages the [plotly JavaScript library](https://plot.ly/) to let one create interactive visualisations solely from R code.


```r
library(plotly)

plot_ly(diamonds, x = ~cut, color = ~clarity, width = "100%")
```

\begin{figure}[H]

{\centering \includegraphics[width=1\linewidth]{images/01-plotly} 

}

\caption{Basic htmlwidget example}(\#fig:plotly-basic-example)
\end{figure}

Finally, JavaScript can work together with R to improve how we communicate insights. One of the many ways in which Shiny stands out is that it lets one create web applications solely from R code with no knowledge of HTML, CSS, or JavaScript but that does not mean they can't extend Shiny, quite the contrary. The [waiter package](http://waiter.john-coene.com/) [@R-waiter] integrates a variety of JavaScript libraries to display loading screens in Shiny applications.

```r
library(shiny)
library(waiter)

ui <- fluidPage(
  use_waiter(), # include dependencies
  actionButton("show", "Show loading for 3 seconds")
)

server <- function(input, output, session){
  # create a waiter
  w <- Waiter$new()

  # on button click
  observeEvent(input$show, {
    w$show()
    Sys.sleep(3)
    w$hide()
  })
}

shinyApp(ui, server)
```

\begin{figure}[H]

{\centering \includegraphics[width=1\linewidth]{images/waiter} 

}

\caption{Waiter screen}(\#fig:intro-waiter)
\end{figure}

Hopefully this makes a couple of great reasons and alluring examples to entice the reader to persevere with this book.

## Methods {#intro-methods}

Though perhaps not evident at first, all of the packages used as examples in the previous section interfaced with R very differently. As we'll discover, there are many ways in which one can blend JavaScript with R. Generally the way to go about it is dictated by the nature of what is to be achieved.

Let's list the methods available to us to blend JavaScript with R before covering each of them in-depth in their own respective chapter later in the book.

### V8 {#intro-v8}

[V8](https://github.com/jeroen/v8) by Jeroen Ooms is an R interface to Google's JavaScript engine. It will let you run JavaScript code directly from R and get the result back; it even comes with an interactive console. This is the way the rmapshaper package used in a previous example internally interfaces with the turf.js library.


```r
library(V8)
#> Using V8 engine 6.8.275.32-node.55

ctx <- v8()

ctx$eval("2 + 2") # this is evaluated in JavaScript!
#> [1] "4"
```

### htmlwidgets {#intro-htmlwidgets}

[htmlwidgets](http://www.htmlwidgets.org/) [@R-htmlwidgets] specialises in wrapping JavaScript libraries that generate visual outputs. This is what packages such as plotly, [DT](https://rstudio.github.io/DT/) [@R-DT], [highcharter](http://jkunst.com/highcharter/) [@R-highcharter], and many more use to provide interactive visualisation with R.

It is by far the most popular integration out there: at the time of writing it has been downloaded nearly 10 million times from CRAN. It will therefore be covered extensively in later chapters.

### Shiny {#intro-shiny}

The Shiny framework allows creating applications accessible from web browsers where JavaScript natively runs; it follows that JavaScript can run _alongside_ such applications. Often overlooked though, the two can also work _hand-in-hand_ as one can pass data from the R server to the JavaScript front-end and vice versa. This is how the package waiter mentioned previously internally works with R.

## Methods Amiss {#intro-amiss}

Note that there are also two other prominent ways one can use JavaScript with R that are not covered in this book. The main reason being that they require significant knowledge of specific JavaScript libraries, d3.js and React, and while these are themselves advanced uses of JavaScript, their integration with R via the packages listed below are relatively straightforward.

### reactR & vueR {#intro-reactr-vuer}

[ReactR](https://react-r.github.io/reactR/) [@R-reactR] is an R package that emulates very well htmlwidgets but specifically for the [React framework](https://reactjs.org/). Unlike htmlwidgets, it is not limited to visual outputs and also provides functions to build inputs, e.g., a drop-down menu (like `shiny::selectInput`). The [reactable package](https://glin.github.io/reactable/) [@R-reactable] uses reactR to enable building interactive tables solely from R code.


```r
reactable::reactable(iris[1:5, ], showPagination = TRUE)
```

\begin{figure}[H]

{\centering \includegraphics[width=1\linewidth]{images/01-reactable} 

}

\caption{reactable package example}(\#fig:reactable-example)
\end{figure}

There is also the package vueR [@R-vueR] which brings some of Vue.js to R.

### r2d3 {#intro-r2d3}

[r2d3](https://rstudio.github.io/r2d3/) [@R-r2d3] by RStudio is an R package designed specifically to work with [d3.js](https://d3js.org/). It is similar to htmlwidgets but works rather differently.


```r
# https://rstudio.github.io/r2d3/articles/gallery/chord/
r2d3::r2d3(
  data = matrix(round(runif(16, 1, 10000)), ncol = 4, nrow = 4), 
  script = "chord.js"
)
```

\begin{figure}[H]

{\centering \includegraphics[width=1\linewidth]{images/01-d3} 

}

\caption{r2d3 basic example}(\#fig:r2d3)
\end{figure}
