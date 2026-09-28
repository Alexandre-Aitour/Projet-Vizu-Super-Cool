# ==================================================================================================
# Serveur
# ==================================================================================================


server <- function(input, output, session){
    # ==================================================================================================
    # Onglet 1 : Rendu des tableaux de données (DT)
    # ==================================================================================================

    # Table des consommateurs 
    output$dta_conso <- renderDT({
        datatable(
            dta_cons, 
            rownames = FALSE, 
            filter = "top",
            options = list(
                pageLength = 10,
                scrollX = TRUE,
                autoWidth = TRUE
            )
        )
    })

    # Table des descripteurs
    output$dta_panel <- renderDT({
        dta_round <- dta_panel %>%
            mutate(across(where(is.numeric), ~ round(.x, 2)))

        datatable(
            dta_round, 
            rownames = FALSE, 
            filter = "top",
            options = list(
                pageLength = 8,
                scrollX = TRUE,
                autoWidth = TRUE
            )
        )
    })

    # ==================================================================================================
    # Onglet 2: Consommateurs
    # ==================================================================================================

    # On filtre les données en fonction du produit sélectionné 
    dta_cons_filtree <- reactive({
        req(input$prods_choisis)
        dta_cons %>%
            filter(Prod.ID %in% input$prods_choisis)
    })

    # Boxplot interactif
    output$plot_boxplot_conso <- renderPlotly({
        req(input$dim_choisis)

        p <- ggplot(dta_cons_filtree(), aes(x = Prod.ID, y = .data[[input$dim_choisis]], fill = Prod.ID)) + 
            geom_boxplot(alpha = 0.6) + 
            theme_minimal() + 
            labs(
                title = paste("Distribution de :", input$dim_choisis),
                x = "Produit",
                y = "Note de 1 à 9"
            )
        ggplotly(p)
    })

    # Sortie de l'ANOVA
    output$stat_anova <- renderPrint({
        req(input$dim_choisis)

        formule <- as.formula(paste(input$dim_choisis, "~ Prod.ID"))
        modele <- LinearModel(formule, data = dta_cons_filtree())

        cat("================================================\n")
        cat("RÉSULTATS DE L'ANOVA :", input$dim_choisis, "\n")
        cat("================================================\n")

        cat("\n================================================\n")
        cat("COMPARAISON DES MOYENNES (meansComp) :\n")
        cat("================================================\n")
        print(meansComp(modele, ~ Prod.ID))
    })

    # ==================================================================================================
    # Onglet 3 : Analyse Factorielle Multiple (AFM)
    # ==================================================================================================

    # Préparation de la table fusionnée
    dta_afm_prep <- reactive({
        dta_cons_m <- dta_cons %>%
            group_by(Prod.ID) %>%
            summarise(
                cons_overall    = mean(Overall, na.rm = TRUE),
                cons_texture    = mean(Texture, na.rm = TRUE),
                cons_appearance = mean(Appearance, na.rm = TRUE),
                cons_flavor     = mean(Flavor, na.rm = TRUE),
                .groups = "drop"
            )

        inner_join(dta_cons_m, dta_panel, by = "Prod.ID") %>%
            column_to_rownames("Prod.ID")
    })

    # AFM
    res_afm <- reactive({
        dta <- dta_afm_prep()

        if(input$type_afm == "sens"){
            MFA(dta, 
                group = c(4, 6, 16, 15),
                type = c("c", "s", "s", "s"),
                name.group = c("Consommateurs", "Visuel", "Saveur", "Texture"),
                num.group.sup = 1,
                graph = FALSE)
        } else {
            MFA(dta,
                group = c(4, 37),
                type = c("s", "s"),
                name.group = c("Consommateurs", "Jury"),
                graph = FALSE)
        }
    })
}