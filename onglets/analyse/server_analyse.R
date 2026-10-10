# ==================================================================================================
# Onglet : Analyse Factorielle
# Préfixe des identifiants : analyse_
# Harmonisé avec global.R, descriptive et recherche_opti
# Visualisations interactives avec plotly (zoom au trackpad, pan, infobulles, axes dynamiques)
# ==================================================================================================

# ----------------------------------------------------------------------------------------------------
# 1. Préparation des données & calculs réactifs AFM
# ----------------------------------------------------------------------------------------------------

# Nettoyage et mise en forme lisible des descripteurs sensoriels
clean_desc_names <- function(names_vec) {
    names_vec <- str_replace_all(names_vec, "_", " ")
    names_vec <- str_replace_all(names_vec, "pâte crue", "Pâte crue")
    names_vec <- str_replace_all(names_vec, "collant  aux dents", "Collant aux dents")
    names_vec <- str_squish(names_vec)
    names_vec <- str_to_sentence(names_vec)
    names_vec
}

# Ordre des magasins par appréciation globale décroissante (pour le Top N)
magasins_par_note <- reactive({
    dta_cons %>%
        group_by(Produit) %>%
        summarise(note = mean(Global, na.rm = TRUE), .groups = "drop") %>%
        arrange(desc(note)) %>%
        pull(Produit) %>%
        as.character()
})

# Synchronisation du slider Top N avec les cases à cocher des magasins
observeEvent(input$analyse_nb_magasins, {
    req(input$analyse_nb_magasins)
    top_prods <- magasins_par_note()[seq_len(input$analyse_nb_magasins)]
    updateCheckboxGroupInput(session, "analyse_magasins", selected = top_prods)
}, ignoreInit = TRUE)

# Boutons de sélection rapide Tous / Aucun
observeEvent(input$analyse_magasins_tous, {
    updateSliderInput(session, "analyse_nb_magasins", value = length(levels(dta_cons$Produit)))
    updateCheckboxGroupInput(session, "analyse_magasins", selected = levels(dta_cons$Produit))
})

observeEvent(input$analyse_magasins_aucun, {
    updateCheckboxGroupInput(session, "analyse_magasins", selected = character(0))
})

# Tableau fusionné (Moyennes consommateurs + Jury de descripteurs nettoyés)
analyse_data_afm <- reactive({
    dta_cons_m <- dta_cons %>%
        group_by(Produit) %>%
        summarise(
            `Appréciation globale` = mean(Global, na.rm = TRUE),
            `Texture globale`      = mean(Texture, na.rm = TRUE),
            `Aspect visuel`        = mean(Visuel, na.rm = TRUE),
            `Goût global`          = mean(Goût, na.rm = TRUE)
        )
    
    # Nettoyage soigné des descripteurs du jury
    dta_panel_clean <- dta_panel
    colnames(dta_panel_clean)[-1] <- clean_desc_names(colnames(dta_panel)[-1])
    
    inner_join(dta_cons_m, dta_panel_clean, by = "Produit") %>%
        tibble::column_to_rownames("Produit")
})

# Paramètres figés au clic sur le bouton "Afficher"
analyse_params <- eventReactive(input$analyse_afm_afficher, {
    validate(
        need(length(input$analyse_magasins) > 0,
             "Sélectionnez au moins un magasin.")
    )
    
    dx <- as.numeric(input$analyse_dim_x)
    dy <- as.numeric(input$analyse_dim_y)
    if (dx == dy) dy <- if (dx == 1) 2 else 1
    
    list(
        type         = input$analyse_afm_type,
        show_partial    = isTRUE(input$analyse_afm_show_partial),
        show_logos      = isTRUE(input$analyse_afm_show_logos),
        show_ind_labels = isTRUE(input$analyse_afm_show_ind_labels),
        show_cons       = isTRUE(input$analyse_afm_show_cons),
        show_legend     = isTRUE(input$analyse_afm_show_legend),
        top_contrib  = input$analyse_afm_top_contrib,
        dim_x        = dx,
        dim_y        = dy,
        magasins     = input$analyse_magasins
    )
})

