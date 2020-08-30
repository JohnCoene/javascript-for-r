library(shiny)

switchInput <- function(id, label, checked = TRUE) {

  input <- tags$input(
    id = id, 
    type = "checkbox", 
    class = "switchInput"
  )

  if(checked)
    input <- htmltools::tagAppendAttributes(input, checked = NA)

  form <- tagList(
    p(label),
    tags$label(
      class = "switch",
      input,
      tags$span(class = "slider")
    )
  )

  path <- normalizePath("./assets")

  deps <- htmltools::htmlDependency(
    name = "switchInput",
    version = "1.0.0",
    src = c(file = path),
    script = "binding.js",
    stylesheet = "styles.css"
  )

  htmltools::attachDependencies(form, deps)
}

update_switch_input <- function(id, value, session = shiny::getDefaultReactiveDomain()){
  session$sendInputMessage(id, value)
}

ui <- fluidPage(
  actionButton("chg", "Switch ON"),
  switchInput("switch", "Switch input", FALSE),
  plotOutput("plot")
)

server <- function(input, output, session){

  output$plot <- renderPlot({
    print(input$switch)
    
    if(!input$switch)
      return()

    plot(cars)
  })

  observeEvent(input$chg, {
    update_switch_input("switch", TRUE, session)
  })
}

shinyApp(ui, server)
