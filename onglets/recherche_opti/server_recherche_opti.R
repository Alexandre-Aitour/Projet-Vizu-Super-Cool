# ==================================================================================================
# Onglet : Recherche optimale
# Préfixe des identifiants : recherche_opti_
# ==================================================================================================

# Les 5 descripteurs retenus (jeu F), écrits une seule fois
recherche_opti_descripteurs <- c("Aspect_gras", "mozzarella", "rugosité visuelle",
                                 "libération_d'humidité", "croustillant")

# Matrice des profils produits : 8 produits (lignes) x 5 descripteurs (colonnes)
data_recherche_opti <- dta_panel[, c("Produit", recherche_opti_descripteurs)] %>%
    column_to_rownames("Produit") %>%
    as.matrix()

# centré-réduite

recherche_opti_profils_cr <- scale(data_recherche_opti)
recherche_opti_profils_cr



recherche_opti_moy <- attr(recherche_opti_profils_cr, "scaled:center")
recherche_opti_moy
recherche_opti_et  <- attr(recherche_opti_profils_cr, "scaled:scale")
recherche_opti_et


# Étendue des produits sur chaque descripteur (le curseur 0-10 sera calé dessus)
recherche_opti_min <- apply(data_recherche_opti, 2, min)
recherche_opti_max <- apply(data_recherche_opti, 2, max)

# Transforme les 5 notes de l'utilisateur (0-10) dans le même repère que les produits
recherche_opti_convertir_notes <- function(notes) {
    # 1. note 0 -> produit le plus faible, note 10 -> produit le plus fort
    notes_data <- recherche_opti_min + (notes / 10) * (recherche_opti_max - recherche_opti_min)
    # 2. centrer-réduire avec les moyennes et écarts-types des produits
    (notes_data - recherche_opti_moy) / recherche_opti_et
    
    }
# exemple pour comprendre : Exemple pour la mozzarella avec une note de 5 : 
# 2.5 + 0.5 × (3.9 − 2.5) = 3.2, pile au milieu puis on centre et réduit 

# j'ai eu beaucoup de mal à faire cette fonction à l'aide
recherche_opti_user_cr <- recherche_opti_convertir_notes(c(5, 8, 2, 6, 7))

recherche_opti_ecarts <- sweep(recherche_opti_profils_cr, 2, recherche_opti_user_cr)
recherche_opti_ecarts


# --------------------------------------------------------------------------------------------------
# Bouton « Votre produit parfait » : on reprend les étapes ci-dessus avec les vraies notes
# --------------------------------------------------------------------------------------------------

# Écart total de chaque produit = somme des |écarts| sur les 5 descripteurs (valeur absolue :
# un écart de -1 compte autant qu'un écart de +1, ils ne s'annulent pas)
recherche_opti_resultat <- eventReactive(input$recherche_opti_go, {
    # Même ordre que recherche_opti_descripteurs
    notes <- c(input$recherche_opti_note_aspect_gras, input$recherche_opti_note_mozzarella,
               input$recherche_opti_note_rugosite, input$recherche_opti_note_humidite,
               input$recherche_opti_note_croustillant)
    user_cr <- recherche_opti_convertir_notes(notes)
    ecarts  <- sweep(recherche_opti_profils_cr, 2, user_cr)
    list(
        notes       = notes,
        ecart_total = sort(rowSums(abs(ecarts)))   # du plus proche au plus loin
    )
})

# Envoie le gagnant (le plus petit écart total) à la roulette JavaScript de la pop-up
observeEvent(recherche_opti_resultat(), {
    ecart_total <- recherche_opti_resultat()$ecart_total
    gagnant <- names(ecart_total)[1]
    session$sendCustomMessage("recherche_opti_roulette", list(
        magasin = gagnant,
        nom     = unname(magasins_noms[gagnant])
    ))
})

# --------------------------------------------------------------------------------------------------
# Bouton « Voir pourquoi ? » : ACP des 8 produits sur les 5 descripteurs,
# le produit idéal de l'utilisateur ajouté en individu supplémentaire
# --------------------------------------------------------------------------------------------------

# Logos lus une seule fois, pour les poser sur le graphique
recherche_opti_logos <- lapply(setNames(nm = names(magasins_noms)), function(m) {
    grid::rasterGrob(png::readPNG(file.path("www/logos", paste0(m, ".png"))), interpolate = TRUE)
})
recherche_opti_stick <- grid::rasterGrob(png::readPNG("www/accueil_stick.png"), interpolate = TRUE)