# Calcul du modèle AFM
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
# 2. Cartes d'indicateurs KPI (Value Boxes)
# ----------------------------------------------------------------------------------------------------

output$analyse_afm_kpis <- renderUI({
    req(input$analyse_afm_afficher)
    res <- analyse_res_afm()
    p <- analyse_params()
    
    # 1. Variance expliquée par le plan factoriel sélectionné
    eig <- res$eig
    var_x <- round(eig[p$dim_x, 2], 1)
    var_y <- round(eig[p$dim_y, 2], 1)
    var_cum <- round(var_x + var_y, 1)
    
    # 2. Produit champion parmi la sélection
    best_prod_df <- dta_cons %>%
        filter(Produit %in% p$magasins) %>%
        group_by(Produit) %>%
        summarise(note_moy = mean(Global, na.rm = TRUE), .groups = "drop") %>%
        slice_max(note_moy, n = 1)
    champ_nom <- if (nrow(best_prod_df) > 0) magasins_noms[[as.character(best_prod_df$Produit[1])]] else "-"
    champ_note <- if (nrow(best_prod_df) > 0) sprintf("%.2f/9", best_prod_df$note_moy[1]) else "-"
    
    # 3. Groupe le plus déterminant (plus fort RV avec Consommateurs)
    rv_mat <- res$group$RV
    top_grp_nom <- "Saveur"
    top_grp_rv  <- "0.00"
    if ("Consommateurs" %in% rownames(rv_mat)) {
        sens_rvs <- rv_mat["Consommateurs", setdiff(colnames(rv_mat), c("Consommateurs", "MFA"))]
        if (length(sens_rvs) > 0) {
            max_idx <- which.max(sens_rvs)
            top_grp_nom <- names(sens_rvs)[max_idx]
            top_grp_rv  <- sprintf("%.3f", sens_rvs[max_idx])
        }
    }
    
    div(
        class = "analyse-kpi-grid",
        
        # KPI 1 : Inertie captée
        div(
            class = "analyse-kpi-card",
            div(class = "analyse-kpi-icon", icon("chart-line")),
            div(
                class = "analyse-kpi-info",
                div(class = "analyse-kpi-titre", "Information captée"),
                div(class = "analyse-kpi-valeur", paste0(var_cum, "%")),
                div(class = "analyse-kpi-sub", sprintf("Dim %d (%s%%) + Dim %d (%s%%)", p$dim_x, var_x, p$dim_y, var_y))
            )
        ),
        
        # KPI 2 : Champion
        div(
            class = "analyse-kpi-card",
            div(class = "analyse-kpi-icon", icon("award")),
            div(
                class = "analyse-kpi-info",
                div(class = "analyse-kpi-titre", "Mozzarella favorite"),
                div(class = "analyse-kpi-valeur", champ_nom),
                div(class = "analyse-kpi-sub", paste("Note moyenne :", champ_note))
            )
        ),
        
        # KPI 3 : Moteur sensoriel n°1
        div(
            class = "analyse-kpi-card",
            div(class = "analyse-kpi-icon", icon("bullseye")),
            div(
                class = "analyse-kpi-info",
                div(class = "analyse-kpi-titre", "Moteur du succès"),
                div(class = "analyse-kpi-valeur", top_grp_nom),
                div(class = "analyse-kpi-sub", paste("Liaison RV =", top_grp_rv))
            )
        ),
        
        # KPI 4 : Descripteurs analysés
        div(
            class = "analyse-kpi-card",
            div(class = "analyse-kpi-icon", icon("sliders")),
            div(
                class = "analyse-kpi-info",
                div(class = "analyse-kpi-titre", "Descripteurs du panel"),
                div(class = "analyse-kpi-valeur", paste(p$top_contrib, "/ 37")),
                div(class = "analyse-kpi-sub", "Descripteurs les plus discriminants")
            )
        )
    )
})

# ----------------------------------------------------------------------------------------------------
# 3. Sorties graphiques interactives (Plotly)
# ----------------------------------------------------------------------------------------------------

