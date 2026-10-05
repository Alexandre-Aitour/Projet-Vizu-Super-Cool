# ==================================================================================================
# Onglet : Analyse descriptive
# Préfixe des identifiants : descriptive_
# ==================================================================================================

# --------------------------------------------------------------------------------------------------
# Style de l'onglet, repris de la charte de l'accueil
# (limité aux classes descriptive-* pour ne pas toucher les autres onglets)
# --------------------------------------------------------------------------------------------------
descriptive_css <- "
.descriptive-page {
    --descriptive-orange: #F8B063;
    --descriptive-orange-fonce: #E8913A;
    --descriptive-creme: #FFF6EC;
    --descriptive-texte: #4A2C0F;
    --descriptive-croute: #8B4A12;
    --descriptive-bordure: #F3E3D0;
    min-height: calc(100vh - 80px);
    margin: -1rem;
    padding: 1.5rem;
    background: var(--descriptive-creme);
    color: var(--descriptive-texte);
    font-family: 'Fredoka', 'Arial Rounded MT Bold', sans-serif;
}

/* ---------- En-tête : le titre entre deux mozzasticks ---------- */
.descriptive-entete {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 1.2rem;
    margin-bottom: 1.2rem;
}
.descriptive-entete h2 {
    margin: 0;
    font-weight: 700;
    color: var(--descriptive-orange-fonce);
    text-shadow: 0 2px 0 rgba(139, 74, 18, 0.15);
}
.descriptive-entete img {
    height: 42px;
    filter: drop-shadow(0 6px 6px rgba(120, 60, 10, 0.30));
}
.descriptive-entete img.gauche { transform: rotate(-8deg); }
.descriptive-entete img.droite { transform: rotate(8deg) scaleX(-1); }

/* ---------- Carte et onglets Consommateurs / Jury ---------- */
.descriptive-page .card {
    border: 1px solid var(--descriptive-bordure);
    border-radius: 18px;
    box-shadow: 0 6px 18px rgba(120, 60, 10, 0.10);
    overflow: hidden;
}
.descriptive-page .card-header {
    background: #FFFFFF;
    border-bottom: 1px solid var(--descriptive-bordure);
}
.descriptive-page .nav-tabs .nav-link {
    color: var(--descriptive-croute);
    font-weight: 600;
    border: none;
}
.descriptive-page .nav-tabs .nav-link.active {
    color: var(--descriptive-orange-fonce);
    background: transparent;
    border-bottom: 3px solid var(--descriptive-orange-fonce);
}

/* ---------- Panneau latéral des inputs ---------- */
.descriptive-page .bslib-sidebar-layout > .sidebar {
    background: #FFFBF5;
    border-right: 1px solid var(--descriptive-bordure);
}
.descriptive-page .control-label {
    font-weight: 600;
    color: var(--descriptive-texte);
}
.descriptive-page hr {
    border-color: var(--descriptive-orange);
    opacity: 0.6;
}
.descriptive-page .shiny-input-container input:checked {
    background-color: var(--descriptive-orange-fonce);
    border-color: var(--descriptive-orange-fonce);
}
.descriptive-page .shiny-input-container input:focus {
    border-color: var(--descriptive-orange);
    box-shadow: 0 0 0 0.2rem rgba(248, 176, 99, 0.35);
}

/* ---------- Bouton Afficher : le mozzastick de l'accueil (même animation), en plus petit ---------- */
.descriptive-page .accueil-stick {
    width: 220px;
    max-width: 100%;
    margin-top: 0.5rem;
}
.descriptive-page .accueil-stick .fromage { font-size: 1.35rem; }
.descriptive-page .accueil-stick.coupe .gauche { transform: translateX(-22px) rotate(-12deg); }
.descriptive-page .accueil-stick.coupe .droite { transform: translateX(22px) rotate(12deg); }
.descriptive-page .accueil-stick.coupe .fil { width: 70px; }

