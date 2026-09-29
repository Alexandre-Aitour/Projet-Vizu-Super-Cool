# ==================================================================================================
# 1. IMPORT DES LIBRAIRIES 
# ==================================================================================================
library(tidyverse)
library(FactoMineR)
library(plotly)
library(shiny)
library(bslib)
library(DT)
library(SensoMineR)
library(factoextra)
library(scales)

# ==================================================================================================
# 2. Chargement des données
# ==================================================================================================

dta_cons <- read.csv2("data/mozza_consumers_liking.csv", stringsAsFactors = TRUE, sep = ",", dec = ".") %>%
    mutate(Prod.ID = as.factor(Prod.ID))

dta_panel <- read.csv2("data/mozza_panel_descriptors.csv", stringsAsFactors = TRUE, sep = ",", dec = ".") %>%
    mutate(Prod.ID = as.factor(Prod.ID))

colnames(dta_cons) <- c("Consommateurs", "Produit", "Global", "Visuel", "Goût", "Texture")

colnames(dta_panel) <- c("Produit", "Régularité_de_la_forme", "Uniformité_de_la_panure",
                         "Aspect_gras", "visibilité_des_herbes", "Couleur",
                         "rugosité visuelle", "salé", "acide", "herbe_verte", "oignon-ail",
                         "Arôme_grillé", "Arôme_farineux", "mozzarella", "Goût_huilé",
                         "Aspect_carton", "produit_laitier_aigre", "Asséchant", "arrière_gout_herbe_verte",
                         "pâte_crue_", "arrière_gout_salé", "Arrière_gout_huilé", "arrière_gout_fromage",
                         "quantité_de_miettes", "gras_sur_les_lèvres", "rugosité", "dureté",
                         "Tenue", "croustillant", "libération_d'humidité", "Tenue_en_masse",
                         "rugosité de la masse", "absorption_d'humidité", "Nombre_mastications",
                         "persistance_du_croustillant", "film_gras", "particules_détachées", "collant_ aux_dents")

# Chaque produit reçoit au hasard une chaîne de magasin, qui remplace son identifiant.
# set.seed : le tirage est le même à chaque lancement, et identique pour les deux jeux de données.
set.seed(2026)
magasins <- setNames(
    sample(c("super_U", "leclerc", "picard", "grand_frais", "carrefour", "lidl", "auchan", "franprix")),
    levels(dta_cons$Produit)
)
dta_cons$Produit  <- factor(magasins[as.character(dta_cons$Produit)])
dta_panel$Produit <- factor(magasins[as.character(dta_panel$Produit)])

# ==================================================================================================
# 3. Charte graphique (reprise de la page d'accueil), commune à tous les onglets
# ==================================================================================================

# Couleurs de l'accueil
mozza_couleurs <- c(
    orange       = "#F8B063",
    orange_fonce = "#E8913A",
    creme        = "#FFF6EC",
    texte        = "#4A2C0F",
    croute       = "#8B4A12",
    fromage      = "#FCEBB2"
)

# Police Fredoka pour les graphiques : téléchargée une seule fois depuis Google Fonts,
# police par défaut si pas d'internet
if (!"Fredoka" %in% systemfonts::system_fonts()$family) {
    try(systemfonts::get_from_google_fonts("Fredoka"), silent = TRUE)
}
mozza_police <- if ("Fredoka" %in% systemfonts::system_fonts()$family) "Fredoka" else "sans"

# Thème ggplot aux couleurs de l'accueil
theme_mozza <- function(base_size = 14) {
    theme_minimal(base_size = base_size, base_family = mozza_police) +
        theme(
            text = element_text(colour = mozza_couleurs[["texte"]]),
            plot.title = element_text(face = "bold", size = rel(1.25)),
            plot.subtitle = element_text(colour = mozza_couleurs[["croute"]], margin = margin(b = 10)),
            strip.text = element_text(face = "bold", colour = mozza_couleurs[["texte"]]),
            strip.background = element_blank(),
            panel.grid.minor = element_blank(),
            panel.grid.major = element_line(colour = "#F3E3D0", linewidth = 0.4),
            axis.text = element_text(colour = mozza_couleurs[["croute"]])
        )
}