# --- A. Projection des individus (Produits & points partiels)
output$analyse_afm_ind_plot <- renderPlotly({
    req(input$analyse_afm_afficher)
    res <- analyse_res_afm()
    p <- analyse_params()
    
    selected_magasins <- p$magasins
    partial_arg <- if (isTRUE(p$show_partial)) "all" else NULL
    geom_ind_choice <- if (isTRUE(p$show_ind_labels)) c("point", "text") else "point"
    
    p_ind <- fviz_mfa_ind(
        res,
        axes = c(p$dim_x, p$dim_y),
        select.ind = list(name = selected_magasins),
        partial = partial_arg,
        geom = geom_ind_choice,
        repel = FALSE,
        pointsize = 3.5,
        labelsize = 4.2
    ) + 
        theme_mozza() +
        labs(
            title = NULL,
            x = paste0("Dimension ", p$dim_x, " (", round(res$eig[p$dim_x, 2], 1), "%)"),
            y = paste0("Dimension ", p$dim_y, " (", round(res$eig[p$dim_y, 2], 1), "%)")
        )
    
    # Palette chaude harmonisée pour les groupes de variables
    mozza_group_palette <- c(
        "Visuel"        = "#8B4A12",
        "Saveur"        = "#C0392B",
        "Texture"       = "#7A8B3A",
        "Consommateurs" = "#E8913A",
        "Jury"          = "#8B4A12"
    )
    grp_names_known <- if (p$type == "sens") c("Visuel", "Saveur", "Texture") else c("Consommateurs", "Jury")
    
    # Nettoyage des niveaux de groupes partiels (suppression du préfixe magasin généré par FactoMineR/factoextra)
    if (isTRUE(p$show_partial)) {
        for (l_idx in seq_along(p_ind$layers)) {
            lyr <- p_ind$layers[[l_idx]]
            if (!is.null(lyr$data) && "group.name" %in% colnames(lyr$data)) {
                clean_grp <- rep(NA_character_, nrow(lyr$data))
                for (g in grp_names_known) {
                    clean_grp[grepl(paste0(g, "$"), lyr$data$group.name)] <- g
                }
                lyr$data$group.name <- factor(clean_grp, levels = grp_names_known)
                p_ind$layers[[l_idx]]$data <- lyr$data
            }
        }
        p_ind <- p_ind + 
            scale_colour_manual(values = mozza_group_palette, name = "Bloc sensoriel") +
            scale_linetype_manual(values = rep("dashed", length(grp_names_known)), guide = "none")
    }
    
    # Noms réels de magasins & infobulles propres
    if (isTRUE(p$show_ind_labels)) {
        if (!is.null(p_ind$data$name)) {
            p_ind$data$name <- unname(magasins_noms[p_ind$data$name])
        }
        for (l_idx in seq_along(p_ind$layers)) {
            if (!is.null(p_ind$layers[[l_idx]]$data) && "name" %in% colnames(p_ind$layers[[l_idx]]$data)) {
                if (inherits(p_ind$layers[[l_idx]]$geom, "GeomText")) {
                    p_ind$layers[[l_idx]]$data$name <- unname(magasins_noms[p_ind$layers[[l_idx]]$data$name])
                }
            }
        }
    } else {
        if (length(p_ind$layers) >= 1 && !is.null(p_ind$layers[[1]]$data$name)) {
            p_ind$layers[[1]]$data$name <- unname(magasins_noms[p_ind$layers[[1]]$data$name])
            p_ind$layers[[1]]$mapping <- aes(x = x, y = y, text = name)
        }
    }
    
    # Marqueur étoile sur le champion sélectionné
    best_prod_df <- dta_cons %>%
        filter(Produit %in% selected_magasins) %>%
        group_by(Produit) %>%
        summarise(note_moy = mean(Global, na.rm = TRUE), .groups = "drop") %>%
        slice_max(note_moy, n = 1)
    
    if (nrow(best_prod_df) > 0) {
        best_id   <- as.character(best_prod_df$Produit[1])
        best_nom  <- magasins_noms[[best_id]]
        best_note <- round(best_prod_df$note_moy[1], 2)
        
        coords <- as.data.frame(res$ind$coord)
        dim_x_name <- paste0("Dim.", p$dim_x)
        dim_y_name <- paste0("Dim.", p$dim_y)
        
        if (all(c(dim_x_name, dim_y_name) %in% colnames(coords)) && best_id %in% rownames(coords)) {
            champ_x <- coords[best_id, dim_x_name]
            champ_y <- coords[best_id, dim_y_name]
            
            y_span_all <- max(diff(range(coords[intersect(selected_magasins, rownames(coords)), dim_y_name], na.rm = TRUE)), 1.5)
            offset_y <- if (isTRUE(p$show_logos)) (y_span_all * 0.20 + 0.25) else 0.32
            
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
                    y = champ_y + offset_y, 
                    label = paste0("Favori : ", best_nom, " (", best_note, "/9)"), 
                    color = mozza_couleurs[["croute"]], 
                    fontface = "bold", 
                    family = mozza_police, 
                    size = 3.6
                )
        }
    }
    
    plt <- ggplotly(p_ind)
    
    # Libellés clairs et sobres pour la légende
    grp_labels <- c(
        "Visuel"        = "Visuel",
        "Saveur"        = "Saveur",
        "Texture"       = "Texture",
        "Consommateurs" = "Consommateurs",
        "Jury"          = "Jury"
    )
    
    # 1. Trace des points moyens des mozzarellas (barycentres)
    if (length(plt$x$data) >= 1) {
        plt$x$data[[1]]$name <- "Point moyen"
        plt$x$data[[1]]$legendgroup <- "Point moyen"
        plt$x$data[[1]]$showlegend <- isTRUE(p$show_legend) && isTRUE(p$show_partial)
        
        prods_order <- p_ind$data$name
        if (!is.null(prods_order) && length(prods_order) == length(plt$x$data[[1]]$x)) {
            notes_vec <- dta_cons %>%
                filter(Produit %in% prods_order) %>%
                group_by(Produit) %>%
                summarise(m = round(mean(Global, na.rm = TRUE), 2), .groups = "drop") %>%
                deframe()
            labels_mag <- unname(magasins_noms[as.character(prods_order)])
            notes_val  <- unname(notes_vec[as.character(prods_order)])
            plt$x$data[[1]]$text <- sprintf(
                "<b>%s</b> (Point moyen)<br>Dim %d : %.2f<br>Dim %d : %.2f<br>Note globale : %.2f/9",
                labels_mag, p$dim_x, plt$x$data[[1]]$x, p$dim_y, plt$x$data[[1]]$y, notes_val
            )
            plt$x$data[[1]]$hoverinfo <- "text"
        }
    }
    
    # 2. Nettoyage des traces plotly : fusion par groupe, masquage des lignes dans la légende
    for (i in seq_along(plt$x$data)) {
        if (i == 1) next
        tr <- plt$x$data[[i]]
        raw_name <- tr$name
        
        clean_grp <- NA_character_
        for (g in grp_names_known) {
            if (grepl(g, raw_name)) clean_grp <- g
        }
        
        if (!is.na(clean_grp)) {
            display_name <- unname(grp_labels[clean_grp])
            plt$x$data[[i]]$legendgroup <- clean_grp
            plt$x$data[[i]]$name <- display_name
            
            if (identical(tr$mode, "lines")) {
                # Segments partiels : liés au groupe sans polluer la légende ni afficher d'infobulle brute
                plt$x$data[[i]]$showlegend <- FALSE
                plt$x$data[[i]]$hoverinfo <- "none"
            } else if (identical(tr$mode, "markers")) {
                # Points partiels : une seule entrée par bloc sensoriel dans la légende
                plt$x$data[[i]]$showlegend <- isTRUE(p$show_legend)
                
                # Infobulle enrichie et soignée
                for (lyr in p_ind$layers) {
                    if (!is.null(lyr$data) && "group.name" %in% colnames(lyr$data) && 
                        inherits(lyr$geom, "GeomPoint")) {
                        lyr_sub <- lyr$data[lyr$data$group.name == clean_grp, ]
                        if (nrow(lyr_sub) == length(tr$x)) {
                            labels_mag <- unname(magasins_noms[as.character(lyr_sub$name)])
                            plt$x$data[[i]]$text <- sprintf(
                                "<b>%s</b> — %s<br>Dim %d : %.2f<br>Dim %d : %.2f",
                                labels_mag, clean_grp, p$dim_x, tr$x, p$dim_y, tr$y
                            )
                            plt$x$data[[i]]$hoverinfo <- "text"
                        }
                    }
                }
            }
        } else {
            # Lignes d'axes (hline, vline), annotations ou textes
            plt$x$data[[i]]$showlegend <- FALSE
        }
    }
    
    # Intégration des logos officiels des magasins
    if (isTRUE(p$show_logos) && length(selected_magasins) > 0) {
        coords <- as.data.frame(res$ind$coord)
        dim_x_name <- paste0("Dim.", p$dim_x)
        dim_y_name <- paste0("Dim.", p$dim_y)
        
        valid_prods <- intersect(selected_magasins, rownames(coords))
        if (length(valid_prods) > 0) {
            x_vals <- coords[valid_prods, dim_x_name]
            y_vals <- coords[valid_prods, dim_y_name]
            x_span <- max(diff(range(x_vals, na.rm = TRUE)), 1.5)
            y_span <- max(diff(range(y_vals, na.rm = TRUE)), 1.5)
            sizex  <- x_span * 0.20
            sizey  <- y_span * 0.20
            
            images_list <- lapply(valid_prods, function(m) {
                logo_file <- file.path("www/logos", paste0(m, ".png"))
                if (!file.exists(logo_file)) return(NULL)
                
                uri <- base64enc::dataURI(file = logo_file, mime = "image/png")
                list(
                    source  = uri,
                    xref    = "x",
                    yref    = "y",
                    x       = coords[m, dim_x_name],
                    y       = coords[m, dim_y_name] + sizey * 0.15,
                    sizex   = sizex,
                    sizey   = sizey,
                    sizing  = "contain",
                    xanchor = "center",
                    yanchor = "bottom",
                    layer   = "above"
                )
            })
            images_list <- compact(images_list)
            
            if (length(images_list) > 0) {
                plt <- plt %>% layout(images = images_list)
            }
        }
    }
    
    # Mise en page de la légende : compacte, verticale à droite et centrée pour éviter tout conflit avec la barre plotly et l'axe X
    if (isTRUE(p$show_legend) && isTRUE(p$show_partial)) {
        plt <- plt %>% layout(
            legend = list(
                orientation = "v",
                x = 1.02,
                xanchor = "left",
                y = 0.5,
                yanchor = "middle",
                bgcolor = "rgba(255, 255, 255, 0.9)",
                bordercolor = "#F3E3D0",
                borderwidth = 1,
                font = list(family = mozza_police, size = 11, color = mozza_couleurs[["texte"]])
            )
        )
    } else {
        plt <- plt %>% layout(showlegend = FALSE)
    }
    
    plt %>% config(
        scrollZoom = TRUE, 
        displaylogo = FALSE,
        displayModeBar = "hover",
        modeBarButtonsToRemove = c("lasso2d", "select2d", "hoverClosestCartesian", "hoverCompareCartesian", "toggleSpikelines")
    )
})

