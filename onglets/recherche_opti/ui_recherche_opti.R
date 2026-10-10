# ==================================================================================================
# Onglet : Recherche optimale
# Préfixe des identifiants : recherche_opti_
# ==================================================================================================

# --------------------------------------------------------------------------------------------------
# Style de l'onglet, repris de la charte de l'accueil
# (limité aux classes recherche_opti-* pour ne pas toucher les autres onglets)
# --------------------------------------------------------------------------------------------------
recherche_opti_css <- "
.recherche_opti-page {
    --recherche_opti-orange: #F8B063;
    --recherche_opti-orange-fonce: #E8913A;
    --recherche_opti-creme: #FFF6EC;
    --recherche_opti-texte: #4A2C0F;
    --recherche_opti-croute: #8B4A12;
    --recherche_opti-bordure: #F3E3D0;
    min-height: 100vh;
    margin: -1rem;
    padding: 1.5rem;
    background: var(--recherche_opti-creme);
    color: var(--recherche_opti-texte);
    font-family: 'Fredoka', 'Arial Rounded MT Bold', sans-serif;
}

/* ---------- En-tête : le titre entre deux mozzasticks ---------- */
.recherche_opti-entete {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 1.2rem;
    margin-bottom: 1.2rem;
}
.recherche_opti-entete h2 {
    margin: 0;
    font-weight: 700;
    color: var(--recherche_opti-orange-fonce);
    text-shadow: 0 2px 0 rgba(139, 74, 18, 0.15);
}
.recherche_opti-entete img {
    height: 42px;
    filter: drop-shadow(0 6px 6px rgba(120, 60, 10, 0.30));
}
.recherche_opti-entete img.gauche { transform: rotate(-8deg); }
.recherche_opti-entete img.droite { transform: rotate(8deg) scaleX(-1); }