/* Logo en petit à côté du nom du magasin, dans les cases à cocher */
.descriptive-magasin img {
    height: 20px;
    width: 34px;
    object-fit: contain;
    margin-right: 0.4rem;
    vertical-align: middle;
}

/* Message d'erreur de validation (aucune case cochée) */
.descriptive-page .shiny-output-error-validation {
    color: var(--descriptive-croute);
    font-weight: 600;
}
"

# Bouton Afficher : le mozzastick de l'accueil (accueil_stick() dans onglets/accueil/ui_accueil.R),
# qui se casse avec le crunch puis envoie input[[input_id]] au serveur
descriptive_bouton <- function(input_id) {
    accueil_stick(input_id, "Afficher")
}

onglet_descriptive <- nav_panel(
    title = "Analyse descriptive",
    value = "descriptive",
    icon = icon("chart-simple"),

    tags$head(
        tags$link(
            rel = "stylesheet",
            href = "https://fonts.googleapis.com/css2?family=Fredoka:wght@400;600;700&display=swap"
        ),
        tags$style(HTML(descriptive_css))
    ),

    div(
        class = "descriptive-page",

        # En-tête
        div(
            class = "descriptive-entete",
            img(src = "accueil_stick.png", class = "gauche", alt = ""),
            h2("Analyse descriptive"),
            img(src = "accueil_stick.png", class = "droite", alt = "")
        ),

        navset_card_tab(
            # ---------------------------------------- Partie Consommateurs
            nav_panel(
                "Consommateurs",
                layout_sidebar(
                    sidebar = sidebar(
                        # Choix du graphique, puis ses inputs juste en dessous
                        radioButtons(
                            inputId = "descriptive_cons_graphique",
                            label = "Graphique :",
                            choices = c("Distribution des notes" = "distribution",
                                        "Moyennes par produit" = "moyennes")
                        ),
                        hr(),
                        # ---------- Inputs : distribution des notes
                        conditionalPanel(
                            condition = "input.descriptive_cons_graphique == 'distribution'",
                            checkboxGroupInput(
                                inputId = "descriptive_cons_dimensions",
                                label = "Dimensions à afficher :",
                                choices = c("Global", "Visuel", "Goût", "Texture"),
                                selected = c("Global", "Visuel", "Goût", "Texture")
                            ),
                            descriptive_bouton("descriptive_cons_afficher")
                        ),
                        # ---------- Inputs : appréciation moyenne par produit
                        conditionalPanel(
                            condition = "input.descriptive_cons_graphique == 'moyennes'",
                            checkboxGroupInput(
                                inputId = "descriptive_cons_produits",
                                label = "Magasins à afficher :",
                                choiceNames = lapply(levels(dta_cons$Produit), function(m) {
                                    span(class = "descriptive-magasin",
                                         # ?v=<date de modification> : force le navigateur à recharger un logo remplacé
                                         img(src = paste0("logos/", m, ".png?v=",
                                                          as.integer(file.mtime(file.path("www/logos", paste0(m, ".png"))))),
                                             alt = ""),
                                         magasins_noms[[m]])
                                }),
                                choiceValues = levels(dta_cons$Produit),
                                selected = levels(dta_cons$Produit)
                            ),
                            descriptive_bouton("descriptive_cons_moy_afficher")
                        )
                    ),
                    # ---------- Graphiques
                    conditionalPanel(
                        condition = "input.descriptive_cons_graphique == 'distribution'",
                        plotOutput("descriptive_cons_distribution", height = "600px")
                    ),
                    conditionalPanel(
                        condition = "input.descriptive_cons_graphique == 'moyennes'",
                        plotOutput("descriptive_cons_moyennes", height = "550px")
                    )
                )
            ),
            # ---------------------------------------- Partie Jury
            nav_panel(
                "Jury",
                # ---------- Graphique sans input : pouvoir discriminant des descripteurs
                plotOutput("descriptive_jury_discriminant", height = "800px")
            )
        )
    )
)