# --- B. Cercle des corrélations des variables quantitatives (AVEC NOMS DE VARIABLES VISIBLES)
output$analyse_afm_var_plot <- renderPlotly({
    req(input$analyse_afm_afficher)
    res <- analyse_res_afm()
    p <- analyse_params()
    
    # IMPORTANT : repel = FALSE pour que plotly affiche les textes (geom_text) sans les supprimer
    p_var <- fviz_mfa_var(
        res, 
        "quanti.var", 
        axes = c(p$dim_x, p$dim_y),
        repel = FALSE, 
        select.var = list(contrib = p$top_contrib),
        col.var = "contrib",
        gradient.cols = c("#F8B063", "#E8913A", "#8B4A12"),
        labelsize = 3.8
    ) + 
        theme_mozza() + 
        labs(
            title = paste0("Cercle des corrélations (Axes ", p$dim_x, " & ", p$dim_y, ")"),
            x = paste0("Dimension ", p$dim_x, " (", round(res$eig[p$dim_x, 2], 1), "%)"),
            y = paste0("Dimension ", p$dim_y, " (", round(res$eig[p$dim_y, 2], 1), "%)"),
            color = "Contrib (%)"
        )
    
    # Projection des variables de satisfaction consommateurs
    if (isTRUE(p$show_cons) && !is.null(res$quanti.var.sup)) {
        coord_sup <- as.data.frame(res$quanti.var.sup$coord)
        dim_x_col <- paste0("Dim.", p$dim_x)
        dim_y_col <- paste0("Dim.", p$dim_y)
        
        if (all(c(dim_x_col, dim_y_col) %in% colnames(coord_sup))) {
            coord_sup_sub <- data.frame(
                name = rownames(coord_sup),
                x = coord_sup[, dim_x_col],
                y = coord_sup[, dim_y_col],
                stringsAsFactors = FALSE
            )
            p_var <- p_var +
                geom_segment(
                    data = coord_sup_sub,
                    aes(x = 0, y = 0, xend = x, yend = y),
                    arrow = arrow(length = unit(0.22, "cm")),
                    color = "#C0392B",
                    linewidth = 0.9,
                    linetype = "dashed",
                    inherit.aes = FALSE
                ) +
                geom_text(
                    data = coord_sup_sub,
                    aes(x = x, y = y, label = name),
                    color = "#C0392B",
                    fontface = "bold",
                    size = 4,
                    inherit.aes = FALSE
                )
        }
    }
    
    ggplotly(p_var) %>%
        config(
            scrollZoom = TRUE, 
            displaylogo = FALSE,
            displayModeBar = "hover",
            modeBarButtonsToRemove = c("lasso2d", "select2d", "hoverClosestCartesian", "hoverCompareCartesian", "toggleSpikelines")
        )
})

