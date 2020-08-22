library(shiny)

boxxy <- function(title, value, color = "black"){
  list(title = title, value = value, color = color)
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
      script = c("countup.js", "binding.js"),
      stylesheet = "styles.css"
    )
  )

  htmltools::attachDependencies(el, deps)
}

renderBoxxy <- function(expr, env = parent.frame(), quoted = FALSE) {
  # Convert the expression + environment into a function
  func <- shiny::exprToFunction(expr, env, quoted)

  function(){
    func()
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
    boxxy("Countries", 95, color = "#ef476f")
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