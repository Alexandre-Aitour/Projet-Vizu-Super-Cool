# ==================================================================================================
# APPLICATION SHINY : INTERFACE UTILISATEUR (UI) COMMUNE
# Ne pas modifier : chaque onglet se code dans son dossier onglets/<onglet>/ui_<onglet>.R
# ==================================================================================================

library(shiny)
library(bslib)

source("onglets/accueil/ui_accueil.R", local = TRUE)
source("onglets/descriptive/ui_descriptive.R", local = TRUE)
source("onglets/analyse/ui_analyse.R", local = TRUE)
source("onglets/recherche_opti/ui_recherche_opti.R", local = TRUE)

# Pas de barre de menu : on navigue depuis les boutons de l'accueil puis avec les mozzasticks
# de chaque en-tête (nav_stick() dans onglets/accueil/ui_accueil.R)
ui <- page(
    title = "Mozzarella Sensory Analysis",
    theme = bs_theme(bootswatch = "flatly"),
    div(
        class = "p-3",
        navset_hidden(
            id = "onglets",
            onglet_accueil,
            onglet_descriptive,
            onglet_analyse,
            onglet_recherche_opti
        )
    )
)
