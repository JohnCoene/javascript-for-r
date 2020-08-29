library(shiny)

textInputPlus <- function(id, extra = "@", placeholder = "placeholder", 
  position = c("start", "end")) {
  
  position <- match.arg(position)

  aria <- sprintf("%s-aria", id)

  extra <- span(class="input-group-addon", id = aria, extra)
  
  el <- tags$input(
    type = "text",
    class = "form-control text-plus",
    placeholder = placeholder,
    `aria-describedby` = aria
  )

  if(position == "start")
    el <- tagList(extra, el)
  else 
    el <- tagList(el, extra)

  form <- div(class = "input-group", el)

  path <- normalizePath("./assets")

  deps <- htmltools::htmlDependency(
    name = "textInputPlus",
    version = "1.0.0",
    src = c(file = path),
    script = c("binding.js")
  )

  htmltools::attachDependencies(form, deps)
}

ui <- fluidPage(
  textInputPlus("txt")
)

server <- function(input, output){
  observeEvent(input$txt, {
    input$txt
  })
}

shinyApp(ui, server)
