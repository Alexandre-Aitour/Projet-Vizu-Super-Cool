# ==================================================================================================
# Onglet : Analyse descriptive
# Préfixe des identifiants : descriptive_
# ==================================================================================================

# --------------------------------------- Partie Consommateurs

# Palette par dimension, aux couleurs d'un mozzastick : panure, croûte, sauce tomate, herbes
palette_dim <- c(
    "Global"  = "#E8913A",
    "Visuel"  = "#8B4A12",
    "Goût"    = "#C0392B",
    "Texture" = "#7A8B3A"
)

# Dimensions choisies, figées au clic sur le bouton (rien n'est affiché avant le premier clic)
descriptive_cons_dims <- eventReactive(input$descriptive_cons_afficher, {
    validate(need(length(input$descriptive_cons_dimensions) > 0,
                  "Sélectionnez au moins une dimension."))
    input$descriptive_cons_dimensions
})

output$descriptive_cons_distribution <- renderPlot({
    dims <- descriptive_cons_dims()

    # Passage en format long
    liking_long <- dta_cons %>%
        select(all_of(dims)) %>%
        pivot_longer(cols = everything(), names_to = "Dimension", values_to = "Note") %>%
        mutate(
            Dimension = factor(Dimension, levels = dims),
            Note = factor(Note, levels = 1:9)
        )

    # Distribution en pourcentage, par dimension et par note
    dist_notes <- liking_long %>%
        count(Dimension, Note, name = "n") %>%
        complete(Dimension, Note, fill = list(n = 0)) %>%
        group_by(Dimension) %>%
        mutate(pct = n / sum(n)) %>%
        ungroup()

    # Moyenne par dimension, pour la ligne repère
    moyennes <- liking_long %>%
        group_by(Dimension) %>%
        summarise(moyenne = mean(as.numeric(as.character(Note))), .groups = "drop")

    ggplot(dist_notes, aes(x = Note, y = pct, fill = Dimension)) +
        geom_col(width = 0.72, show.legend = FALSE) +
        geom_vline(
            data = moyennes,
            aes(xintercept = moyenne),
            linetype = "dashed", linewidth = 0.6, colour = mozza_couleurs[["texte"]]
        ) +
        geom_text(
            data = moyennes,
            aes(x = moyenne, y = Inf, label = paste0("moy = ", round(moyenne, 2))),
            inherit.aes = FALSE, vjust = 1.6, hjust = -0.08, size = 4,
            colour = mozza_couleurs[["texte"]], fontface = "bold", family = mozza_police
        ) +
        facet_wrap(~ Dimension, ncol = min(length(dims), 2), scales = "free_x") +
        scale_fill_manual(values = palette_dim) +
        scale_x_discrete(drop = FALSE) +
        scale_y_continuous(
            labels = percent_format(accuracy = 1),
            expand = expansion(mult = c(0, 0.18))
        ) +
        labs(
            title = "Distribution des notes de liking (échelle 1-9)",
            subtitle = paste(n_distinct(dta_cons$Consommateurs), "consommateurs x",
                             n_distinct(dta_cons$Produit), "bâtonnets de mozzarella panée"),
            x = "Note (1 = je déteste -- 9 = j'adore)",
            y = NULL
        ) +
        theme_mozza() +
        theme(
            strip.text = element_text(hjust = 0),
            panel.spacing = unit(1.1, "lines"),
            panel.grid.major.x = element_blank(),
            axis.title.x = element_text(margin = margin(t = 10))
        )
})

# ---------- Appréciation moyenne par produit

# Produits choisis, figés au clic sur le bouton (rien n'est affiché avant le premier clic)
descriptive_cons_prods <- eventReactive(input$descriptive_cons_moy_afficher, {
    validate(need(length(input$descriptive_cons_produits) > 0,
                  "Sélectionnez au moins un magasin."))
    input$descriptive_cons_produits
})

output$descriptive_cons_moyennes <- renderPlot({
    prods <- descriptive_cons_prods()

    moyennes_produit <- dta_cons %>%
        filter(Produit %in% prods) %>%
        group_by(Produit) %>%
        summarise(across(c(Global, Visuel, Goût, Texture), mean), .groups = "drop")

    # Produits triés du plus au moins apprécié (note globale)
    ordre_produits <- moyennes_produit %>%
        arrange(desc(Global)) %>%
        pull(Produit) %>%
        as.character()

    moyennes_produit <- moyennes_produit %>%
        pivot_longer(cols = c(Global, Visuel, Goût, Texture),
                     names_to = "Dimension", values_to = "moyenne") %>%
        mutate(
            Dimension = factor(Dimension, levels = names(palette_dim)),
            Produit = factor(Produit, levels = ordre_produits)
        )

    # Titre de chaque facette : le logo du magasin au-dessus de son nom (affiché par ggtext)
    etiquette_magasin <- function(m) {
        sprintf("<img src='www/logos/%s.png' height='32'/><br>%s", m, magasins_noms[m])
    }

    ggplot(moyennes_produit, aes(x = Dimension, y = moyenne, fill = Dimension)) +
        geom_col(width = 0.78) +
        geom_text(aes(label = sprintf("%.1f", moyenne)),
                  vjust = -0.5, size = 4, colour = mozza_couleurs[["texte"]], fontface = "bold",
                  family = mozza_police) +
        facet_wrap(~ Produit, nrow = 1, labeller = as_labeller(etiquette_magasin)) +
        scale_fill_manual(values = palette_dim, name = NULL) +
        scale_y_continuous(limits = c(0, 9), expand = expansion(mult = c(0, 0.10))) +
        labs(
            title = "Appréciation moyenne des bâtonnets de mozzarella, par dimension",
            subtitle = "Moyenne des notes de liking (échelle 1-9) — produits triés du plus au moins apprécié",
            x = NULL, y = NULL
        ) +
        theme_mozza() +
        theme(
            panel.spacing = unit(0.6, "lines"),
            strip.text = ggtext::element_markdown(face = "bold", halign = 0.5, lineheight = 1.3),
            panel.grid.major = element_blank(),
            axis.text = element_blank(),
            axis.ticks = element_blank(),
            legend.position = "bottom"
        )
})


# ---------------------------------------- Partie Jury
