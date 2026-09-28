# ==================================================================================================
# IMPORT DES LIBRAIRIES
# ==================================================================================================

library(shiny)
library(bslib)
library(DT)
library(plotly)

source("ui_accueil.R", local = TRUE)

# ==================================================================================================
# Interface utlisateur
# ==================================================================================================


ui <- page_navbar(
    id = "onglets",
    title = "🧀 Mozzarella Sensory Analysis",
    theme = bs_theme(bootswatch = "flatly"),

    # ==================================================================================================
    # Onglet 1 : Accueil
    # ==================================================================================================
    onglet_accueil,

    # ==================================================================================================
    # Onglet 2 : Analyse descriptive (Consommateurs / Jury)
    # ==================================================================================================
    nav_panel(
        title = "Analyse descriptive",
        value = "descriptive",
        icon = icon("chart-simple"),
        layout_column_wrap(
            width = 1/3,
            value_box(title = "Consommateurs", value = "161", showcase = icon("users")),
            value_box(title = "Produits évalués", value = "8", showcase = icon("cheese")),
            value_box(title = "Descripteurs Jury", value = "37", showcase = icon("clipboard-check"))
        ),
        navset_card_tab(
            # ---------------------------------------- Partie Consommateurs
            nav_panel(
                "Consommateurs",
                layout_sidebar(
                    sidebar = sidebar(
                        selectInput(
                            "dim_choisis", "Dimension",
                            choices = c("Overall", "Appearance", "Flavor", "Texture")
                        ),
                        checkboxGroupInput(
                            "prods_choisis", "Produits",
                            choices = levels(dta_cons$Prod.ID),
                            selected = levels(dta_cons$Prod.ID)
                        )
                    ),
                    plotlyOutput("plot_boxplot_conso"),
                    verbatimTextOutput("stat_anova"),
                    DTOutput("dta_conso")
                )
            ),
            # ---------------------------------------- Partie Jury
            nav_panel(
                "Jury",
                DTOutput("dta_panel")
            )
        )
    ),

    # ==================================================================================================
    # Onglet 3 : Analyse Factorielle Multiple (AFM)
    # ==================================================================================================
    nav_panel(
        title = "AFM",
        value = "afm",
        icon = icon("diagram-project"),
        layout_sidebar(
            sidebar = sidebar(
                radioButtons(
                    "type_afm", "Type d'AFM",
                    choices = c("Par sens" = "sens", "Jury vs Consommateurs" = "jury")
                )
            ),
            p("À compléter : graphes de l'AFM.")
        )
    ),

    # ==================================================================================================
    # Onglet 4 : Cartographie des préférences
    # ==================================================================================================
    nav_panel(
        title = "Cartographie des préférences",
        value = "carto",
        icon = icon("map"),
        p("À compléter.")
    )
)
