############################################ importationn des bibliothèques ############################################
require(tidyverse)
require(FactoMineR)
require(SensoMineR)
require(factoextra)
require(Factoshiny)
require(bslib)
require(DT)
require(plotly)
require(patchwork)

httpgd::hgd_browse()
############################################ importation des données ############################################
dta_cons <- read.csv2("data/mozza_consumers_liking.csv", stringsAsFactors = TRUE, sep = ",", dec = ".")
dta_panel <- read.csv2("data/mozza_panel_descriptors.csv", stringsAsFactors = TRUE, sep = ",", dec = ".")


dta_cons <- dta_cons %>% 
    mutate(Prod.ID = as.factor(Prod.ID))

dta_panel <- dta_panel %>%
    mutate(Prod.ID = as.factor(Prod.ID))
############################################ inspections de données ############################################

# détails des variables des données 
str(dta_cons)
str(dta_panel)

# résumé des données 
summary(dta_cons)
summary(dta_panel)

############################################ visualisation des données ############################################
var_plot <- colnames(dta_cons[,3:6])

for(var in var_plot){
    p <- ggplot(dta_cons, aes(x = Prod.ID, y = .data[[var]], color = Prod.ID, fill = Prod.ID)) + 
        geom_boxplot(alpha  = 0.3) + 
        theme_minimal() + 
        labs(
            title = paste("Distribution de : ", var),
            y = var, 
            x = "Produit"
        )
      print(p)  
    
}

############################################ test statistique ############################################

for(var in var_plot){
    cat("\n=============================================\n")
    cat(" ANOVA pour la variable :", var, "\n")
    cat("\n=============================================\n")
    
    # écriture de la formule
    form <- as.formula(paste(var, "~ Prod.ID"))

    # construction du modèle 
    res <- LinearModel(form, data = dta_cons)

    # affichage de la sortie du modèle
    print(res)

    # test post-hoc
    meansComp(res, ~ Prod.ID)

    
}


############################################ ACP sur le panel du jury ############################################

# on met le identifiant du produit en nom de ligne
panel_pca <- dta_panel %>% column_to_rownames("Prod.ID")

# on fait l'ACP
res_pca <- PCA(panel_pca, scale.unit = TRUE, graph = FALSE)

# graphe des individus 
fviz_pca_ind(res_pca)

# graphe des variables
fviz_pca_var(res_pca)


############################################ AFM ~ descripteur ############################################

# 1. On fusionne les deux jeux de données
dta_cons_m <- dta_cons %>%
    group_by(Prod.ID) %>%
    summarise(
         cons_overall = mean(Overall, na.rm = TRUE),
         cons_texture = mean(Texture, na.rm = TRUE),
         cons_appearance = mean(Appearance, na.rm = TRUE),
         cons_flavor = mean(Flavor, na.rm = TRUE)
    )

dta_afm <- inner_join(dta_cons_m, dta_panel, by = "Prod.ID") %>%
    column_to_rownames("Prod.ID")

# 2. On définit les groupes de variables
res_afm <- MFA(
    dta_afm, 
    group = c(4,6,16,15),
    type = c("c", "s", "s","s"),
    name.group = c("Consommateurs", "Visuel", "Saveur", "Texture"),
    num.group.sup = 1,
    graph = FALSE
)

# 3. la matrice des coefficients RV
cat("=== Lien entre les sens et les consommateurs ==== \n")
print(round(res_afm$group$RV, 3))

# 4. Affichage des graphiques
plot(res_afm, choix = "ind", ind.moy = FALSE, habillage = "group", partial = "all") # on regarde les individus
fviz_mfa_var(res_afm, "group") # on regarde les groupes 
fviz_mfa_var(res_afm, "quanti.var", repel = TRUE, select.var = list(contrib = 15)) # on regarde le cercle des corrélations des variables
plot(res_afm, choix = "axes", habillage = "group")


############################################ AFM ~ jury ############################################


# 1. On fusionne les deux jeux de données
dta_cons_m <- dta_cons %>%
    group_by(Prod.ID) %>%
    summarise(
         cons_overall = mean(Overall, na.rm = TRUE),
         cons_texture = mean(Texture, na.rm = TRUE),
         cons_appearance = mean(Appearance, na.rm = TRUE),
         cons_flavor = mean(Flavor, na.rm = TRUE)
    )

dta_afm <- inner_join(dta_cons_m, dta_panel, by = "Prod.ID") %>%
    column_to_rownames("Prod.ID")

# 2. On définit les groupes de variables
res_afm <- MFA(
    dta_afm, 
    group = c(4,37),
    type = c("s", "s"),
    name.group = c("Consommateurs", "Jury"),
    graph = FALSE
)

# 3. la matrice des coefficients RV
cat("=== Lien entre les sens et les consommateurs ==== \n")
print(round(res_afm$group$RV, 3))
print(round(res_afm$group$Lg, 3))

# 4. Affichage des graphiques
plot(res_afm, choix = "ind", ind.moy = FALSE, habillage = "group", partial = "all") # on regarde les individus
fviz_mfa_var(res_afm, "group") # on regarde les groupes 
fviz_mfa_var(res_afm, "quanti.var", repel = TRUE, select.var = list(contrib = 15)) # on regarde le cercle des corrélations des variables
plot(res_afm, choix = "axes", habillage = "group")
