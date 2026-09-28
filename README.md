# 🧀 Projet-Vizu-Super-Cool : Mozzarella Sensory Analysis

Application R Shiny d'analyse sensorielle : **Le profil d'un jury entraîné (37 descripteurs) permet-il de prédire l'appréciation des consommateurs sur 8 mozzarella sticks ?**

Ce projet explore les relations entre les données hédoniques des consommateurs (161 individus) et le profilage sensoriel objectif d'un jury d'experts (37 descripteurs : Visuel, Saveur, Texture).

---

## 📁 Architecture du Projet

Le projet est structuré de façon simple et modulaire :
- **Un `ui.R` et un `server.R` communs** qui ne font que charger les onglets avec `source()` : on n'y touche pas.
- **Un dossier par onglet (`onglets/<onglet>/`)** avec son `ui_<onglet>.R` et son `server_<onglet>.R` : chacun travaille uniquement dans les fichiers de son onglet.
- **Les identifiants Shiny sont préfixés par le nom de l'onglet** (`analyse_graphe`, `descriptive_table`…) pour éviter les doublons entre onglets.
- **Des scripts autonomes par axe d'analyse (`axe_*.R`)** pour tester les calculs hors de l'application.

```text
Projet-Vizu-Super-Cool/
├── global.R                # Packages et chargement des jeux de données
├── ui.R                    # UI commune (page_navbar + source des onglets)
├── server.R                # Serveur commun (source des onglets)
│
├── onglets/
│   ├── accueil/            # ui_accueil.R + server_accueil.R
│   ├── descriptive/        # ui_descriptive.R + server_descriptive.R (Consommateurs / Jury)
│   ├── analyse/            # ui_analyse.R + server_analyse.R
│   └── recherche_opti/     # ui_recherche_opti.R + server_recherche_opti.R
│
├── axe_1_descriptif.R      # Axe 1 : Analyse descriptive, ANOVA, ACP Jury
├── axe_2_afm.R             # Axe 2 : Analyse Factorielle Multiple (sens & jury)
├── axe_3_cartographie.R    # Axe 3 : Cartographie des préférences & Segmentation
│
├── data/                   # Données brutes (CSV)
│   ├── mozza_consumers_liking.csv
│   └── mozza_panel_descriptors.csv
│
└── www/                    # Images et ressources statiques de l'application
```

---

## 🌿 Guide de Travail en Équipe (Workflow Git)

Pour collaborer sereinement et éviter les conflits Git :

### 1. Règle d'or
- **Ne poussez jamais directement sur `main`**.
- Chaque membre travaille sur **sa propre branche** dédiée à son axe / fonctionnalité.
- Développez et testez vos visualisations et calculs statistiques dans votre script d'axe (`axe_1_descriptif.R`, `axe_2_afm.R` ou `axe_3_cartographie.R`).

### 2. Démarrer une nouvelle tâche (Créer sa branche)
Avant de commencer, mettez à jour votre code depuis `main` :
```bash
git switch main
git pull
git switch -c feature/nom-de-votre-axe
```
*(Exemple : `git switch -c feature/axe-2-afm` ou `git switch -c feature/benjamin-descriptif`)*

### 3. Travailler et enregistrer ses modifications
Dans votre branche, travaillez sur votre script dédié :
```bash
git status
git add .
git commit -m "feat: ajout des graphes d'individus partiels AFM"
```

### 4. Pousser sa branche sur GitHub
La première fois :
```bash
git push -u origin feature/nom-de-votre-axe
```
Ensuite, un simple `git push` suffit.

### 5. Intégrer son travail dans l'application Shiny (Pull Request)
1. Une fois vos graphiques et analyses validés dans votre script d'axe, intégrez les sorties correspondantes dans `ui.R` et `server.R`.
2. Mettez votre branche à jour avec `main` avant de fusionner :
   ```bash
   git fetch origin
   git merge origin/main
   ```
3. Rendez-vous sur GitHub pour ouvrir une **Pull Request (PR)** vers `main`.
4. Après relecture et validation de l'équipe, la PR est fusionnée !

---

## 🚀 Lancer l'Application Shiny

Dans votre console R (ou RStudio / VS Code) :
```r
shiny::runApp()
```
Ou bien :
```bash
Rscript -e "shiny::runApp(port = 3838)"
```
