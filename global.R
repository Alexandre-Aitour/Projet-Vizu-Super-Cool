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


    