# ==================================================================================================
# Onglet : Analyse Factorielle
# Préfixe des identifiants : analyse_
# Logique et thème harmonisés avec onglets/descriptive et global.R
# Visualisations interactives avec plotly (zoom au trackpad, pan, infobulles, axes dynamiques)
# ==================================================================================================

# ----------------------------------------------------------------------------------------------------
# 1. Calculs réactifs AFM
# ----------------------------------------------------------------------------------------------------

# Préparation du tableau fusionné (Moyennes consommateurs + Jury)
analyse_data_afm <- reactive({
    dta_cons_m <- dta_cons %>%
        group_by(Produit) %>%
        summarise(
            cons_overall    = mean(Global, na.rm = TRUE),
            cons_texture    = mean(Texture, na.rm = TRUE),
            cons_appearance = mean(Visuel, na.rm = TRUE),
            cons_flavor     = mean(Goût, na.rm = TRUE)
        )
    inner_join(dta_cons_m, dta_panel, by = "Produit") %>%
        tibble::column_to_rownames("Produit")
})

# Paramètres figés au clic sur le bouton "Afficher"
analyse_params <- eventReactive(input$analyse_afm_afficher, {
    dx <- as.numeric(input$analyse_dim_x)
    dy <- as.numeric(input$analyse_dim_y)
    if (dx == dy) dy <- if (dx == 1) 2 else 1
    
    list(
        type         = input$analyse_afm_type,
        show_partial = input$analyse_afm_show_partial,
        top_contrib  = input$analyse_afm_top_contrib,
        dim_x        = dx,
        dim_y        = dy
    )
})

# Calcul du modèle AFM selon le choix validé
analyse_res_afm <- reactive({
    p <- analyse_params()
    df <- analyse_data_afm()
    
    if (p$type == "sens") {
        # AFM 1 : Décomposition par sens avec Consommateurs en illustratif
        MFA(
            df,
            group = c(4, 6, 16, 15),
            type = c("c", "s", "s", "s"),
            name.group = c("Consommateurs", "Visuel", "Saveur", "Texture"),
            num.group.sup = 1,
            graph = FALSE
        )
    } else {
        # AFM 2 : Analyse globale Jury vs Consommateurs
        MFA(
            df,
            group = c(4, 37),
            type = c("s", "s"),
            name.group = c("Consommateurs", "Jury"),
            graph = FALSE
        )
    }
})

# ----------------------------------------------------------------------------------------------------
# 2. Sorties graphiques interactives (Plotly) et tabulaires de l'AFM
# ----------------------------------------------------------------------------------------------------

# Carte des individus (produits) : moyens et partiels avec mise en valeur du champion (196)
output$analyse_afm_ind_plot <- renderPlotly({
    req(input$analyse_afm_afficher)
    res <- analyse_res_afm()
    p <- analyse_params()
    
    partial_arg <- if (isTRUE(p$show_partial)) "all" else NULL
    
    p_ind <- fviz_mfa_ind(
        res,
        axes = c(p$dim_x, p$dim_y),
        partial = partial_arg,
        repel = TRUE,
        pointsize = 3.5,
        labelsize = 4.5
    ) + 
        theme_mozza() +
        labs(
            title = if (isTRUE(p$show_partial)) "Carte des mozzarellas (Moyens & Partiels)" else "Carte des mozzarellas (Points moyens)"
        )
    
    # Identification et mise en valeur du produit favori des consommateurs (Produit 196)
    best_prod_df <- dta_cons %>%
        group_by(Produit) %>%
        summarise(note_moy = mean(Global, na.rm = TRUE), .groups = "drop") %>%
        slice_max(note_moy, n = 1)
    
    if (nrow(best_prod_df) > 0) {
        best_id   <- as.character(best_prod_df$Produit[1])
        best_note <- round(best_prod_df$note_moy[1], 2)
        
        coords <- as.data.frame(res$ind$coord)
        dim_x_name <- paste0("Dim.", p$dim_x)
        dim_y_name <- paste0("Dim.", p$dim_y)
        
        if (all(c(dim_x_name, dim_y_name) %in% colnames(coords)) && best_id %in% rownames(coords)) {
            champ_x <- coords[best_id, dim_x_name]
            champ_y <- coords[best_id, dim_y_name]
            
            p_ind <- p_ind +
                annotate(
                    "point", 
                    x = champ_x, 
                    y = champ_y, 
                    color = "#E8913A", 
                    size = 5.5, 
                    shape = 18
                ) +
                annotate(
                    "text", 
                    x = champ_x, 
                    y = champ_y + 0.35, 
                    label = paste0("★ Favori n°", best_id, " (", best_note, "/9)"), 
                    color = mozza_couleurs[["croute"]], 
                    fontface = "bold", 
                    family = mozza_police, 
                    size = 3.5
                )
        }
    }
    
    ggplotly(p_ind) %>%
        config(scrollZoom = TRUE, displaylogo = FALSE)
})