output$recherche_opti_acp <- renderPlot({
    res <- recherche_opti_resultat()
    gagnant <- names(res$ecart_total)[1]

    # Les notes 0-10 ramenées sur l'échelle du jury (même calcul que dans recherche_opti_convertir_notes)
    ideal <- recherche_opti_min + (res$notes / 10) * (recherche_opti_max - recherche_opti_min)
    donnees <- rbind(data_recherche_opti, "Votre idéal" = ideal)

    acp <- PCA(donnees, ind.sup = nrow(donnees), scale.unit = TRUE, graph = FALSE)

    produits <- data.frame(magasin = rownames(acp$ind$coord),
                           x = acp$ind$coord[, 1], y = acp$ind$coord[, 2])
    produits$gagnant <- produits$magasin == gagnant
    moi <- data.frame(x = acp$ind.sup$coord[1, 1], y = acp$ind.sup$coord[1, 2])
    gagnant_xy <- produits[produits$gagnant, ]

    # Flèches des descripteurs, agrandies pour occuper le nuage des produits
    etirement <- 0.85 * max(abs(c(produits$x, produits$y, moi$x, moi$y)))
    variables <- data.frame(nom = gsub("_", " ", rownames(acp$var$coord)),
                            x = acp$var$coord[, 1] * etirement,
                            y = acp$var$coord[, 2] * etirement)

    inertie <- round(acp$eig[1:2, 2], 1)
    tout_x <- c(produits$x, moi$x, variables$x)
    tout_y <- c(produits$y, moi$y, variables$y)
    l <- 0.17 * diff(range(tout_x))   # largeur d'un logo (il est 2 fois plus large que haut)

    # Ordre des couches : du fond vers l'avant, pour que les étiquettes restent lisibles
    p <- ggplot() +
        geom_hline(yintercept = 0, colour = mozza_couleurs[["orange"]], linetype = "dashed") +
        geom_vline(xintercept = 0, colour = mozza_couleurs[["orange"]], linetype = "dashed") +
        # Une auréole crème autour de l'idéal
        geom_point(data = moi, aes(x, y), size = 30, colour = mozza_couleurs[["fromage"]], alpha = 0.8) +
        # Le chemin de l'idéal vers le produit parfait
        geom_segment(data = moi, aes(x, y, xend = gagnant_xy$x, yend = gagnant_xy$y),
                     colour = mozza_couleurs[["orange_fonce"]], linewidth = 1.4, linetype = "22") +
        # Cartes blanches sous les logos ; le gagnant a un contour orange épais
        geom_tile(data = produits, aes(x, y, colour = gagnant, linewidth = gagnant),
                  width = l * 1.15, height = l * 0.65, fill = "white") +
        scale_colour_manual(values = c(`FALSE` = "#E9D3B8", `TRUE` = mozza_couleurs[["orange_fonce"]]),
                            guide = "none") +
        scale_linewidth_manual(values = c(`FALSE` = 0.6, `TRUE` = 2.2), guide = "none")

    # Les logos, posés un par un sur leur carte
    for (i in seq_len(nrow(produits))) {
        p <- p + annotation_custom(recherche_opti_logos[[produits$magasin[i]]],
                                   xmin = produits$x[i] - l / 2, xmax = produits$x[i] + l / 2,
                                   ymin = produits$y[i] - l / 4, ymax = produits$y[i] + l / 4)
    }

    p +
        # Le mozzastick de l'utilisateur
        annotation_custom(recherche_opti_stick,
                          xmin = moi$x - l * 0.6, xmax = moi$x + l * 0.6,
                          ymin = moi$y - l / 5, ymax = moi$y + l / 5) +
        # Descripteurs, par-dessus tout le reste
        geom_segment(data = variables, aes(0, 0, xend = x, yend = y),
                     colour = mozza_couleurs[["croute"]], linewidth = 0.9, alpha = 0.6,
                     arrow = arrow(length = unit(0.25, "cm"), type = "closed")) +
        ggrepel::geom_label_repel(data = variables, aes(x, y, label = nom),
                                  family = mozza_police, colour = mozza_couleurs[["croute"]],
                                  fill = alpha("#FFFDF8", 0.9), label.size = 0, size = 4.2, seed = 1) +
        annotate("label", x = moi$x, y = moi$y - l * 0.45, label = "Votre idéal",
                 family = mozza_police, fontface = "bold", colour = "white",
                 fill = mozza_couleurs[["orange_fonce"]], border.colour = NA, size = 4.5) +
        coord_equal(xlim = range(tout_x) + c(-l, l) * 0.7, ylim = range(tout_y) + c(-l, l) * 0.5) +
        labs(x = sprintf("Dimension 1 (%s %% de l'information)", inertie[1]),
             y = sprintf("Dimension 2 (%s %% de l'information)", inertie[2])) +
        theme_mozza(15) +
        theme(plot.background  = element_rect(fill = mozza_couleurs[["creme"]], colour = NA),
              panel.background = element_rect(fill = "#FFFDF8", colour = NA))
}, res = 96, bg = "transparent")

