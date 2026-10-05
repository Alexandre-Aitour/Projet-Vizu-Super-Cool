# ==================================================================================================
# Préparation de data/magasins.csv : les magasins des 8 enseignes en France (nom, adresse, GPS)
# À lancer une seule fois (l'appli lit ensuite le CSV, sans dépendre d'internet pour cette partie)
#
# Sources libres :
#   - All the Places (alltheplaces.xyz) : localisateurs officiels des enseignes, licence CC0
#   - OpenStreetMap via Overpass (miroir français) pour Système U, absent d'All the Places, licence ODbL
# ==================================================================================================
library(tidyverse)
library(jsonlite)

atp <- "https://alltheplaces-data.openaddresses.io/runs/"

# Une enseigne de l'appli -> le fichier All the Places correspondant (franprix est vide dans la
# dernière collecte, on prend la précédente)
sources_atp <- c(
    auchan      = "2026-09-26-13-32-25/output/auchan_fr.geojson",
    carrefour   = "2026-09-26-13-32-25/output/carrefour_fr.geojson",
    leclerc     = "2026-09-26-13-32-25/output/e_leclerc.geojson",
    grand_frais = "2026-09-26-13-32-25/output/grand_frais.geojson",
    picard      = "2026-09-26-13-32-25/output/picard_fr.geojson",
    lidl        = "2026-09-26-13-32-25/output/lidl.geojson",
    franprix    = "2026-09-19-13-32-18/output/franprix_fr.geojson"
)

# Seulement les magasins alimentaires (pas de drive, station-service, parapharmacie, bijouterie...)
types_gardes <- c("supermarket", "convenience", "frozen_food")

# Lit une propriété sur toutes les entrées, NA si elle manque
propriete <- function(props, nom) map_chr(props, ~ .x[[nom]] %||% NA_character_)

lire_atp <- function(magasin, chemin) {
    geo <- fromJSON(paste0(atp, chemin), simplifyVector = FALSE)$features
    props <- map(geo, "properties")
    coords <- map(geo, ~ unlist(.x$geometry$coordinates))
    tibble(
        magasin  = magasin,
        enseigne = propriete(props, "brand"),
        type     = propriete(props, "shop"),
        pays     = propriete(props, "addr:country"),
        adresse  = coalesce(propriete(props, "addr:street_address"),
                            str_trim(paste(propriete(props, "addr:housenumber") %>% replace_na(""),
                                           propriete(props, "addr:street")))),
        cp       = propriete(props, "addr:postcode"),
        ville    = propriete(props, "addr:city"),
        lon      = map_dbl(coords, ~ .x[1] %||% NA_real_),
        lat      = map_dbl(coords, ~ .x[2] %||% NA_real_)
    )
}

magasins_atp <- imap_dfr(sources_atp, ~ lire_atp(.y, .x)) %>%
    filter(pays == "FR", type %in% types_gardes,
           !str_detect(enseigne, "Drive|Potager City|marché d'à côté"))

# Système U : OpenStreetMap, tous les magasins portant l'identifiant Wikidata de Système U.
# Les serveurs Overpass sont parfois saturés : on réessaie quelques fois.
requete_u <- "[out:json][timeout:600];
nwr['shop']['brand:wikidata'='Q2529029'](41.2,-5.3,51.2,9.7);
out center tags;"
osm_u <- NULL
for (essai in 1:3) {
    osm_u <- tryCatch(
        httr2::request("https://overpass.openstreetmap.fr/api/interpreter") %>%
            httr2::req_user_agent("MozzaStick, projet etudiant Agro Rennes") %>%
            httr2::req_body_form(data = requete_u) %>%
            httr2::req_timeout(650) %>%
            httr2::req_perform() %>%
            httr2::resp_body_json(),
        error = function(e) NULL
    )
    if (length(osm_u$elements) > 0) break
}
stopifnot("Overpass n'a rien renvoyé pour Système U, relancer plus tard" = length(osm_u$elements) > 0)

tags_u <- map(osm_u$elements, "tags")
magasins_u <- tibble(
    magasin  = "super_U",
    enseigne = propriete(tags_u, "brand"),
    type     = propriete(tags_u, "shop"),
    adresse  = str_trim(paste(propriete(tags_u, "addr:housenumber") %>% replace_na(""),
                              propriete(tags_u, "addr:street") %>% replace_na(""))),
    cp       = propriete(tags_u, "addr:postcode"),
    ville    = propriete(tags_u, "addr:city"),
    # un point (node) a lat/lon, un bâtiment (way) a un centre
    lat      = map_dbl(osm_u$elements, ~ .x$lat %||% .x$center$lat),
    lon      = map_dbl(osm_u$elements, ~ .x$lon %||% .x$center$lon)
) %>%
    filter(type %in% types_gardes) %>%   # « convenience;gas » = boutique de station-service, écartée
    mutate(adresse = na_if(adresse, ""))

magasins <- bind_rows(magasins_atp %>% select(-pays), magasins_u) %>%
    filter(!is.na(lat), !is.na(lon)) %>%
    mutate(ville = str_to_title(ville)) %>%
    distinct(magasin, lat, lon, .keep_all = TRUE) %>%
    select(magasin, enseigne, adresse, cp, ville, lat, lon)

count(magasins, magasin)
write_csv(magasins, "data/magasins.csv")
