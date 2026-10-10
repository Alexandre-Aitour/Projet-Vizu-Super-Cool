# ==================================================================================================
# Onglet : Analyse Factorielle (AFM)
# Préfixe des identifiants : analyse_
# ==================================================================================================

# --------------------------------------------------------------------------------------------------
# Style de l'onglet, harmonisé avec l'accueil, descriptive et recherche_opti
# --------------------------------------------------------------------------------------------------
analyse_css <- "
.analyse-page {
    --analyse-orange: #F8B063;
    --analyse-orange-fonce: #E8913A;
    --analyse-creme: #FFF6EC;
    --analyse-texte: #4A2C0F;
    --analyse-croute: #8B4A12;
    --analyse-bordure: #F3E3D0;
    min-height: 100vh;
    margin: -1rem;
    padding: 1.5rem;
    background: var(--analyse-creme);
    color: var(--analyse-texte);
    font-family: 'Fredoka', 'Arial Rounded MT Bold', sans-serif;
}

/* ---------- En-tête : le titre entre deux mozzasticks ---------- */
.analyse-entete {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 1.2rem;
    margin-bottom: 0.8rem;
}
.analyse-entete h2 {
    margin: 0;
    font-weight: 700;
    color: var(--analyse-orange-fonce);
    text-shadow: 0 2px 0 rgba(139, 74, 18, 0.15);
}
.analyse-entete img {
    height: 42px;
    filter: drop-shadow(0 6px 6px rgba(120, 60, 10, 0.30));
}
.analyse-entete img.gauche { transform: rotate(-8deg); }
.analyse-entete img.droite { transform: rotate(8deg) scaleX(-1); }

