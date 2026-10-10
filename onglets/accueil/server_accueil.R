# ==================================================================================================
# Onglet : Accueil
# Préfixe des identifiants : accueil_
# ==================================================================================================

# Boutons de navigation vers les onglets
observeEvent(input$accueil_go_recherche_opti, nav_select("onglets", "recherche_opti"))
observeEvent(input$accueil_go_descriptive, nav_select("onglets", "descriptive"))
observeEvent(input$accueil_go_analyse, nav_select("onglets", "analyse"))

# Mozzasticks de navigation des en-têtes (nav_stick() dans ui_accueil.R)
observeEvent(input$nav_aller, nav_select("onglets", input$nav_aller))