/* ---------- Espace explicatif ---------- */
.recherche_opti-intro {
    max-width: 700px;
    margin: 0 auto 1.6rem;
    padding: 1.1rem 1.4rem;
    background: linear-gradient(135deg, #FFFDF8 0%, #FFF4E3 100%);
    border-left: 4px solid var(--recherche_opti-orange-fonce);
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(120, 60, 10, 0.05);
    text-align: center;
}
.recherche_opti-intro h3 {
    margin: 0 0 0.5rem;
    color: var(--recherche_opti-orange-fonce);
    font-weight: 700;
}
.recherche_opti-intro p {
    margin: 0;
    line-height: 1.5;
}

/* ---------- Les 5 curseurs mozzastick en étoile autour du bouton ---------- */
/* Pentagone : une branche en haut, deux sur les côtés, deux en bas resserrées vers le centre */
.recherche_opti-curseurs {
    position: relative;
    max-width: 1100px;
    margin: 0 auto;
    display: grid;
    grid-template-columns: 1fr 240px 1fr;
    grid-template-areas:
        '.  b1 . '
        'b2 go b3'
        'b4 go b5';
    row-gap: 1.4rem;
    column-gap: 1rem;
    align-items: center;
}
.recherche_opti-branche { width: 100%; max-width: 340px; }
.recherche_opti-branche.b1 { grid-area: b1; justify-self: center; width: 340px; max-width: 90vw; }
.recherche_opti-branche.b2 { grid-area: b2; justify-self: start; }
.recherche_opti-branche.b3 { grid-area: b3; justify-self: end; }
.recherche_opti-branche.b4 { grid-area: b4; justify-self: end; }
.recherche_opti-branche.b5 { grid-area: b5; justify-self: start; }

/* Auréole de fromage derrière le bouton central */
.recherche_opti-curseurs::before {
    content: '';
    position: absolute;
    left: 50%;
    top: 58%;
    width: 520px;
    height: 520px;
    transform: translate(-50%, -50%);
    border-radius: 50%;
    background: radial-gradient(circle, rgba(252, 235, 178, 0.75) 0%, rgba(252, 235, 178, 0.25) 45%,
                                rgba(252, 235, 178, 0) 70%);
    pointer-events: none;
    z-index: 0;
}
.recherche_opti-curseurs > * { position: relative; z-index: 1; }

/* Sur écran étroit : les curseurs les uns sous les autres, le bouton en dessous */
@media (max-width: 900px) {
    .recherche_opti-curseurs {
        grid-template-columns: 1fr;
        grid-template-areas: 'b1' 'b2' 'b3' 'b4' 'b5' 'go';
        row-gap: 2rem;
        max-width: 420px;
    }
    .recherche_opti-branche.b1, .recherche_opti-branche.b2, .recherche_opti-branche.b3,
    .recherche_opti-branche.b4, .recherche_opti-branche.b5 { justify-self: center; }
    .recherche_opti-curseurs::before { display: none; }
}

.recherche_opti-slider-titre {
    font-weight: 600;
    margin-bottom: 0.6rem;
    text-align: center;
}

/* La piste = la longueur maximale possible (note 10).
   Marge du haut : laisse la place à la pastille de valeur (voir plus bas), qui déborde au-dessus. */
.recherche_opti-slider-piste {
    position: relative;
    height: 60px;
    width: 100%;
    max-width: 320px;
    margin: 28px auto 0;
    cursor: pointer;
    touch-action: none;
}
.recherche_opti-slider-piste:focus-visible {
    outline: 3px dashed var(--recherche_opti-orange-fonce);
    outline-offset: 6px;
    border-radius: 20px;
}

/* Silhouette fantôme de la piste entière */
.recherche_opti-slider-trace {
    position: absolute;
    inset: 0;
    background: url('accueil_stick.png') center / 100% 100% no-repeat;
    opacity: 0.18;
}

/* Le bâtonnet réellement affiché : sa largeur (en px, posée en JS) = la note */
.recherche_opti-slider-stick {
    position: absolute;
    left: 0;
    top: 0;
    height: 100%;
    width: 50%; /* valeur de repli, recalculée en JS dès que la piste est visible */
    overflow: hidden;
    filter: drop-shadow(0 6px 6px rgba(120, 60, 10, 0.25));
}
/* L'image, elle, garde toujours la largeur totale de la piste (posée en JS) :
   c'est le conteneur .recherche_opti-slider-stick qui la rogne en rétrécissant. */
.recherche_opti-slider-stick .image {
    position: absolute;
    left: 0;
    top: 0;
    height: 100%;
    background: url('accueil_stick.png') center / 100% 100% no-repeat;
}

/* Poignée posée sur la pointe du bâtonnet */
.recherche_opti-slider-poignee {
    position: absolute;
    top: 50%;
    left: 50%; /* recalculée en JS */
    width: 26px;
    height: 26px;
    margin: -13px 0 0 -13px;
    border-radius: 50%;
    background: var(--recherche_opti-orange-fonce);
    border: 3px solid #FFFFFF;
    box-shadow: 0 3px 8px rgba(120, 60, 10, 0.35);
    transition: transform 0.1s ease;
}
.recherche_opti-slider-poignee.en-glissement { transform: scale(1.18); }

/* Pastille de valeur, au-dessus de la poignée */
.recherche_opti-slider-valeur {
    position: absolute;
    top: -26px;
    left: 50%; /* recalculée en JS */
    transform: translateX(-50%);
    background: var(--recherche_opti-croute);
    color: #FFFFFF;
    font-size: 0.75rem;
    font-weight: 700;
    padding: 1px 7px;
    border-radius: 8px;
    white-space: nowrap;
}

.recherche_opti-slider-graduations {
    display: flex;
    justify-content: space-between;
    gap: 1rem;
    max-width: 320px;
    margin: 0.5rem auto 0;
    font-size: 0.8rem;
    color: var(--recherche_opti-croute);
}
.recherche_opti-slider-graduations span:last-child { text-align: right; }

/* Miettes qui tombent de la pointe coupée quand le bâtonnet rétrécit */
.recherche_opti-miette {
    position: absolute;
    top: 45%;
    z-index: 3;
    border-radius: 40%;
    pointer-events: none;
    animation: recherche_opti-chute 0.7s ease-in forwards;
}
@keyframes recherche_opti-chute {
    0%   { transform: translate(0, 0) rotate(0deg); opacity: 1; }
    100% { transform: translate(var(--dx), var(--dy)) rotate(var(--rot)); opacity: 0; }
}

/* ---------- Bouton « Votre produit parfait », au centre de l'étoile ---------- */
.recherche_opti-bas {
    grid-area: go;
    display: flex;
    justify-content: center;
    align-items: center;
}
.recherche_opti-go {
    width: 190px;
    height: 190px;
    font-family: inherit;
    font-size: 1.25rem;
    font-weight: 700;
    line-height: 1.2;
    color: #FFFFFF;
    padding: 0.8rem;
    border: none;
    border-radius: 50%;
    background: linear-gradient(135deg, var(--recherche_opti-orange) 0%, var(--recherche_opti-orange-fonce) 100%);
    box-shadow: 0 6px 0 var(--recherche_opti-croute), 0 10px 20px rgba(120, 60, 10, 0.30);
    transition: transform 0.12s ease, box-shadow 0.12s ease;
}
.recherche_opti-go:hover, .recherche_opti-go:focus {
    color: #FFFFFF;
    transform: translateY(-2px) scale(1.03);
}
.recherche_opti-go:active {
    transform: translateY(5px);
    box-shadow: 0 1px 0 var(--recherche_opti-croute), 0 4px 10px rgba(120, 60, 10, 0.30);
}

/* ---------- Pop-up : roulette 3D des 8 logos ---------- */
/* La pop-up est déplacée dans <body> par le JS : ses couleurs sont donc redéfinies ici */
.recherche_opti-overlay {
    --orange: #F8B063;
    --orange-fonce: #E8913A;
    --texte: #4A2C0F;
    --croute: #8B4A12;
    --fromage: #FCEBB2;
    --rayon: 200px;
    position: fixed;
    inset: 0;
    z-index: 3000;
    display: none;
    align-items: center;
    justify-content: center;
    overflow: hidden;
    background: radial-gradient(circle at center, rgba(74, 44, 15, 0.80) 0%, rgba(30, 15, 4, 0.94) 75%);
    backdrop-filter: blur(4px);
    font-family: 'Fredoka', 'Arial Rounded MT Bold', sans-serif;
    color: #FFFFFF;
}
.recherche_opti-overlay.ouvert { display: flex; }

.recherche_opti-scene {
    position: relative;
    width: 140px;
    height: 140px;
    perspective: 900px;
    transition: opacity 0.4s ease, transform 0.5s ease;
}
.recherche_opti-overlay.revele .recherche_opti-scene {
    opacity: 0;
    transform: scale(0.6);
}

/* Petite flèche au-dessus de la carte de devant, comme sur une roue de loterie */
.recherche_opti-fleche {
    position: absolute;
    left: 50%;
    top: -70px;
    width: 0;
    height: 0;
    margin-left: -16px;
    border-left: 16px solid transparent;
    border-right: 16px solid transparent;
    border-top: 26px solid var(--orange-fonce);
    filter: drop-shadow(0 3px 3px rgba(0, 0, 0, 0.5));
    z-index: 2;
}

.recherche_opti-anneau {
    position: absolute;
    inset: 0;
    transform-style: preserve-3d;
    transform: translateZ(calc(-1 * var(--rayon))) rotateX(-8deg);
}
.recherche_opti-carte {
    position: absolute;
    inset: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 16px;
    background: #FFFFFF;
    border: 4px solid var(--fromage);
    border-radius: 22px;
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.45);
    transition: border-color 0.1s ease;
}
.recherche_opti-carte img {
    max-width: 100%;
    max-height: 100%;
    object-fit: contain;
}
.recherche_opti-carte.devant { border-color: var(--orange-fonce); }

/* ---------- Le résultat : logo gagnant sur une explosion en papier ---------- */
.recherche_opti-resultat {
    position: absolute;
    inset: 0;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    pointer-events: none;
    opacity: 0;
}
.recherche_opti-overlay.revele .recherche_opti-resultat {
    opacity: 1;
    pointer-events: auto;
}

