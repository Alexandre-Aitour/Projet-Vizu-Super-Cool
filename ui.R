#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define UI for application that draws a histogram
fluidPage(
  div(
    style = "text-align: center;",
    div(
      style = "position: relative; display: inline-block; width: 70%;",
      tags$img(src = "MZSTICK.jpg", width = "100%"),
      h1(
        "MozzaStick",
        style = "position: absolute; top: 30%; left: 50%;
                 transform: translate(-50%, -50%); margin: ;
                 color: white; text-shadow: 2px 2px 8px black;"
      )
    )
  )
)
