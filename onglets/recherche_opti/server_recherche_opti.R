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
    sort(rowSums(abs(ecarts)))   # du plus proche au plus loin
})

# Envoie le gagnant (le plus petit écart total) à la roulette JavaScript de la pop-up
observeEvent(recherche_opti_resultat(), {
    ecart_total <- recherche_opti_resultat()
    gagnant <- names(ecart_total)[1]
    session$sendCustomMessage("recherche_opti_roulette", list(
        magasin = gagnant,
        nom     = unname(magasins_noms[gagnant]),
        ecart   = round(ecart_total[[1]], 2)
    ))
})