.recherche_opti-boum {
    position: relative;
    width: 380px;
    height: 380px;
    max-width: 90vw;
    max-height: 90vw;
    display: flex;
    align-items: center;
    justify-content: center;
}
/* Rayons de lumière qui tournent derrière l'explosion */
.recherche_opti-rayons {
    position: absolute;
    inset: -60%;
    background: repeating-conic-gradient(rgba(252, 235, 178, 0.22) 0deg 9deg, transparent 9deg 22deg);
    -webkit-mask-image: radial-gradient(circle, #000 15%, transparent 65%);
    mask-image: radial-gradient(circle, #000 15%, transparent 65%);
    animation: recherche_opti-tourne 14s linear infinite;
    opacity: 0;
}
.recherche_opti-explosion {
    position: absolute;
    inset: 0;
    width: 100%;
    height: 100%;
    overflow: visible;
    filter: drop-shadow(0 12px 18px rgba(0, 0, 0, 0.5));
    transform: scale(0);
}
.recherche_opti-gagnant-carte {
    position: relative;
    width: 150px;
    height: 150px;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 18px;
    background: #FFFFFF;
    border: 5px solid var(--texte);
    border-radius: 26px;
    box-shadow: 0 8px 0 var(--texte);
    transform: scale(0);
}
.recherche_opti-gagnant-carte img {
    max-width: 100%;
    max-height: 100%;
    object-fit: contain;
}
.recherche_opti-overlay.revele .recherche_opti-rayons {
    animation: recherche_opti-tourne 14s linear infinite, recherche_opti-apparait 0.6s 0.3s ease forwards;
}
.recherche_opti-overlay.revele .recherche_opti-explosion {
    animation: recherche_opti-pop 0.6s cubic-bezier(0.2, 1.6, 0.4, 1) forwards,
               recherche_opti-respire 2.4s 0.6s ease-in-out infinite;
}
.recherche_opti-overlay.revele .recherche_opti-gagnant-carte {
    animation: recherche_opti-pop-carte 0.7s 0.15s cubic-bezier(0.2, 1.8, 0.4, 1) forwards;
}

.recherche_opti-titre-resultat {
    margin: 0.6rem 0 0;
    font-size: 1.1rem;
    font-weight: 600;
    letter-spacing: 0.12em;
    text-transform: uppercase;
    color: var(--fromage);
}
.recherche_opti-nom-gagnant {
    margin: 0;
    font-size: 2.6rem;
    font-weight: 700;
    color: #FFFFFF;
    text-shadow: 0 3px 0 var(--orange-fonce), 0 6px 14px rgba(0, 0, 0, 0.5);
}
/* Les deux boutons sous le nom du gagnant */
.recherche_opti-actions {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    gap: 0.8rem;
    margin: 0.6rem 0 0.9rem;
}
.recherche_opti-action {
    position: relative;
    font-family: inherit;
    font-size: 1.05rem;
    font-weight: 700;
    color: #FFFFFF;
    padding: 0.6rem 1.5rem;
    border: none;
    border-radius: 999px;
    background: linear-gradient(135deg, var(--orange) 0%, var(--orange-fonce) 100%);
    box-shadow: 0 5px 0 var(--croute), 0 8px 16px rgba(0, 0, 0, 0.35);
    transition: transform 0.12s ease;
}
.recherche_opti-action:hover { transform: translateY(-2px) scale(1.04); }
.recherche_opti-action:active { transform: translateY(4px); box-shadow: 0 1px 0 var(--croute); }

.recherche_opti-titre-resultat, .recherche_opti-nom-gagnant,
.recherche_opti-actions, .recherche_opti-fermer { opacity: 0; }
.recherche_opti-overlay.revele .recherche_opti-titre-resultat,
.recherche_opti-overlay.revele .recherche_opti-nom-gagnant,
.recherche_opti-overlay.revele .recherche_opti-actions,
.recherche_opti-overlay.revele .recherche_opti-fermer {
    animation: recherche_opti-monte 0.5s 0.55s ease forwards;
}
.recherche_opti-fermer {
    font-family: inherit;
    font-weight: 600;
    color: var(--texte);
    background: var(--fromage);
    border: none;
    border-radius: 999px;
    padding: 0.45rem 1.6rem;
    box-shadow: 0 4px 0 var(--croute);
}
.recherche_opti-fermer:hover { background: #FFFFFF; }

/* ---------- Panneaux « Voir pourquoi ? » (ACP) et « magasin le plus proche » (carte) ---------- */
.recherche_opti-overlay.pourquoi .recherche_opti-resultat,
.recherche_opti-overlay.magasin .recherche_opti-resultat {
    opacity: 0;
    pointer-events: none;
    transform: scale(0.9);
    transition: opacity 0.3s ease, transform 0.3s ease;
}
.recherche_opti-panneau {
    position: absolute;
    inset: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 16px;
    opacity: 0;
    pointer-events: none;
    transform: translateY(40px);
    transition: opacity 0.35s ease, transform 0.35s ease;
}
.recherche_opti-overlay.pourquoi .recherche_opti-pourquoi,
.recherche_opti-overlay.magasin .recherche_opti-magasin {
    opacity: 1;
    pointer-events: auto;
    transform: translateY(0);
}
.recherche_opti-carte-panneau {
    width: min(920px, 100%);
    max-height: 100%;
    overflow-y: auto;
    padding: 1.2rem 1.4rem 1rem;
    background: #FFF6EC;
    color: var(--texte);
    border: 5px solid var(--texte);
    border-radius: 26px;
    box-shadow: 0 10px 0 var(--texte), 0 20px 40px rgba(0, 0, 0, 0.5);
}
.recherche_opti-panneau-entete {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 1rem;
    margin-bottom: 0.4rem;
}
.recherche_opti-panneau-entete h3 {
    margin: 0;
    font-weight: 700;
    color: var(--orange-fonce);
}
.recherche_opti-retour, .recherche_opti-ok {
    flex-shrink: 0;
    font-family: inherit;
    font-weight: 600;
    color: var(--texte);
    background: var(--fromage);
    border: none;
    border-radius: 999px;
    padding: 0.35rem 1.1rem;
    box-shadow: 0 3px 0 var(--croute);
}
.recherche_opti-retour:hover, .recherche_opti-ok:hover { background: var(--orange); color: #FFFFFF; }
.recherche_opti-acp-intro {
    margin: 0 0 0.6rem;
    color: var(--croute);
}
/* Mode d'emploi du graphique : 3 pastilles colorées */
.recherche_opti-lecture {
    display: flex;
    flex-wrap: wrap;
    gap: 0.6rem 1.4rem;
    justify-content: center;
    margin: 0.6rem 0 0;
    padding: 0;
    list-style: none;
    font-size: 0.92rem;
}
.recherche_opti-lecture li { display: flex; align-items: center; gap: 0.45rem; }
.recherche_opti-pastille {
    flex-shrink: 0;
    width: 14px;
    height: 14px;
    border-radius: 50%;
}

/* Carte + encart d'informations côte à côte (l'un sous l'autre sur téléphone) */
.recherche_opti-magasin-grille {
    display: grid;
    grid-template-columns: minmax(0, 1.7fr) minmax(220px, 1fr);
    gap: 1.1rem;
    align-items: stretch;
}
.recherche_opti-carte-cadre {
    border: 4px solid var(--texte);
    border-radius: 18px;
    overflow: hidden;
    min-height: 440px;
}
.recherche_opti-carte-cadre .leaflet-container { font-family: inherit; }
.recherche_opti-infos {
    display: flex;
    flex-direction: column;
    gap: 0.6rem;
    text-align: center;
}
.recherche_opti-infos-logo {
    width: 140px;
    height: 70px;
    margin: 0 auto;
    padding: 8px 12px;
    background: #FFFFFF;
    border: 3px solid var(--orange-fonce);
    border-radius: 14px;
}
.recherche_opti-infos-logo img { width: 100%; height: 100%; object-fit: contain; }
.recherche_opti-infos h4 { margin: 0.2rem 0 0; font-weight: 700; color: var(--texte); }
.recherche_opti-infos-adresse { margin: 0; color: var(--croute); font-size: 0.95rem; }
.recherche_opti-infos-statut { margin: 0.6rem 0; color: var(--croute); font-weight: 600; }
.recherche_opti-infos-chiffres {
    display: flex;
    justify-content: center;
    gap: 0.8rem;
    margin: 0.3rem 0;
}
.recherche_opti-infos-chiffres > div {
    flex: 1;
    display: flex;
    flex-direction: column;
    padding: 0.5rem 0.4rem;
    background: var(--fromage);
    border-radius: 14px;
}
.recherche_opti-infos-chiffres .valeur { font-size: 1.5rem; font-weight: 700; color: var(--orange-fonce); }
.recherche_opti-infos-chiffres .unite { font-size: 0.8rem; color: var(--croute); }
.recherche_opti-lien-gmaps {
    display: inline-block;
    align-self: center;
    text-decoration: none;
}
.recherche_opti-lien-gmaps:hover { color: #FFFFFF; }
.recherche_opti-ville {
    margin-top: auto;
    padding-top: 0.6rem;
    border-top: 2px dashed #F3E3D0;
    text-align: left;
}
.recherche_opti-ville .form-group { margin-bottom: 0.4rem; width: 100%; }
.recherche_opti-ville label { font-size: 0.9rem; color: var(--croute); }
.recherche_opti-ville .ligne { display: flex; gap: 0.5rem; align-items: flex-end; }
.recherche_opti-ville .ligne .form-group { flex: 1; margin: 0; }
.recherche_opti-mention { margin: 0.7rem 0 0; font-size: 0.75rem; color: var(--croute); opacity: 0.8; }

/* Marqueurs de la carte : le mozzastick de l'utilisateur et le logo du magasin sur une carte blanche */
.recherche_opti-pin-moi { filter: drop-shadow(0 3px 4px rgba(0, 0, 0, 0.45)); }
.recherche_opti-pin-magasin {
    padding: 3px 6px;
    background: #FFFFFF;
    border: 3px solid var(--orange-fonce);
    border-radius: 10px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.35);
    box-sizing: content-box;
}

@media (max-width: 768px) {
    .recherche_opti-magasin-grille { grid-template-columns: 1fr; }
    .recherche_opti-carte-cadre { min-height: 300px; }
}

/* Confettis en papier projetés par l'explosion */
.recherche_opti-confetti {
    position: absolute;
    left: 50%;
    top: 45%;
    pointer-events: none;
    animation: recherche_opti-confetti var(--duree) cubic-bezier(0.1, 0.8, 0.3, 1) forwards;
}

@keyframes recherche_opti-tourne    { to { transform: rotate(360deg); } }
@keyframes recherche_opti-apparait  { to { opacity: 1; } }
@keyframes recherche_opti-pop {
    0%   { transform: scale(0) rotate(-40deg); }
    100% { transform: scale(1) rotate(0deg); }
}
@keyframes recherche_opti-respire {
    0%, 100% { transform: scale(1) rotate(0deg); }
    50%      { transform: scale(1.05) rotate(3deg); }
}
@keyframes recherche_opti-pop-carte {
    0%   { transform: scale(0) rotate(20deg); }
    100% { transform: scale(1) rotate(-4deg); }
}
@keyframes recherche_opti-monte {
    from { opacity: 0; transform: translateY(14px); }
    to   { opacity: 1; transform: translateY(0); }
}
@keyframes recherche_opti-confetti {
    0%   { transform: translate(-50%, -50%) rotate(0deg) rotateX(0deg); opacity: 1; }
    80%  { opacity: 1; }
    100% { transform: translate(calc(-50% + var(--dx)), calc(-50% + var(--dy))) rotate(var(--rot)) rotateX(720deg); opacity: 0; }
}

@media (max-width: 576px) {
    .recherche_opti-overlay { --rayon: 140px; }
    .recherche_opti-scene { width: 100px; height: 100px; }
    .recherche_opti-nom-gagnant { font-size: 2rem; }
}
"

# --------------------------------------------------------------------------------------------------
# JavaScript : glisser la poignée fait grossir / rétrécir le bâtonnet, avec des miettes qui tombent
# de la pointe coupée quand il rétrécit. Chaque curseur envoie sa note (0-10) dans
# Shiny.setInputValue(id, valeur), id étant posé dans l'attribut data-input du conteneur R.
# --------------------------------------------------------------------------------------------------
recherche_opti_js <- "
$(function() {
    function hasard(min, max) { return min + Math.random() * (max - min); }

    // Une miette = un petit éclat coloré qui tombe et tourne, à l'endroit où la pointe a été coupée
    function lacherMiette(piste, x) {
        var couleurs = ['#8B4A12', '#B8661E', '#E8913A', '#FCD99A'];
        var m = document.createElement('span');
        var taille = hasard(3, 7);
        m.className = 'recherche_opti-miette';
        m.style.left = x + 'px';
        m.style.width = taille + 'px';
        m.style.height = taille * hasard(0.6, 1) + 'px';
        m.style.background = couleurs[Math.floor(Math.random() * couleurs.length)];
        m.style.setProperty('--dx', hasard(-18, 18) + 'px');
        m.style.setProperty('--dy', hasard(20, 45) + 'px');
        m.style.setProperty('--rot', hasard(-260, 260) + 'deg');
        m.addEventListener('animationend', function() { m.remove(); });
        piste.appendChild(m);
    }

    // Repositionne le bâtonnet, la poignée et la pastille selon la note (0-10).
    // Ne fait rien si la piste est cachée (onglet pas encore affiché) : sa largeur vaudrait 0.
    function dessiner(slider, valeur) {
        var piste = slider.querySelector('.recherche_opti-slider-piste');
        var rect = piste.getBoundingClientRect();
        if (!rect.width) return;

        var largeurPx = valeur / 10 * rect.width;
        var stick = slider.querySelector('.recherche_opti-slider-stick');
        stick.querySelector('.image').style.width = rect.width + 'px';
        stick.style.width = largeurPx + 'px';

        slider.querySelector('.recherche_opti-slider-poignee').style.left = largeurPx + 'px';
        var pastille = slider.querySelector('.recherche_opti-slider-valeur');
        pastille.style.left = largeurPx + 'px';
        pastille.textContent = valeur + ' / 10';

        piste.setAttribute('aria-valuenow', valeur);
    }

    function redessinerToutes() {
        $('.recherche_opti-slider').each(function() {
            dessiner(this, parseInt(this.dataset.valeur, 10));
        });
    }

    // Applique une nouvelle note : redessine, lâche des miettes si le bâtonnet a rétréci,
    // et prévient Shiny seulement si la note (arrondie) a changé.
    function appliquer(slider, valeurBrute, avecMiettes) {
        var ancienne = parseInt(slider.dataset.valeur, 10);
        var valeur = Math.max(0, Math.min(10, Math.round(valeurBrute)));

        if (avecMiettes && valeur < ancienne) {
            var piste = slider.querySelector('.recherche_opti-slider-piste');
            var rect = piste.getBoundingClientRect();
            for (var v = ancienne; v > valeur; v--) {
                if (Math.random() < 0.8) lacherMiette(piste, v / 10 * rect.width);
            }
        }

        dessiner(slider, valeur);

        if (valeur !== ancienne) {
            slider.dataset.valeur = valeur;
            Shiny.setInputValue(slider.dataset.input, valeur, {priority: 'event'});
        }
    }

    function valeurDepuisX(piste, clientX) {
        var rect = piste.getBoundingClientRect();
        var x = Math.max(0, Math.min(rect.width, clientX - rect.left));
        return rect.width ? x / rect.width * 10 : 0;
    }

    var enCours = null; // le slider actuellement glissé à la souris / au doigt

    $(document).on('pointerdown', '.recherche_opti-slider-piste', function(e) {
        var piste = this;
        var slider = piste.closest('.recherche_opti-slider');
        enCours = slider;
        piste.setPointerCapture(e.pointerId);
        slider.querySelector('.recherche_opti-slider-poignee').classList.add('en-glissement');
        appliquer(slider, valeurDepuisX(piste, e.clientX), true);
    });

    $(document).on('pointermove', '.recherche_opti-slider-piste', function(e) {
        if (!enCours) return;
        appliquer(enCours, valeurDepuisX(this, e.clientX), true);
    });

    function relacher() {
        if (!enCours) return;
        enCours.querySelector('.recherche_opti-slider-poignee').classList.remove('en-glissement');
        enCours = null;
    }
    $(document).on('pointerup pointercancel', '.recherche_opti-slider-piste', relacher);

    // Clavier : flèches gauche/droite (ou haut/bas) une fois la piste au focus
    $(document).on('keydown', '.recherche_opti-slider-piste', function(e) {
        var slider = this.closest('.recherche_opti-slider');
        var valeur = parseInt(slider.dataset.valeur, 10);
        if (e.key === 'ArrowRight' || e.key === 'ArrowUp') { appliquer(slider, valeur + 1, true); e.preventDefault(); }
        if (e.key === 'ArrowLeft'  || e.key === 'ArrowDown') { appliquer(slider, valeur - 1, true); e.preventDefault(); }
    });

    // Note initiale envoyée à Shiny dès la connexion (sans attendre un geste de l'utilisateur),
    // puis on redessine à chaque fois que la piste devient visible ou que la fenêtre change de taille.
    $(document).on('shiny:connected', function() {
        $('.recherche_opti-slider').each(function() {
            Shiny.setInputValue(this.dataset.input, parseInt(this.dataset.valeur, 10), {priority: 'event'});
        });
        redessinerToutes();
    });
    $(document).on('shown.bs.tab', redessinerToutes);
    $(window).on('resize', redessinerToutes);

    // ----------------------------------------------------------------------------------------------
    // Pop-up « Votre produit parfait » : la roulette 3D tourne de plus en plus vite, ralentit,
    // s'arrête sur le gagnant envoyé par le server, puis le logo explose sur une étoile en papier.
    // ----------------------------------------------------------------------------------------------
    var overlay = document.getElementById('recherche_opti-overlay');
    document.body.appendChild(overlay); // hors de l'onglet, pour couvrir toute la page
    var anneau = overlay.querySelector('.recherche_opti-anneau');
    var cartes = overlay.querySelectorAll('.recherche_opti-carte');
    var animation = null;

    function fermer() {
        if (animation) cancelAnimationFrame(animation);
        overlay.classList.remove('ouvert', 'revele', 'pourquoi', 'magasin');
        overlay.setAttribute('aria-hidden', 'true');
        overlay.querySelectorAll('.recherche_opti-confetti').forEach(function(c) { c.remove(); });
        document.getElementById('recherche_opti_go').focus();
    }
    overlay.querySelector('.recherche_opti-fermer').addEventListener('click', fermer);

    // Ouvre un panneau (« pourquoi » = ACP, « magasin » = carte) par-dessus le résultat.
    // Shiny ne dessine une sortie qu'une fois visible : l'événement 'shown' la prévient qu'elle
    // vient d'apparaître, et 'resize' (après l'animation) recale la carte à la bonne taille.
    var boutonOrigine = null;
    function ouvrirPanneau(nom, idSortie, bouton) {
        boutonOrigine = bouton;
        overlay.classList.add(nom);
        $('#' + idSortie).trigger('shown');
        setTimeout(function() { $(window).trigger('resize'); }, 400);
        overlay.querySelector('.recherche_opti-' + nom + ' .recherche_opti-retour').focus();
    }
    function fermerPanneau() {
        overlay.classList.remove('pourquoi', 'magasin');
        if (boutonOrigine) boutonOrigine.focus();
    }
    overlay.querySelectorAll('.recherche_opti-retour').forEach(function(b) {
        b.addEventListener('click', fermerPanneau);
    });

    overlay.querySelector('.recherche_opti-voir-pourquoi').addEventListener('click', function() {
        ouvrirPanneau('pourquoi', 'recherche_opti_acp', this);
    });

    // « Voir le magasin le plus proche » : on demande la position au navigateur (l'utilisateur doit
    // accepter) et on l'envoie au server, qui cherche le magasin et l'itinéraire.
    overlay.querySelector('.recherche_opti-voir-magasin').addEventListener('click', function() {
        ouvrirPanneau('magasin', 'recherche_opti_carte', this);
        function refus() { Shiny.setInputValue('recherche_opti_position_refus', Date.now(), {priority: 'event'}); }
        if (!navigator.geolocation) { refus(); return; }
        navigator.geolocation.getCurrentPosition(function(pos) {
            Shiny.setInputValue('recherche_opti_position',
                {lat: pos.coords.latitude, lon: pos.coords.longitude}, {priority: 'event'});
        }, refus, {timeout: 10000, maximumAge: 600000});
    });
    // Entrée dans le champ ville = clic sur OK. Shiny attend 250 ms avant d'envoyer un texte tapé :
    // on envoie la ville tout de suite pour que le server l'ait déjà au moment du clic.
    $(document).on('keydown', '#recherche_opti_ville', function(e) {
        if (e.key !== 'Enter') return;
        e.preventDefault();
        Shiny.setInputValue('recherche_opti_ville', this.value);
        $('#recherche_opti_ville_go').click();
    });

    $(document).on('keydown', function(e) {
        if (e.key !== 'Escape' || !overlay.classList.contains('ouvert')) return;
        // Échap ramène d'abord d'un panneau vers le résultat, puis ferme la pop-up
        if (overlay.classList.contains('pourquoi') || overlay.classList.contains('magasin')) fermerPanneau();
        else fermer();
    });

    // Confettis en papier projetés depuis le centre
    function lancerConfettis() {
        var couleurs = ['#FCEBB2', '#F8B063', '#E8913A', '#FFFFFF', '#8B4A12', '#FFD54F'];
        var zone = overlay.querySelector('.recherche_opti-resultat');
        for (var i = 0; i < 70; i++) {
            var c = document.createElement('span');
            var angle = hasard(0, 2 * Math.PI);
            var distance = hasard(160, Math.max(window.innerWidth, window.innerHeight) * 0.6);
            c.className = 'recherche_opti-confetti';
            c.style.width = hasard(6, 14) + 'px';
            c.style.height = hasard(10, 22) + 'px';
            c.style.background = couleurs[Math.floor(Math.random() * couleurs.length)];
            c.style.setProperty('--dx', Math.cos(angle) * distance + 'px');
            c.style.setProperty('--dy', Math.sin(angle) * distance + hasard(40, 140) + 'px');
            c.style.setProperty('--rot', hasard(-720, 720) + 'deg');
            c.style.setProperty('--duree', hasard(1.4, 2.6) + 's');
            c.addEventListener('animationend', function() { this.remove(); });
            zone.appendChild(c);
        }
    }

    function tourner(indexGagnant, apresArret) {
        var pas = 360 / cartes.length;
        var moinsDeMouvement = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
        var duree = moinsDeMouvement ? 1200 : 6500;
        var total = 360 * (moinsDeMouvement ? 1 : 7) + indexGagnant * pas;
        var a = 0.6; // 60 % du temps à accélérer, 40 % à freiner
        var debut = null, anglePrec = 0, tempsPrec = 0;

        // Angle parcouru à l'instant t (0-1) : accélération en t^3 puis freinage symétrique,
        // raccordés à la même vitesse en t = a pour que la roulette ne saccade pas.
        function angleA(t) {
            if (t < a) return total * a * Math.pow(t / a, 3);
            return total * a + total * (1 - a) * (1 - Math.pow(1 - (t - a) / (1 - a), 3));
        }

        function image(maintenant) {
            if (debut === null) { debut = maintenant; tempsPrec = maintenant; }
            var t = Math.min(1, (maintenant - debut) / duree);
            var angle = angleA(t);

            // Flou de vitesse : plus ça tourne vite, plus c'est flou
            var vitesse = (angle - anglePrec) / Math.max(1, maintenant - tempsPrec); // degrés / ms
            anglePrec = angle; tempsPrec = maintenant;
            anneau.style.transform = 'translateZ(calc(-1 * var(--rayon))) rotateX(-8deg) rotateY(' + (-angle) + 'deg)';
            // (posé sur chaque carte : un filtre sur l'anneau lui-même aplatirait la 3D)
            var flou = 'blur(' + Math.min(4, vitesse * 1.5).toFixed(2) + 'px)';
            var devant = Math.round(angle / pas) % cartes.length;
            cartes.forEach(function(c, i) {
                c.style.filter = t < 1 ? flou : 'none';
                c.classList.toggle('devant', i === devant);
            });

            if (t < 1) { animation = requestAnimationFrame(image); }
            else { setTimeout(apresArret, 500); }
        }
        animation = requestAnimationFrame(image);
    }

    Shiny.addCustomMessageHandler('recherche_opti_roulette', function(msg) {
        var index = 0;
        cartes.forEach(function(c, i) { if (c.dataset.magasin === msg.magasin) index = i; });

        overlay.querySelector('.recherche_opti-gagnant-carte img').src = 'logos/' + msg.magasin + '.png';
        overlay.querySelector('.recherche_opti-gagnant-carte img').alt = msg.nom;
        overlay.querySelector('.recherche_opti-nom-gagnant').textContent = msg.nom;
        overlay.querySelectorAll('.recherche_opti-acp-nom').forEach(function(n) { n.textContent = msg.nom; });

        overlay.classList.remove('revele', 'pourquoi', 'magasin');
        overlay.classList.add('ouvert');
        overlay.setAttribute('aria-hidden', 'false');
        tourner(index, function() {
            overlay.classList.add('revele');
            lancerConfettis();
            overlay.querySelector('.recherche_opti-fermer').focus();
        });
    });
});
"

# --------------------------------------------------------------------------------------------------
# Explosion en papier derrière le logo gagnant : des étoiles à pointes irrégulières, empilées,
# aux bords froissés par un filtre SVG (bruit + déformation)
# --------------------------------------------------------------------------------------------------
recherche_opti_etoile <- function(nb_pointes, r_ext, r_int, decalage = 0) {
    k <- seq_len(2 * nb_pointes) - 1
    angle <- k * pi / nb_pointes + decalage
    # rayon irrégulier mais toujours identique (pas de hasard, pour ne pas toucher au set.seed)
    r <- ifelse(k %% 2 == 0, r_ext * (1 + 0.16 * sin(k * 2.7)), r_int * (1 + 0.10 * cos(k * 1.9)))
    paste(sprintf("%.1f,%.1f", r * cos(angle), r * sin(angle)), collapse = " ")
}

recherche_opti_explosion_svg <- HTML(sprintf(
    "<svg class='recherche_opti-explosion' viewBox='-200 -200 400 400' aria-hidden='true'>
        <defs>
            <filter id='recherche_opti-papier' x='-20%%' y='-20%%' width='140%%' height='140%%'>
                <feTurbulence type='fractalNoise' baseFrequency='0.035' numOctaves='2' seed='4' result='bruit'/>
                <feDisplacementMap in='SourceGraphic' in2='bruit' scale='9'/>
            </filter>
        </defs>
        <g filter='url(#recherche_opti-papier)' stroke='#4A2C0F' stroke-width='4' stroke-linejoin='round'>
            <polygon points='%s' fill='#E8913A'/>
            <polygon points='%s' fill='#F8B063'/>
            <polygon points='%s' fill='#FCEBB2'/>
        </g>
    </svg>",
    recherche_opti_etoile(16, 190, 120),
    recherche_opti_etoile(13, 150, 100, 0.2),
    recherche_opti_etoile(11, 118, 88, 0.5)
))

# La pop-up : la roulette des 8 logos (un par magasin, régulièrement répartis sur un cercle 3D)
# puis le résultat, caché tant que la roulette tourne
recherche_opti_popup <- function() {
    n <- length(magasins_noms)
    div(
        id = "recherche_opti-overlay",
        class = "recherche_opti-overlay",
        role = "dialog",
        `aria-modal` = "true",
        `aria-label` = "Votre produit parfait",
        `aria-hidden` = "true",
        div(
            class = "recherche_opti-scene",
            div(class = "recherche_opti-fleche"),
            div(
                class = "recherche_opti-anneau",
                lapply(seq_len(n), function(i) {
                    m <- names(magasins_noms)[i]
                    div(
                        class = "recherche_opti-carte",
                        `data-magasin` = m,
                        style = sprintf("transform: rotateY(%gdeg) translateZ(var(--rayon));",
                                        (i - 1) * 360 / n),
                        img(src = paste0("logos/", m, ".png"), alt = magasins_noms[[m]])
                    )
                })
            )
        ),
        div(
            class = "recherche_opti-resultat",
            div(
                class = "recherche_opti-boum",
                div(class = "recherche_opti-rayons"),
                recherche_opti_explosion_svg,
                div(class = "recherche_opti-gagnant-carte", img(src = "", alt = ""))
            ),
            p(class = "recherche_opti-titre-resultat", "✨ Votre produit parfait ✨"),
            p(class = "recherche_opti-nom-gagnant"),
            div(
                class = "recherche_opti-actions",
                tags$button(type = "button", class = "recherche_opti-action recherche_opti-voir-pourquoi",
                            "🔍 Voir pourquoi ?"),
                tags$button(type = "button", class = "recherche_opti-action recherche_opti-voir-magasin",
                            "📍 Voir le magasin le plus proche")
            ),
            tags$button(type = "button", class = "recherche_opti-fermer", "Fermer")
        ),
        # Panneau « Voir pourquoi ? » : illustration visuelle par ACP
        # (le choix du produit, lui, reste la plus petite somme des |écarts|)
        div(
            class = "recherche_opti-panneau recherche_opti-pourquoi",
            div(
                class = "recherche_opti-carte-panneau",
                div(
                    class = "recherche_opti-panneau-entete",
                    h3("Pourquoi ", span(class = "recherche_opti-acp-nom"), " ?"),
                    tags$button(type = "button", class = "recherche_opti-retour", "← Retour")
                ),
                p(class = "recherche_opti-acp-intro",
                  "Cette ACP place les 8 produits et votre produit idéal sur une même carte, à partir
                   des 5 descripteurs : deux produits proches sur la carte ont des profils proches."),
                plotOutput("recherche_opti_acp", height = "520px"),
                tags$ul(
                    class = "recherche_opti-lecture",
                    tags$li(span(class = "recherche_opti-pastille", style = "background:#E8913A"),
                            "Le mozzastick : votre produit idéal"),
                    tags$li(span(class = "recherche_opti-pastille",
                                 style = "background:#FFFFFF; border:3px solid #E8913A"),
                            "Contour orange : votre produit parfait"),
                    tags$li(span(class = "recherche_opti-pastille", style = "background:#8B4A12"),
                            "Flèches : un produit placé vers une flèche est fort sur ce descripteur")
                )
            )
        ),
        # Panneau « Voir le magasin le plus proche » : carte Leaflet + encart d'informations
        div(
            class = "recherche_opti-panneau recherche_opti-magasin",
            div(
                class = "recherche_opti-carte-panneau",
                div(
                    class = "recherche_opti-panneau-entete",
                    h3("Votre ", span(class = "recherche_opti-acp-nom"), " le plus proche"),
                    tags$button(type = "button", class = "recherche_opti-retour", "← Retour")
                ),
                div(
                    class = "recherche_opti-magasin-grille",
                    div(class = "recherche_opti-carte-cadre",
                        leaflet::leafletOutput("recherche_opti_carte", height = "440px")),
                    div(
                        class = "recherche_opti-infos",
                        uiOutput("recherche_opti_magasin_infos"),
                        div(
                            class = "recherche_opti-ville",
                            div(
                                class = "ligne",
                                textInput("recherche_opti_ville", "Pas là où vous êtes ? Entrez une ville :",
                                          placeholder = "ex. Rennes"),
                                actionButton("recherche_opti_ville_go", "OK", class = "recherche_opti-ok")
                            )
                        )
                    )
                ),
                p(class = "recherche_opti-mention",
                  "Votre position sert uniquement à ce calcul (elle est transmise au service d'itinéraire OSRM).
                   Magasins : All the Places et © contributeurs OpenStreetMap.")
            )
        )
    )
}

# Un curseur mozzastick : id Shiny (data-input), note de départ (0-10) et libellés des deux bouts
recherche_opti_slider <- function(id, titre, txt_min, txt_max, valeur = 5) {
    div(
        class = "recherche_opti-slider",
        `data-input` = id,
        `data-valeur` = valeur,
        div(class = "recherche_opti-slider-titre", titre),
        div(
            class = "recherche_opti-slider-piste",
            tabindex = "0",
            role = "slider",
            `aria-valuemin` = "0",
            `aria-valuemax` = "10",
            `aria-valuenow` = valeur,
            `aria-label` = titre,
            div(class = "recherche_opti-slider-trace"),
            div(class = "recherche_opti-slider-stick", div(class = "image")),
            div(class = "recherche_opti-slider-poignee"),
            div(class = "recherche_opti-slider-valeur", paste0(valeur, " / 10"))
        ),
        div(
            class = "recherche_opti-slider-graduations",
            span(paste0("0 = ", txt_min)),
            span(paste0("10 = ", txt_max))
        )
    )
}

# Les 5 curseurs du jeu F (même ordre que recherche_opti_descripteurs dans le server)
recherche_opti_curseurs_config <- list(
    list(id = "recherche_opti_note_aspect_gras", titre = "Aspect gras (suintement)",
         min = "Sec, pas de suintement", max = "Très gras, ça coule"),
    list(id = "recherche_opti_note_mozzarella", titre = "Goût mozzarella",
         min = "Discret", max = "Prononcé"),
    list(id = "recherche_opti_note_rugosite", titre = "Rugosité visuelle",
         min = "Surface lisse", max = "Surface très rugueuse"),
    list(id = "recherche_opti_note_humidite", titre = "Fondant en bouche",
         min = "Sec en bouche", max = "Très fondant"),
    list(id = "recherche_opti_note_croustillant", titre = "Croustillant",
         min = "Mou", max = "Très croustillant")
)

onglet_recherche_opti <- nav_panel(
    title = "Recherche optimale",
    value = "recherche_opti",
    icon = icon("magnifying-glass"),

    tags$head(
        tags$link(
            rel = "stylesheet",
            href = "https://fonts.googleapis.com/css2?family=Fredoka:wght@400;600;700&display=swap"
        ),
        tags$style(HTML(recherche_opti_css)),
        tags$script(HTML(recherche_opti_js))
    ),

    div(
        class = "recherche_opti-page",

        # En-tête
        div(
            class = "recherche_opti-entete",
            nav_stick("analyse", "Analyse Factorielle", "gauche"),
            h2("Recherche optimale"),
            nav_stick("accueil", "Accueil", "droite")
        ),

        # Espace explicatif
        div(
            class = "recherche_opti-intro",
            h3("🧀 Un test croustillant vous attend"),
            p("Étirez chaque bâtonnet à la longueur qui vous ressemble : c'est votre mozzarella
               idéale, décrite en 5 curseurs. On ira ensuite chercher, miette après miette, lequel
               de nos 8 produits colle le plus à vos goûts.")
        ),

        # Les 5 curseurs mozzastick en étoile autour du bouton qui lance la roulette
        div(
            class = "recherche_opti-curseurs",
            lapply(seq_along(recherche_opti_curseurs_config), function(i) {
                cfg <- recherche_opti_curseurs_config[[i]]
                div(class = paste0("recherche_opti-branche b", i),
                    recherche_opti_slider(cfg$id, cfg$titre, cfg$min, cfg$max))
            }),
            div(
                class = "recherche_opti-bas",
                actionButton("recherche_opti_go", HTML("🏆<br>Votre produit<br>parfait"),
                             class = "recherche_opti-go")
            )
        ),

        recherche_opti_popup()
    )
)
