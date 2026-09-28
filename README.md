# 🧀 Projet-Vizu-Super-Cool : Mozzarella Sensory Analysis

Application R Shiny d'analyse sensorielle : **le profil d'un jury entraîné (37 descripteurs) permet-il de prédire l'appréciation des consommateurs sur 8 mozzarella sticks ?**

Le projet met en relation deux jeux de données :
- **Consommateurs** : les notes hédoniques (échelle de 1 à 9) de 161 consommateurs sur 8 produits, selon 4 dimensions (Overall, Appearance, Flavor, Texture).
- **Jury** : le profil sensoriel des 8 produits établi par un jury entraîné, sur 37 descripteurs (visuel, saveur, texture).

---

## 📁 Structure du repo

```text
Projet-Vizu-Super-Cool/
├── global.R                    # Packages et chargement des données
├── ui.R                        # UI commune : page_navbar + source() des onglets
├── server.R                    # Serveur commun : source() des onglets
│
├── onglets/                    # Un dossier par onglet de l'application
│   ├── accueil/                # ui_accueil.R + server_accueil.R
│   ├── descriptive/            # ui_descriptive.R + server_descriptive.R (Consommateurs / Jury)
│   ├── analyse/                # ui_analyse.R + server_analyse.R
│   └── recherche_opti/         # ui_recherche_opti.R + server_recherche_opti.R
│
├── axe_1_descriptif.R          # Scripts de travail hors application
├── axe_2_afm.R
├── axe_3_cartographie.R
├── projet.r                    # Script d'exploration initial
├── partie_descriptive.qmd      # Rapport Quarto de la partie descriptive (+ .html et _files/)
│
├── data/
│   ├── mozza_consumers_liking.csv
│   └── mozza_panel_descriptors.csv
│
└── www/                        # Images de l'application
```

`ui.R` et `server.R` ne font que charger les onglets : chaque onglet se code dans ses deux fichiers `onglets/<onglet>/ui_<onglet>.R` et `onglets/<onglet>/server_<onglet>.R`. Les identifiants Shiny sont préfixés par le nom de l'onglet (`analyse_graphe`, `descriptive_table`…) pour éviter les doublons entre onglets.

Pour lancer l'application, depuis la racine du repo dans R :

```r
shiny::runApp()
```
