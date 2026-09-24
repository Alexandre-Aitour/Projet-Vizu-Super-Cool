# ==================================================================================================
# IMPORT DES LIBRAIRIES 
# ==================================================================================================

library(shiny)
library(bslib)
library(DT)
library(plotly)

# ==================================================================================================
# Interface utlisateur
# ==================================================================================================


ui <- page_navbar(
    title = "🧀 Mozzarella Sensory Analysis",
    theme = bs_theme(bootswatch = "flatly"),

    # ==================================================================================================
    # Onglet 1 : Vue d'ensemble
    # ==================================================================================================
    nav_panel(
        title = "Vue d'ensemble",
        icon = icon("table"),
        layout_column_wrap(
            width = 1/3, 
            value_box(title = "Consommateurs", value = "161", showcase = icon("users")),
            value_box(title = "Produits évalués", value = "8", showcase = icon("cheese")),
            value_box(title = "Descripteurs Jury", value = "37", showcase = icon("clipboard-check"))
        ),
        navset_card_tab(
            title = "Exploration des données",
            nav_panel("Données Consommateurs", DTOutput("dta_conso")),
            nav_panel("Descripteurs Jury", DTOutput("dta_panel"))
        )
    )


)