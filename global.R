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
    