# --------------------------------------------------------------------------------------------------
# Bouton « Voir le magasin le plus proche » : carte avec le magasin de l'enseigne gagnante le plus
# proche de l'utilisateur, et l'itinéraire en voiture
# --------------------------------------------------------------------------------------------------

# Les magasins des 8 enseignes en France (préparés par data/preparation_magasins.R)
recherche_opti_magasins <- read_csv("data/magasins.csv", show_col_types = FALSE)

# Distance à vol d'oiseau en km (formule de haversine : la Terre est une sphère de rayon 6371 km)
recherche_opti_distance_km <- function(lat1, lon1, lat2, lon2) {
    rad <- pi / 180
    a <- sin((lat2 - lat1) * rad / 2)^2 +
        cos(lat1 * rad) * cos(lat2 * rad) * sin((lon2 - lon1) * rad / 2)^2
    2 * 6371 * asin(sqrt(a))
}

# Itinéraire en voiture par OSRM (serveur public d'OpenStreetMap) ; NULL si le service ne répond pas
recherche_opti_itineraire <- function(depart, arrivee) {
    url <- sprintf("https://router.project-osrm.org/route/v1/driving/%f,%f;%f,%f?overview=full&geometries=geojson",
                   depart$lon, depart$lat, arrivee$lon, arrivee$lat)
    tryCatch({
        route <- httr2::request(url) %>%
            httr2::req_timeout(10) %>%
            httr2::req_perform() %>%
            httr2::resp_body_json(simplifyVector = TRUE)
        list(trace   = route$routes$geometry$coordinates[[1]],   # matrice lon / lat
             km      = route$routes$distance[1] / 1000,
             minutes = route$routes$duration[1] / 60)
    }, error = function(e) NULL)
}

# Position de l'utilisateur : par le navigateur (géolocalisation) ou par la ville qu'il a tapée
recherche_opti_position <- reactiveVal(NULL)
recherche_opti_etat <- reactiveVal("attente")   # attente / refus / introuvable / ok

observeEvent(input$recherche_opti_position, {
    recherche_opti_position(list(lat = input$recherche_opti_position$lat,
                                 lon = input$recherche_opti_position$lon,
                                 origine = "Votre position"))
})
observeEvent(input$recherche_opti_position_refus, recherche_opti_etat("refus"))

# Recherche d'une ville avec Nominatim (le géocodeur d'OpenStreetMap)
observeEvent(input$recherche_opti_ville_go, {
    req(nzchar(trimws(input$recherche_opti_ville)))
    lieu <- tryCatch(
        httr2::request("https://nominatim.openstreetmap.org/search") %>%
            httr2::req_url_query(q = input$recherche_opti_ville, format = "json",
                                 countrycodes = "fr", limit = 1) %>%
            httr2::req_user_agent("MozzaStick, projet etudiant Agro Rennes") %>%
            httr2::req_timeout(10) %>%
            httr2::req_perform() %>%
            httr2::resp_body_json(simplifyVector = TRUE),
        error = function(e) NULL
    )
    if (length(lieu) == 0 || NROW(lieu) == 0) {
        recherche_opti_etat("introuvable")
    } else {
        recherche_opti_position(list(lat = as.numeric(lieu$lat[1]), lon = as.numeric(lieu$lon[1]),
                                     origine = input$recherche_opti_ville))
    }
})

# Le magasin le plus proche de l'enseigne gagnante, et le trajet pour y aller
recherche_opti_trajet <- reactive({
    moi <- recherche_opti_position()
    req(moi, recherche_opti_resultat())
    gagnant <- names(recherche_opti_resultat()$ecart_total)[1]

    proche <- recherche_opti_magasins %>%
        filter(magasin == gagnant) %>%
        mutate(km = recherche_opti_distance_km(moi$lat, moi$lon, lat, lon)) %>%
        slice_min(km, n = 1, with_ties = FALSE)

    list(moi = moi, magasin = proche, gagnant = gagnant,
         route = recherche_opti_itineraire(moi, proche))
})
observeEvent(recherche_opti_trajet(), recherche_opti_etat("ok"))