# --- C. Graphe des groupes de variables
output$analyse_afm_group_plot <- renderPlotly({
    req(input$analyse_afm_afficher)
    res <- analyse_res_afm()
    p <- analyse_params()
    
    # Palette chaude cohérente avec le thème Mozza : Consommateurs, Visuel, Saveur, Texture
    mozza_group_palette <- c(
        "Consommateurs" = "#E8913A",
        "Visuel"        = "#8B4A12",
        "Saveur"        = "#C0392B",
        "Texture"       = "#7A8B3A",
        "Jury"          = "#8B4A12"
    )
    
    p_group <- fviz_mfa_var(
        res, 
        "group",
        axes = c(p$dim_x, p$dim_y),
        palette = unname(mozza_group_palette)
    ) + 
        theme_mozza() + 
        labs(
            title = paste0("Projection des groupes (Axes ", p$dim_x, " & ", p$dim_y, ")"),
            x = paste0("Dimension ", p$dim_x, " (", round(res$eig[p$dim_x, 2], 1), "%)"),
            y = paste0("Dimension ", p$dim_y, " (", round(res$eig[p$dim_y, 2], 1), "%)")
        )
    
    ggplotly(p_group) %>%
        config(scrollZoom = TRUE, displaylogo = FALSE)
})

# --- D. Matrice des coefficients RV
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
            fontWeight = "600"
        )
})

