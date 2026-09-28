# ==================================================================================================
# APPLICATION SHINY : SERVEUR COMMUN
# Ne pas modifier : chaque onglet se code dans son dossier onglets/<onglet>/server_<onglet>.R
# ==================================================================================================

server <- function(input, output, session) {
    source("onglets/accueil/server_accueil.R", local = TRUE)
    source("onglets/descriptive/server_descriptive.R", local = TRUE)
    source("onglets/analyse/server_analyse.R", local = TRUE)
    source("onglets/recherche_opti/server_recherche_opti.R", local = TRUE)
}
