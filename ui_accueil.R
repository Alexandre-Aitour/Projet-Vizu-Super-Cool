# ==================================================================================================
# Page d'accueil
# ==================================================================================================
# Ma branche
onglet_accueil <- nav_panel(
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

    # Boutons de navigation vers les autres onglets
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
)