# --- E. Éboulis des valeurs propres (Variance expliquée par dimension)
output$analyse_afm_scree_plot <- renderPlotly({
    req(input$analyse_afm_afficher)
    res <- analyse_res_afm()
    
    p_scree <- fviz_screeplot(
        res, 
        addlabels = TRUE, 
        barfill = "#E8913A", 
        barcolor = "#8B4A12",
        linecolor = "#C0392B", 
        ylim = c(0, 50)
    ) +
        theme_mozza() +
        labs(
            title = "Variance expliquée par dimension (Éboulis)", 
            x = "Dimensions factorielles", 
            y = "% de variance expliquée"
        )
    
    ggplotly(p_scree) %>%
        config(scrollZoom = TRUE, displaylogo = FALSE)
})

# --- F. Top descripteurs contribuant aux axes
output$analyse_afm_contrib_plot <- renderPlotly({
    req(input$analyse_afm_afficher)
    res <- analyse_res_afm()
    p <- analyse_params()
    
    p_contrib <- fviz_contrib(
        res, 
        choice = "quanti.var", 
        axes = p$dim_x, 
        top = 10,
        fill = "#E8913A", 
        color = "#8B4A12"
    ) +
        theme_mozza() +
        labs(
            title = paste0("Top 10 descripteurs contribuant à l'Axe ", p$dim_x), 
            y = "Contribution (%)", 
            x = "Descripteurs"
        ) +
        theme(axis.text.x = element_text(angle = 40, hjust = 1))
    
    ggplotly(p_contrib) %>%
        config(scrollZoom = TRUE, displaylogo = FALSE)
})