/* ---------- Espace explicatif / bannière d'introduction ---------- */
.analyse-intro {
    max-width: 820px;
    margin: 0 auto 1.5rem;
    padding: 1rem 1.4rem;
    background: linear-gradient(135deg, #FFFDF8 0%, #FFF4E3 100%);
    border-left: 4px solid var(--analyse-orange-fonce);
    border-radius: 14px;
    box-shadow: 0 2px 8px rgba(120, 60, 10, 0.06);
    text-align: center;
}
.analyse-intro h3 {
    margin: 0 0 0.35rem;
    color: var(--analyse-orange-fonce);
    font-size: 1.2rem;
    font-weight: 700;
}
.analyse-intro p {
    margin: 0;
    line-height: 1.45;
    font-size: 0.92rem;
    color: var(--analyse-texte);
}

/* ---------- Cartes et conteneurs ---------- */
.analyse-page .card {
    border: 1px solid var(--analyse-bordure);
    border-radius: 18px;
    box-shadow: 0 6px 18px rgba(120, 60, 10, 0.08);
    overflow: hidden;
    background: #FFFFFF;
    transition: transform 0.25s cubic-bezier(0.2, 0.8, 0.2, 1), box-shadow 0.25s ease;
}
.analyse-page .card:hover {
    transform: translateY(-3px);
    box-shadow: 0 10px 22px rgba(120, 60, 10, 0.12);
}
.analyse-page .card-header {
    background: #FFFFFF;
    border-bottom: 1px solid var(--analyse-bordure);
    font-weight: 600;
    color: var(--analyse-orange-fonce);
    font-size: 1.02rem;
}

/* ---------- Onglets secondaires (navset_card_tab) ---------- */
.analyse-page .nav-tabs {
    border-bottom: 2px solid var(--analyse-bordure);
    margin-bottom: 1.2rem;
    background: transparent;
}
.analyse-page .nav-tabs .nav-link {
    color: var(--analyse-croute);
    font-weight: 600;
    font-size: 0.98rem;
    border: none;
    padding: 0.75rem 1.4rem;
    border-radius: 12px 12px 0 0;
    transition: all 0.2s ease;
}
.analyse-page .nav-tabs .nav-link:hover {
    color: var(--analyse-orange-fonce);
    background: rgba(248, 176, 99, 0.15);
}
.analyse-page .nav-tabs .nav-link.active {
    color: var(--analyse-orange-fonce);
    background: #FFFFFF;
    border-bottom: 3px solid var(--analyse-orange-fonce);
    box-shadow: 0 -2px 6px rgba(120, 60, 10, 0.04);
}

/* ---------- Cartes d'indicateurs KPI (Value Boxes) ---------- */
.analyse-kpi-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
    gap: 1rem;
    margin-bottom: 1.25rem;
}
.analyse-kpi-card {
    background: #FFFFFF;
    border: 1px solid var(--analyse-bordure);
    border-radius: 14px;
    padding: 0.9rem 1.1rem;
    box-shadow: 0 4px 12px rgba(120, 60, 10, 0.06);
    display: flex;
    align-items: center;
    gap: 0.85rem;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.analyse-kpi-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 8px 16px rgba(120, 60, 10, 0.10);
}
.analyse-kpi-icon {
    font-size: 2.1rem;
    line-height: 1;
}
.analyse-kpi-info {
    flex: 1;
    min-width: 0;
}
.analyse-kpi-titre {
    font-size: 0.76rem;
    font-weight: 600;
    color: var(--analyse-croute);
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 0.15rem;
}
.analyse-kpi-valeur {
    font-size: 1.25rem;
    font-weight: 700;
    color: var(--analyse-orange-fonce);
    line-height: 1.2;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.analyse-kpi-sub {
    font-size: 0.76rem;
    color: var(--analyse-texte);
    opacity: 0.8;
}

/* ---------- Panneau latéral des inputs ---------- */
.analyse-page .bslib-sidebar-layout > .sidebar {
    background: #FFFBF5;
    border-right: 1px solid var(--analyse-bordure);
}
.analyse-page .control-label {
    font-weight: 600;
    color: var(--analyse-texte);
}
.analyse-page hr {
    border-color: var(--analyse-orange);
    opacity: 0.6;
}
.analyse-page .shiny-input-container input:checked {
    background-color: var(--analyse-orange-fonce);
    border-color: var(--analyse-orange-fonce);
}
.analyse-page .shiny-input-container input:focus {
    border-color: var(--analyse-orange);
    box-shadow: 0 0 0 0.2rem rgba(248, 176, 99, 0.35);
}

/* ---------- Bouton Afficher mozzastick ---------- */
.analyse-page .accueil-stick {
    width: 220px;
    max-width: 100%;
    margin-top: 0.5rem;
}
.analyse-page .accueil-stick .fromage { font-size: 1.35rem; }
.analyse-page .accueil-stick.coupe .gauche { transform: translateX(-22px) rotate(-12deg); }
.analyse-page .accueil-stick.coupe .droite { transform: translateX(22px) rotate(12deg); }
.analyse-page .accueil-stick.coupe .fil { width: 70px; }

/* Logo à côté du magasin */
.analyse-magasin img {
    height: 20px;
    width: 34px;
    object-fit: contain;
    margin-right: 0.4rem;
    vertical-align: middle;
}

/* Message d'erreur de validation */
.analyse-page .shiny-output-error-validation {
    color: var(--analyse-croute);
    font-weight: 600;
}

/* Table DataTables stylisée aux couleurs mozzastick */
.analyse-page .dataTables_wrapper {
    padding: 0.5rem;
}
.analyse-page table.dataTable thead th {
    background-color: #FFF3E1 !important;
    color: var(--analyse-texte) !important;
    font-family: 'Fredoka', sans-serif !important;
    font-weight: 600 !important;
    border-bottom: 2px solid var(--analyse-orange) !important;
}
.analyse-page table.dataTable tbody tr:hover {
    background-color: #FFF9F2 !important;
}

/* ---------- Encadré de synthèse sensorielle ---------- */
.analyse-synthese-box {
    margin-top: 1.1rem;
    padding: 1.1rem 1.3rem;
    background: linear-gradient(135deg, #FFFDF8 0%, #FFF4E3 100%);
    border-left: 4px solid var(--analyse-orange-fonce);
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(120, 60, 10, 0.05);
}
.analyse-synthese-box .synthese-titre {
    font-weight: 700;
    color: var(--analyse-orange-fonce);
    font-size: 1.05rem;
    margin-bottom: 0.45rem;
    display: flex;
    align-items: center;
    gap: 0.45rem;
}
.analyse-synthese-box p {
    margin: 0;
    font-size: 0.95rem;
    line-height: 1.45;
    color: var(--analyse-texte);
}

/* ---------- Animation d'apparition ---------- */
@keyframes mozza-apparition {
    0% {
        opacity: 0;
        transform: translateY(18px) scale(0.99);
    }
    100% {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

.analyse-resultats-anim {
    animation: mozza-apparition 0.55s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}

/* Écran d'attente avant le clic sur Afficher */
.analyse-placeholder-card {
    background: #FFFFFF;
    border: 2px dashed var(--analyse-orange);
    border-radius: 22px;
    padding: 4rem 2rem;
    text-align: center;
    box-shadow: 0 6px 20px rgba(120, 60, 10, 0.05);
    margin: 1.5rem 0;
    animation: mozza-apparition 0.5s ease-out forwards;
}
.analyse-placeholder-card .icone-fromage {
    font-size: 3.5rem;
    display: inline-block;
    animation: mozza-flotte 3s ease-in-out infinite alternate;
}
@keyframes mozza-flotte {
    from { transform: translateY(0) rotate(-4deg); }
    to   { transform: translateY(-8px) rotate(4deg); }
}
.analyse-placeholder-card h3 {
    color: var(--analyse-orange-fonce);
    font-size: 1.6rem;
    font-weight: 700;
    margin: 1rem 0 0.5rem;
}
.analyse-placeholder-card p {
    color: var(--analyse-texte);
    font-size: 1.05rem;
    margin: 0;
    opacity: 0.85;
}
"

# Bouton Afficher façon mozzastick (reprise de onglets/accueil/ui_accueil.R)
analyse_bouton <- function(input_id) {
    accueil_stick(input_id, "Afficher")
}

onglet_analyse <- nav_panel(
    title = "Analyse Factorielle",
    value = "analyse",
    icon = icon("diagram-project"),

    tags$head(
        tags$link(
            rel = "stylesheet",
            href = "https://fonts.googleapis.com/css2?family=Fredoka:wght@400;600;700&display=swap"
        ),
        tags$style(HTML(analyse_css))
    ),

    div(
        class = "analyse-page",

        # En-tête : le titre entre deux mozzasticks
        div(
            class = "analyse-entete",
            nav_stick("descriptive", "Analyse descriptive", "gauche"),
            h2("Analyse Factorielle"),
            nav_stick("recherche_opti", "Produit Optimal", "droite")
        ),

        # Bannière explicative d'accueil (harmonisée avec recherche_opti)
        div(
            class = "analyse-intro",
            h3("Décryptage Factoriel Multi-Blocs (AFM)"),
            p("Croisez le profilage sensoriel des experts (37 descripteurs visuels, gustatifs et de texture) avec les préférences réelles des consommateurs pour identifier la recette et le positionnement idéal de chaque mozzarella.")
        ),

        layout_sidebar(
            sidebar = sidebar(
                radioButtons(
                    inputId = "analyse_afm_type",
                    label = "Modèle d'AFM :",
                    choices = c(
                        "Décomposition par sens (Saveur, Visuel, Texture)" = "sens",
                        "Globale (Jury d'experts vs Consommateurs)" = "jury"
                    ),
                    selected = "sens"
                ),
                hr(),
                # Choix des magasins à afficher avec logo et sélection rapide
                div(
                    class = "d-flex justify-content-between align-items-center mb-1",
                    tags$label(class = "control-label mb-0", "Magasins à afficher :"),
                    div(
                        actionLink("analyse_magasins_tous", "Tous", class = "btn btn-link btn-sm p-0 me-2 text-decoration-none", style = "font-size: 0.82rem; color: var(--analyse-orange-fonce); font-weight: 600;"),
                        actionLink("analyse_magasins_aucun", "Aucun", class = "btn btn-link btn-sm p-0 text-decoration-none", style = "font-size: 0.82rem; color: var(--analyse-croute);")
                    )
                ),
                sliderInput(
                    inputId = "analyse_nb_magasins",
                    label = span(style = "font-size: 0.85rem; font-weight: 500; color: #7A4B1D;", "Sélection rapide (Top N par note) :"),
                    min = 1,
                    max = length(levels(dta_cons$Produit)),
                    value = length(levels(dta_cons$Produit)),
                    step = 1,
                    ticks = FALSE
                ),
                checkboxGroupInput(
                    inputId = "analyse_magasins",
                    label = NULL,
                    choiceNames = lapply(levels(dta_cons$Produit), function(m) {
                        span(class = "analyse-magasin",
                             img(src = paste0("logos/", m, ".png?v=",
                                              as.integer(file.mtime(file.path("www/logos", paste0(m, ".png"))))),
                                 alt = ""),
                             magasins_noms[[m]])
                    }),
                    choiceValues = levels(dta_cons$Produit),
                    selected = levels(dta_cons$Produit)
                ),
                hr(),
                # Choix des axes factoriels à projeter
                layout_columns(
                    col_widths = c(6, 6),
                    selectInput(
                        inputId = "analyse_dim_x",
                        label = "Axe X :",
                        choices = c("Dim 1" = 1, "Dim 2" = 2, "Dim 3" = 3),
                        selected = 1
                    ),
                    selectInput(
                        inputId = "analyse_dim_y",
                        label = "Axe Y :",
                        choices = c("Dim 1" = 1, "Dim 2" = 2, "Dim 3" = 3),
                        selected = 2
                    )
                ),
                sliderInput(
                    inputId = "analyse_afm_top_contrib",
                    label = "Descripteurs affichés :",
                    min = 5, max = 37, value = 15, step = 1
                ),
                checkboxInput(
                    inputId = "analyse_afm_show_partial",
                    label = "Points partiels (par groupe)",
                    value = TRUE
                ),
                checkboxInput(
                    inputId = "analyse_afm_show_logos",
                    label = "Logos des magasins sur la carte",
                    value = TRUE
                ),
                checkboxInput(
                    inputId = "analyse_afm_show_ind_labels",
                    label = "Noms des magasins sur la carte",
                    value = FALSE
                ),
                checkboxInput(
                    inputId = "analyse_afm_show_cons",
                    label = "Projeter l'appréciation consommateurs",
                    value = TRUE
                ),
                checkboxInput(
                    inputId = "analyse_afm_show_legend",
                    label = "Afficher la légende",
                    value = TRUE
                ),
                hr(),
                analyse_bouton("analyse_afm_afficher")
            ),

            # 1. Écran d'attente avant premier clic sur Afficher
            conditionalPanel(
                condition = "!input.analyse_afm_afficher",
                div(
                    class = "analyse-placeholder-card",
                    span(class = "icone-fromage", icon("diagram-project")),
                    h3("Prêt pour l'Analyse Factorielle ?"),
                    p("Choisissez vos dimensions et paramètres dans le panneau de gauche, puis cliquez sur le bâtonnet « Afficher » pour révéler les cartographies interactives.")
                )
            ),

            # 2. Résultats structurés en onglets avec indicateurs KPI
            conditionalPanel(
                condition = "input.analyse_afm_afficher",
                div(
                    class = "analyse-resultats-anim",
                    
                    # Ligne des 4 KPI essentiels en haut
                    uiOutput("analyse_afm_kpis"),

                    # Organisation propre en sous-onglets (navset_card_tab)
                    navset_card_tab(
                        
                        # --- SOUS-ONGLET 1 : Cartographie factorielle & Corrélations
                        nav_panel(
                            title = "Cartographie & Corrélations",
                            icon = icon("crosshairs"),
                            layout_columns(
                                col_widths = c(6, 6),
                                card(
                                    card_header("Projection des mozzarellas (Moyens & Partiels)"),
                                    plotlyOutput("analyse_afm_ind_plot", height = "500px")
                                ),
                                card(
                                    card_header("Cercle des corrélations des descripteurs"),
                                    plotlyOutput("analyse_afm_var_plot", height = "500px")
                                )
                            ),
                            div(
                                class = "analyse-synthese-box",
                                uiOutput("analyse_afm_synthese")
                            )
                        ),

                        # --- SOUS-ONGLET 2 : Groupes sensoriels & Liaisons (RV)
                        nav_panel(
                            title = "Groupes & Liaisons RV",
                            icon = icon("layer-group"),
                            layout_columns(
                                col_widths = c(6, 6),
                                card(
                                    card_header("Projection synthétique des groupes de variables"),
                                    plotlyOutput("analyse_afm_group_plot", height = "460px")
                                ),
                                card(
                                    card_header("Matrice des coefficients de liaison (RV)"),
                                    DTOutput("analyse_afm_rv_table"),
                                    p(
                                        style = "margin-top: 12px; font-size: 0.84rem; color: var(--analyse-croute);",
                                        strong("Coefficient RV :"), " mesure la corrélation globale entre deux blocs de mesures (0 = indépendants, 1 = structure sensorielle identique)."
                                    )
                                )
                            )
                        ),

                        # --- SOUS-ONGLET 3 : Inertie & Contributions
                        nav_panel(
                            title = "Inertie & Contributions",
                            icon = icon("chart-column"),
                            layout_columns(
                                col_widths = c(6, 6),
                                card(
                                    card_header("Éboulis des valeurs propres (Inertie expliquée)"),
                                    plotlyOutput("analyse_afm_scree_plot", height = "460px")
                                ),
                                card(
                                    card_header("Top descripteurs contribuant aux axes"),
                                    plotlyOutput("analyse_afm_contrib_plot", height = "460px")
                                )
                            )
                        )
                    )
                )
            )
        )
    )
)
