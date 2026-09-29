# ==================================================================================================
# Onglet : Analyse
# Préfixe des identifiants : analyse_
# Direction Artistique : Harmonisation Mozzarella / Fromage chaud
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

# Calcul de l'AFM selon le modèle choisi
analyse_res_afm <- reactive({
    req(input$analyse_afm_type)
    df <- analyse_data_afm()
    
    if (input$analyse_afm_type == "sens") {
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

# Thème ggplot commun aux couleurs de l'application
analyse_theme_mozza <- function() {
    theme_minimal(base_family = "sans") +
        theme(
            plot.title = element_text(color = "#4A2C0F", face = "bold", size = 13, hjust = 0),
            axis.title = element_text(color = "#4A2C0F", face = "bold", size = 11),
            axis.text  = element_text(color = "#5A3A1A", size = 9),
            panel.grid.minor = element_blank(),
            panel.grid.major = element_line(color = "#F3E3D0", linewidth = 0.5),
            legend.title = element_text(color = "#4A2C0F", face = "bold", size = 10),
            legend.text  = element_text(color = "#4A2C0F", size = 9)
        )
}

# ----------------------------------------------------------------------------------------------------
# 2. Sorties graphiques et tabulaires de l'AFM
# ----------------------------------------------------------------------------------------------------

# Carte des individus (produits) : moyens et partiels
output$analyse_afm_ind_plot <- renderPlot({
    res <- analyse_res_afm()
    if (isTRUE(input$analyse_afm_show_partial)) {
        par(family = "sans", col.main = "#4A2C0F", col.axis = "#4A2C0F", col.lab = "#4A2C0F", font.main = 2)
        plot(
            res, 
            choix = "ind", 
            ind.moy = TRUE, 
            habillage = "group", 
            partial = "all",
            title = "Carte des mozzarellas (points moyens et partiels)"
        )
    } else {
        fviz_mfa_ind(
            res, 
            repel = TRUE, 
            col.ind = "#E8913A",
            pointsize = 3.5,
            labelsize = 4.5
        ) + 
            analyse_theme_mozza() +
            labs(title = "Carte des mozzarellas (Points moyens)")
    }
})

# Graphe des groupes de variables
output$analyse_afm_group_plot <- renderPlot({
    fviz_mfa_var(
        analyse_res_afm(), 
        "group",
        palette = c("#E8913A", "#D9534F", "#3B82F6", "#10B981")
    ) + 
        analyse_theme_mozza() + 
        labs(title = "Contribution et liaison des groupes de variables")
})

# Matrice des coefficients RV
output$analyse_afm_rv_table <- renderDT({
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
            color = "#4A2C0F",
            fontWeight = "500"
        )
})

# Cercle des corrélations des variables quantitatives
output$analyse_afm_var_plot <- renderPlot({
    fviz_mfa_var(
        analyse_res_afm(), 
        "quanti.var", 
        repel = TRUE, 
        select.var = list(contrib = input$analyse_afm_top_contrib),
        col.var = "contrib",
        gradient.cols = c("#F4D57E", "#F8B063", "#D9534F")
    ) + 
        analyse_theme_mozza() + 
        labs(
            title = "Cercle des corrélations des variables quantitatives",
            color = "Contribution"
        )
})