# --- G. Synthèse sensorielle automatique ("Ce qu'il faut retenir")
output$analyse_afm_synthese <- renderUI({
    req(input$analyse_afm_afficher)
    res <- analyse_res_afm()
    p <- analyse_params()
    rv_mat <- res$group$RV
    
    # Favori parmi les magasins sélectionnés
    best_prod_df <- dta_cons %>%
        filter(Produit %in% p$magasins) %>%
        group_by(Produit) %>%
        summarise(note_moy = mean(Global, na.rm = TRUE), .groups = "drop") %>%
        slice_max(note_moy, n = 1)
        
    favori_ui <- if (nrow(best_prod_df) > 0) {
        best_id   <- as.character(best_prod_df$Produit[1])
        best_nom  <- magasins_noms[[best_id]]
        best_note <- round(best_prod_df$note_moy[1], 2)
        logo_path <- paste0("logos/", best_id, ".png?v=",
                            as.integer(file.mtime(file.path("www/logos", paste0(best_id, ".png")))))
        p(
            style = "margin-top: 0.6rem; padding-top: 0.5rem; border-top: 1px dashed var(--analyse-orange); font-size: 0.92rem;",
            tags$img(src = logo_path, height = "24px", style = "vertical-align: middle; margin-right: 8px;"),
            strong("Bâtonnet champion parmi la sélection : "),
            span(style = "color: var(--analyse-orange-fonce); font-weight: 700;", best_nom),
            sprintf(" (note globale moyenne de %0.2f/9)", best_note)
        )
    } else NULL
    
    if (p$type == "sens") {
        rv_saveur  <- round(rv_mat["Consommateurs", "Saveur"], 3)
        rv_texture <- round(rv_mat["Consommateurs", "Texture"], 3)
        rv_visuel  <- round(rv_mat["Consommateurs", "Visuel"], 3)
        
        tagList(
            div(class = "synthese-titre", icon("lightbulb"), " Ce qu'il faut retenir (Synthèse sensorielle) :"),
            p(
                "Le groupe sensoriel le plus fortement corrélé à l'appréciation des consommateurs est la ",
                strong("Saveur"), sprintf(" (RV = %0.3f)", rv_saveur), ", suivi de la ",
                strong("Texture"), sprintf(" (RV = %0.3f)", rv_texture), ". L'aspect ",
                strong("Visuel"), sprintf(" a un impact plus modéré (RV = %0.3f)", rv_visuel), "."
            ),
            p(
                style = "margin-top: 0.4rem; font-size: 0.88rem; color: #7A4B1D;",
                "La saveur et la texture sont les deux dimensions déterminantes pour le succès hédonique d'un bâtonnet de mozzarella. Les descripteurs orientés dans la même direction que la flèche « Appréciation globale » constituent les leviers clés d'optimisation."
            ),
            favori_ui
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
                "Cela confirme une corrélation notable entre les mesures d'experts et l'appréciation hédonique réelle du consommateur."
            ),
            favori_ui
        )
    }
})