# Cercle des corrélations des variables quantitatives
output$analyse_afm_var_plot <- renderPlotly({
    req(input$analyse_afm_afficher)
    p <- analyse_params()
    
    p_var <- fviz_mfa_var(
        analyse_res_afm(), 
        "quanti.var", 
        axes = c(p$dim_x, p$dim_y),
        repel = TRUE, 
        select.var = list(contrib = p$top_contrib),
        col.var = "contrib",
        gradient.cols = c(mozza_couleurs[["fromage"]], mozza_couleurs[["orange"]], mozza_couleurs[["croute"]])
    ) + 
        theme_mozza() + 
        labs(
            title = paste0("Cercle des corrélations (Axes ", p$dim_x, " & ", p$dim_y, ")"),
            color = "Contribution"
        )
    
    ggplotly(p_var) %>%
        config(scrollZoom = TRUE, displaylogo = FALSE)
})

# Graphe des groupes de variables
output$analyse_afm_group_plot <- renderPlotly({
    req(input$analyse_afm_afficher)
    p <- analyse_params()
    
    p_group <- fviz_mfa_var(
        analyse_res_afm(), 
        "group",
        axes = c(p$dim_x, p$dim_y),
        palette = c(mozza_couleurs[["orange_fonce"]], "#C0392B", "#4A90E2", "#7A8B3A")
    ) + 
        theme_mozza() + 
        labs(title = paste0("Projection des groupes (Axes ", p$dim_x, " & ", p$dim_y, ")"))
    
    ggplotly(p_group) %>%
        config(scrollZoom = TRUE, displaylogo = FALSE)
})

# Matrice des coefficients RV
output$analyse_afm_rv_table <- renderDT({
    req(input$analyse_afm_afficher)
    rv_mat <- round(analyse_res_afm()$group$RV, 3)
    datatable(
        as.data.frame(rv_mat),
        options = list(
            dom = "t", 
            paging = FALSE,
            ordering = FALSE,
            initComplete = JS(
                "function(settings, json) {",
                "$(this.api().table().header()).css({'background-color': '#FFF3E1', 'color': '#4A2C0F'});",
                "}"
            )
        ),
        rownames = TRUE
    ) %>%
        formatStyle(
            columns = seq_len(ncol(rv_mat)),
            backgroundColor = styleInterval(c(0.3, 0.6), c("#FFFFFF", "#FFF9F2", "#FFECCC")),
            color = mozza_couleurs[["texte"]],
            fontWeight = "500"
        )
})

# Synthèse sensorielle automatique ("Ce qu'il faut retenir")
output$analyse_afm_synthese <- renderUI({
    req(input$analyse_afm_afficher)
    res <- analyse_res_afm()
    p <- analyse_params()
    rv_mat <- res$group$RV
    
    if (p$type == "sens") {
        rv_saveur  <- round(rv_mat["Consommateurs", "Saveur"], 3)
        rv_texture <- round(rv_mat["Consommateurs", "Texture"], 3)
        rv_visuel  <- round(rv_mat["Consommateurs", "Visuel"], 3)
        
        tagList(
            div(class = "synthese-titre", icon("lightbulb"), " Ce qu'il faut retenir (Synthèse sensorielle) :"),
            p(
                "Le groupe le plus fortement corrélé à l'appréciation des consommateurs est la ",
                strong("Saveur"), sprintf(" (RV = %0.3f)", rv_saveur), ", suivi de la ",
                strong("Texture"), sprintf(" (RV = %0.3f)", rv_texture), ". L'aspect ",
                strong("Visuel"), sprintf(" a un impact plus modéré (RV = %0.3f)", rv_visuel), "."
            ),
            p(
                style = "margin-top: 0.4rem; font-size: 0.88rem; color: #7A4B1D;",
                "👉 La saveur et la texture sont les deux dimensions déterminantes pour prédire le succès hédonique d'une mozzarella."
            )
        )
    } else {
        rv_jury <- round(rv_mat["Consommateurs", "Jury"], 3)
        tagList(
            div(class = "synthese-titre", icon("lightbulb"), " Ce qu'il faut retenir (Synthèse globale) :"),
            p(
                "La liaison globale entre le profil établi par le jury entraîné (37 descripteurs) et les notes des consommateurs présente un coefficient ",
                strong(sprintf("RV = %0.3f", rv_jury)), "."
            ),
            p(
                style = "margin-top: 0.4rem; font-size: 0.88rem; color: #7A4B1D;",
                "👉 Cela confirme une corrélation notable entre les mesures d'experts et l'appréciation hédonique réelle du consommateur."
            )
        )
    }
})
