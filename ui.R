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

ui <- page_navbar(
    id = "onglets",
    title = "🧀 Mozzarella Sensory Analysis",
    theme = bs_theme(bootswatch = "flatly"),
    onglet_accueil,
    onglet_descriptive,
    onglet_analyse,
    onglet_recherche_opti
)
