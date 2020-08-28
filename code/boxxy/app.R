library(shiny)

boxxy <- function(title, value, color = NULL, animate = TRUE){

  value <- sum(value)

  # dynamic color
  if(is.null(color))
    if(value > 100)
      color <- "#ef476f"
    else
      color <- "#06d6a0"

  list(title = title, value = value, color = color, animate = animate)
}

boxxyOutput <- function(id){
  el <- shiny::tags$div(
    id = id, class = "boxxy",
    h1(id = sprintf("%s-boxxy-value", id), class = "boxxy-value"),
    p(id = sprintf("%s-boxxy-title", id), class = "boxxy-title")
  )

  path <- normalizePath("assets")

  deps <- list(
    htmltools::htmlDependency(
      name = "boxxy",
      version = "1.0.0",
      src = c(file = path),
      script = c("binding.js"), # only binding
      stylesheet = "styles.css"
    )
  )

  htmltools::attachDependencies(el, deps)
}

renderBoxxy <- function(expr, env = parent.frame(), quoted = FALSE) {
  # Convert the expression + environment into a function
  func <- shiny::exprToFunction(expr, env, quoted)

  function(){
    val <- func()

    if(val$animate){
      path <- normalizePath("assets")

      deps <- htmltools::htmlDependency(
        name = "countup",
        version = "1.8.2",
        src = c(file = path),
        script = c("countup.js"), # only countup
        stylesheet = "styles.css"
      )

      val$deps <- lapply(
        htmltools::resolveDependencies(list(deps)),
        shiny::createWebDependency
      )
    }

    return(val)
  }
}

ui <- fluidPage(
  h2("Custom outputs"),
  fluidRow(
    column(
      3, boxxyOutput("countries")
    ),
    column(
      3, boxxyOutput("employees")
    ),
    column(
      3, boxxyOutput("customers")
    ),
    column(
      3, boxxyOutput("subs")
    )
  )
)

server <- function(input, output){
  output$countries <- renderBoxxy({
    boxxy("Countries", 95, color = "#ef476f", animate = FALSE)
  })

  output$employees <- renderBoxxy({
    boxxy("Thing", 650, color = "#06d6a0")
  })

  output$customers <- renderBoxxy({
    boxxy("Customers", 13592, color = "#118ab2")
  })

  output$subs <- renderBoxxy({
    boxxy("Subscriptions", 16719, color = "#ffd166")
  })
}

shinyApp(ui, server)