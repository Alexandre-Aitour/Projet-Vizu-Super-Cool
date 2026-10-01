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
            # Chaque magasin dans sa propre case (fond crème + bordure), espacées entre elles
            panel.spacing = unit(1, "lines"),
            panel.background = element_rect(fill = mozza_couleurs[["creme"]], colour = "#F3E3D0",
                                            linewidth = 0.8),
            strip.background = element_rect(fill = mozza_couleurs[["creme"]], colour = "#F3E3D0",
                                            linewidth = 0.8),
            strip.text = ggtext::element_markdown(face = "bold", halign = 0.5, lineheight = 1.3,
                                                  margin = margin(6, 4, 6, 4)),
            panel.grid.major = element_blank(),
            axis.text = element_blank(),
            axis.ticks = element_blank(),
            legend.position = "bottom"
        )
})


# ---------------------------------------- Partie Jury

# ---------- Pouvoir discriminant des descripteurs du jury (graphique sans input)

# Table de synthèse : un descripteur par ligne, dispersion entre les produits
synth_descripteurs <- dta_panel %>%
    select(-Produit) %>%
    pivot_longer(everything(), names_to = "descripteur", values_to = "valeur") %>%
    group_by(descripteur) %>%
    summarise(
        min        = min(valeur),
        max        = max(valeur),
        etendue    = max - min,
        moyenne    = mean(valeur),
        ecart_type = sd(valeur),
        cv_pct     = 100 * ecart_type / moyenne,
        .groups = "drop"
    ) %>%
    # Noms lisibles : underscores remplacés par des espaces
    mutate(descripteur = str_squish(str_replace_all(descripteur, "_", " "))) %>%
    arrange(desc(cv_pct))

# Piste ketchup / moutarde / mayo : chaque descripteur est un mozzastick trempé dans une sauce,
# selon son pouvoir discriminant (CV) : mayo s'il varie peu, moutarde entre les deux, ketchup s'il discrimine.
sauces <- c(
    ketchup        = "#C0392B",
    ketchup_fonce  = "#8E2318",
    moutarde       = "#E1AD01",
    moutarde_fonce = "#9C7600",
    mayo           = "#F6E7A1",
    mayo_fonce     = "#C9A93B"
)

# Noms affichés dans la légende, de la sauce la plus forte à la plus douce
sauces_noms <- c(
    ketchup  = "Ketchup : discriminant",
    moutarde = "Moutarde : moyennement discriminant",
    mayo     = "Mayo : peu discriminant"
)

output$descriptive_jury_discriminant <- renderPlot({
    seuils_cv <- c(mayo = 10, moutarde = 20)  # seuils indicatifs
    n_desc <- nrow(synth_descripteurs)

    donnees <- synth_descripteurs %>%
        mutate(
            sauce = case_when(
                cv_pct < seuils_cv[["mayo"]]     ~ "mayo",
                cv_pct < seuils_cv[["moutarde"]] ~ "moutarde",
                TRUE                             ~ "ketchup"
            ),
            sauce = factor(sauces_noms[sauce], levels = sauces_noms)
        )

    # Lollipop horizontal : CV% trié du plus stable au plus discriminant
    ggplot(donnees, aes(x = fct_reorder(descripteur, cv_pct), y = cv_pct)) +
        # Les trois bols de sauce en fond : mayo, moutarde, puis ketchup
        annotate("rect", xmin = -Inf, xmax = Inf, ymin = 0, ymax = seuils_cv[["mayo"]],
                 fill = sauces[["mayo"]], alpha = 0.10) +
        annotate("rect", xmin = -Inf, xmax = Inf,
                 ymin = seuils_cv[["mayo"]], ymax = seuils_cv[["moutarde"]],
                 fill = sauces[["moutarde"]], alpha = 0.14) +
        annotate("rect", xmin = -Inf, xmax = Inf, ymin = seuils_cv[["moutarde"]], ymax = Inf,
                 fill = sauces[["ketchup"]], alpha = 0.06) +
        # Le bâtonnet pané...
        geom_segment(aes(xend = descripteur, y = 0, yend = cv_pct),
                     colour = mozza_couleurs[["orange"]], linewidth = 1.6, lineend = "round") +
        # ... trempé dans sa sauce
        geom_point(aes(fill = sauce, colour = sauce), shape = 21, size = 4.2, stroke = 1) +
        geom_hline(yintercept = seuils_cv, linetype = "dashed",
                   colour = mozza_couleurs[["croute"]], linewidth = 0.5) +
        annotate("text", x = n_desc - 1, y = seuils_cv,
                 label = paste0(" ", seuils_cv, " %"),
                 vjust = -0.6, hjust = 0, size = 4,
                 colour = mozza_couleurs[["croute"]], family = mozza_police) +
        scale_x_discrete() +
        coord_flip() +
        scale_fill_manual(values = setNames(sauces[names(sauces_noms)], sauces_noms),
                          name = NULL) +
        scale_colour_manual(values = setNames(sauces[paste0(names(sauces_noms), "_fonce")], sauces_noms),
                            name = NULL) +
        scale_y_continuous(labels = label_percent(scale = 1, accuracy = 1),
                           expand = expansion(mult = c(0, 0.08))) +
        labs(
            title = paste("Pouvoir discriminant des", n_desc, "descripteurs du jury"),
            subtitle = paste("Coefficient de variation (écart-type / moyenne) entre les",
                             n_distinct(dta_panel$Produit), "produits"),
            x = NULL, y = "Coefficient de variation"
        ) +
        theme_mozza() +
        theme(
            panel.grid.major.y = element_blank(),
            axis.text.y = element_text(size = 11),
            axis.title.x = element_text(margin = margin(t = 10)),
            legend.position = "top",
            legend.justification = "left",
            legend.text = element_text(size = 12)
        )
})
