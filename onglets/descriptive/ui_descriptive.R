# ==================================================================================================
# Onglet : Analyse descriptive
# Préfixe des identifiants : descriptive_
# ==================================================================================================

onglet_descriptive <- nav_panel(
    title = "Analyse descriptive",
    value = "descriptive",
    icon = icon("chart-simple"),
    navset_card_tab(
        # ---------------------------------------- Partie Consommateurs
        nav_panel(
            "Consommateurs",
            p("À compléter.")
        ),
        # ---------------------------------------- Partie Jury
        nav_panel(
            "Jury",
            p("À compléter.")
        )
    )
)
