# ==================================================================================================
# Onglet : Accueil
# Préfixe des identifiants : accueil_
# ==================================================================================================

onglet_accueil <- nav_panel(
    title = "Accueil",
    value = "accueil",
    icon = icon("house"),

    # Recherche optimale au centre
    layout_columns(
        col_widths = c(-4, 4, -4),
        actionButton("accueil_go_recherche_opti", "Recherche optimale", class = "btn-primary btn-lg")
    ),

    # Analyse descriptive en bas à gauche, Analyse en bas à droite
    layout_columns(
        col_widths = c(6, 6),
        actionButton("accueil_go_descriptive", "Analyse descriptive", class = "btn-primary btn-lg"),
        actionButton("accueil_go_analyse", "Analyse", class = "btn-primary btn-lg")
    )
)