# Fond de carte : la France entière, en attendant la position
output$recherche_opti_carte <- leaflet::renderLeaflet({
    leaflet::leaflet() %>%
        leaflet::addTiles() %>%
        leaflet::setView(lng = 2.4, lat = 46.6, zoom = 5)
})

# Dès qu'on a le trajet : marqueurs, itinéraire, puis on « vole » de la France jusqu'au trajet
observeEvent(recherche_opti_trajet(), {
    t <- recherche_opti_trajet()
    icone_moi <- leaflet::makeIcon("accueil_stick.png", iconWidth = 70, iconHeight = 28,
                                   className = "recherche_opti-pin-moi")
    icone_magasin <- leaflet::makeIcon(paste0("logos/", t$gagnant, ".png"), iconWidth = 64, iconHeight = 32,
                                       className = "recherche_opti-pin-magasin")
    # Sans itinéraire (service indisponible), on trace une ligne droite en pointillés
    trace <- if (is.null(t$route)) cbind(c(t$moi$lon, t$magasin$lon), c(t$moi$lat, t$magasin$lat))
             else t$route$trace

    leaflet::leafletProxy("recherche_opti_carte", session) %>%
        leaflet::clearMarkers() %>%
        leaflet::clearShapes() %>%
        # Un trait blanc large sous le trait orange : l'itinéraire ressort mieux
        leaflet::addPolylines(lng = trace[, 1], lat = trace[, 2], color = "#FFFFFF", weight = 10, opacity = 1) %>%
        leaflet::addPolylines(lng = trace[, 1], lat = trace[, 2], color = mozza_couleurs[["orange_fonce"]],
                              weight = 6, opacity = 1, dashArray = if (is.null(t$route)) "8 10" else NULL) %>%
        leaflet::addMarkers(lng = t$moi$lon, lat = t$moi$lat, icon = icone_moi, label = t$moi$origine) %>%
        leaflet::addMarkers(lng = t$magasin$lon, lat = t$magasin$lat, icon = icone_magasin,
                            label = paste(t$magasin$enseigne, t$magasin$ville)) %>%
        leaflet::flyToBounds(min(trace[, 1]), min(trace[, 2]), max(trace[, 1]), max(trace[, 2]),
                             options = list(padding = c(60, 60), duration = 2.5))
})

# Encart à côté de la carte : où est le magasin, à combien de temps, et le lien Google Maps
output$recherche_opti_magasin_infos <- renderUI({
    etat <- recherche_opti_etat()
    if (etat == "attente") {
        return(p(class = "recherche_opti-infos-statut", "📡 On cherche où vous êtes…"))
    }
    if (etat == "refus") {
        return(p(class = "recherche_opti-infos-statut",
                 "📍 Position non partagée : entrez votre ville ci-dessous."))
    }
    if (etat == "introuvable") {
        return(p(class = "recherche_opti-infos-statut", "🤔 Ville introuvable, essayez une autre orthographe."))
    }

    t <- recherche_opti_trajet()
    m <- t$magasin
    lien <- sprintf("https://www.google.com/maps/dir/?api=1&origin=%f,%f&destination=%f,%f&travelmode=driving",
                    t$moi$lat, t$moi$lon, m$lat, m$lon)
    km <- if (is.null(t$route)) m$km else t$route$km
    duree <- if (is.null(t$route)) NULL else round(t$route$minutes)

    tagList(
        div(class = "recherche_opti-infos-logo",
            img(src = paste0("logos/", t$gagnant, ".png"), alt = m$enseigne)),
        h4(m$enseigne),
        p(class = "recherche_opti-infos-adresse",
          paste(na.omit(c(m$adresse, paste(na.omit(c(m$cp, m$ville)), collapse = " "))), collapse = ", ")),
        div(
            class = "recherche_opti-infos-chiffres",
            div(span(class = "valeur", sprintf("%.1f km", km)),
                span(class = "unite", if (is.null(t$route)) "à vol d'oiseau" else "en voiture")),
            if (!is.null(duree)) div(
                span(class = "valeur", if (duree < 60) paste(duree, "min")
                                       else sprintf("%dh%02d", duree %/% 60, duree %% 60)),
                span(class = "unite", "de trajet"))
        ),
        if (is.null(t$route)) p(class = "recherche_opti-infos-statut", "Itinéraire indisponible pour le moment."),
        tags$a(class = "recherche_opti-action recherche_opti-lien-gmaps", href = lien, target = "_blank",
               rel = "noopener", "🧭 Ouvrir l'itinéraire")
    )
})
