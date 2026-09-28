# ==================================================================================================
# APPLICATION SHINY : INTERFACE UTILISATEUR (UI)
# ==================================================================================================

library(shiny)
library(bslib)
library(DT)
library(plotly)

ui <- page_navbar(
    id = "onglets",
    title = "🧀 Mozzarella Sensory Analysis",
    theme = bs_theme(bootswatch = "flatly"),

    # ==================================================================================================
    # Onglet 1 : Page d'accueil
    # ==================================================================================================
    nav_panel(
        title = "Accueil",
        value = "accueil",
        icon = icon("house"),

        div(
            class = "container py-4 text-center",
            h1("🧀 Mozzarella Sensory Analysis"),
            p(
                class = "lead",
                "Le profil d'un jury entraîné permet-il de prédire l'appréciation des consommateurs sur 8 mozzarella sticks ?"
            ),
            img(src = "MZSTICK.jpg", style = "max-width: 400px; width: 100%; border-radius: 8px;", class = "my-3")
        ),

        # Boutons de navigation vers les onglets d'analyse
        layout_column_wrap(
            width = 1/3,
            card(
                card_header(icon("chart-simple"), "Analyse descriptive"),
                p("Notes des consommateurs et descripteurs du jury."),
                actionButton("go_descriptive", "Explorer", class = "btn-primary")
            ),
            card(
                card_header(icon("diagram-project"), "AFM"),
                p("Lien entre le jury et les consommateurs par Analyse Factorielle Multiple."),
                actionButton("go_afm", "Explorer", class = "btn-primary")
            ),
            card(
                card_header(icon("map"), "Cartographie des préférences"),
                p("Prédiction de l'appréciation à partir du profil sensoriel."),
                actionButton("go_carto", "Explorer", class = "btn-primary")
            )
        )
    ),

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
            p("À compléter : graphes et sorties de l'AFM.")
        )
    ),

    # ==================================================================================================
    # Onglet 4 : Cartographie des préférences
    # ==================================================================================================
    nav_panel(
        title = "Cartographie des préférences",
        value = "carto",
        icon = icon("map"),
        p("À compléter : Cartographie des préférences et segmentation.")
    )
)
