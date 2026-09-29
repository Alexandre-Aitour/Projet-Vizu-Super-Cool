# ==================================================================================================
# Onglet : Analyse Factorielle
# Préfixe des identifiants : analyse_
# Direction Artistique : Mozzarella / Fromage chaud (cohérente avec Accueil)
# ==================================================================================================

analyse_css <- "
.analyse-page {
    --mozza-orange: #F8B063;
    --mozza-orange-fonce: #E8913A;
    --mozza-creme: #FFF9F2;
    --mozza-creme-fonce: #FFF0DF;
    --mozza-texte: #4A2C0F;
    --mozza-jaune: #F4D57E;
    --mozza-border: #F3E3D0;
    --mozza-shadow: rgba(120, 60, 10, 0.08);
    font-family: system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;
    color: var(--mozza-texte);
    background: transparent;
    padding: 0.5rem 0.2rem 2rem;
}

/* En-tête gourmand de l'onglet */
.analyse-header {
    background: linear-gradient(135deg, #FFFDF8 0%, #FFF3E1 100%);
    border: 1px solid var(--mozza-border);
    border-radius: 20px;
    padding: 1.25rem 1.75rem;
    margin-bottom: 1.5rem;
    box-shadow: 0 4px 15px var(--mozza-shadow);
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 1rem;
}

.analyse-header h2 {
    font-family: 'Fredoka', 'Arial Rounded MT Bold', sans-serif;
    color: var(--mozza-orange-fonce);
    font-size: 1.8rem;
    font-weight: 700;
    margin: 0;
    display: flex;
    align-items: center;
    gap: 0.6rem;
}

.analyse-header p {
    margin: 0.3rem 0 0 0;
    color: var(--mozza-texte);
    opacity: 0.85;
    font-size: 0.95rem;
}

.analyse-badge {
    background: linear-gradient(135deg, #F8B063 0%, #E8913A 100%);
    color: #FFFFFF;
    font-family: 'Fredoka', sans-serif;
    font-size: 0.9rem;
    font-weight: 600;
    padding: 0.4rem 0.9rem;
    border-radius: 30px;
    box-shadow: 0 2px 6px rgba(232, 145, 58, 0.35);
}

/* Sidebar stylisée aux couleurs mozzastick */
.analyse-page .bslib-sidebar-layout > .sidebar {
    background: #FFFDF9 !important;
    border: 1px solid var(--mozza-border) !important;
    border-radius: 20px !important;
    box-shadow: 0 6px 18px var(--mozza-shadow) !important;
    padding: 1.25rem !important;
}

.analyse-page .sidebar-title {
    font-family: 'Fredoka', 'Arial Rounded MT Bold', sans-serif !important;
    font-size: 1.25rem !important;
    color: var(--mozza-orange-fonce) !important;
    font-weight: 700 !important;
    border-bottom: 2px dashed var(--mozza-border);
    padding-bottom: 0.6rem;
    margin-bottom: 1rem;
}

.analyse-page label {
    font-weight: 600;
    color: var(--mozza-texte);
    font-size: 0.92rem;
}

.analyse-page .form-select, .analyse-page .form-control {
    border-radius: 12px;
    border: 1.5px solid var(--mozza-border);
    background-color: #FFFFFF;
    color: var(--mozza-texte);
    font-weight: 500;
    transition: all 0.2s ease;
}

.analyse-page .form-select:focus, .analyse-page .form-control:focus {
    border-color: var(--mozza-orange);
    box-shadow: 0 0 0 0.25rem rgba(248, 176, 99, 0.25);
}

/* Checkbox personnalisée */
.analyse-page .form-check-input:checked {
    background-color: var(--mozza-orange-fonce);
    border-color: var(--mozza-orange-fonce);
}

/* Cartes gourmandes */
.analyse-page .card {
    border: 1px solid var(--mozza-border);
    border-radius: 20px;
    box-shadow: 0 6px 18px var(--mozza-shadow);
    background: #FFFFFF;
    overflow: hidden;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
    margin-bottom: 1rem;
}

.analyse-page .card:hover {
    box-shadow: 0 10px 25px rgba(120, 60, 10, 0.12);
}

.analyse-page .card-header {
    background: linear-gradient(135deg, #FFFDF8 0%, #FFF5E7 100%);
    border-bottom: 1px solid var(--mozza-border);
    color: var(--mozza-texte);
    font-family: 'Fredoka', 'Arial Rounded MT Bold', sans-serif;
    font-size: 1.15rem;
    font-weight: 600;
    padding: 0.9rem 1.3rem;
}

/* DataTable dans la DA */
.analyse-page .dataTables_wrapper {
    padding: 0.75rem;
    font-size: 0.92rem;
}
.analyse-page table.dataTable thead th {
    background-color: #FFF3E1 !important;
    color: var(--mozza-texte) !important;
    font-family: 'Fredoka', sans-serif !important;
    font-weight: 600 !important;
    border-bottom: 2px solid var(--mozza-orange) !important;
}
.analyse-page table.dataTable tbody tr:hover {
    background-color: #FFF9F2 !important;
}
"

onglet_analyse <- nav_panel(
    title = "Analyse Factorielle",
    value = "analyse",
    icon = icon("diagram-project"),
    
    tags$head(
        tags$link(
            rel = "stylesheet", 
            href = "https://fonts.googleapis.com/css2?family=Fredoka:wght@600;700&display=swap"
        ),
        tags$style(HTML(analyse_css))
    ),
    
    div(
        class = "analyse-page",
        
        # Bannière gourmande
        div(
            class = "analyse-header",
            div(
                h2("🧀 Analyse Factorielle Multiple"),
                p("Exploration des relations entre les modalités sensorielles (Jury d'experts) et l'appréciation des consommateurs.")
            ),
            div(
                span(class = "analyse-badge", "Axe 2 • AFM")
            )
        ),
        
        # Disposition avec barre latérale
        layout_sidebar(
            sidebar = sidebar(
                title = "Paramètres de l'AFM",
                selectInput(
                    inputId = "analyse_afm_type",
                    label = "Modèle d'AFM :",
                    choices = c(
                        "🧀 Décomposition par sens (Visuel, Saveur, Texture)" = "sens",
                        "👥 Globale (Jury complet vs Consommateurs)" = "jury"
                    ),
                    selected = "sens"
                ),
                checkboxInput(
                    inputId = "analyse_afm_show_partial", 
                    label = "Afficher les points partiels (par groupe)", 
                    value = TRUE
                ),
                sliderInput(
                    inputId = "analyse_afm_top_contrib",
                    label = "Nombre de descripteurs affichés :",
                    min = 5, max = 37, value = 15, step = 1
                ),
                helpText(
                    style = "color: #7A5330; font-size: 0.85rem; margin-top: 0.5rem;",
                    "Filtre les descripteurs sensoriels les plus corrélés et contributifs dans le cercle des corrélations."
                )
            ),
            
            # Grille 2x2 des résultats
            layout_columns(
                col_widths = c(6, 6),
                card(
                    card_header("🥖 Projection des mozzarellas (Moyens & Partiels)"),
                    plotOutput("analyse_afm_ind_plot", height = "460px")
                ),
                card(
                    card_header("🎨 Représentation des groupes de variables"),
                    plotOutput("analyse_afm_group_plot", height = "460px")
                )
            ),
            
            layout_columns(
                col_widths = c(6, 6),
                card(
                    card_header("📊 Matrice des coefficients de liaison (RV)"),
                    DTOutput("analyse_afm_rv_table")
                ),
                card(
                    card_header("🎯 Cercle des corrélations des variables quantitatives"),
                    plotOutput("analyse_afm_var_plot", height = "460px")
                )
            )
        )
    )
)
