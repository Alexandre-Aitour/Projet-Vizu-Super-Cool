# ==================================================================================================
# Onglet : Accueil
# Préfixe des identifiants : accueil_
# ==================================================================================================

# --------------------------------------------------------------------------------------------------
# Style de l'accueil (limité aux classes accueil-* pour ne pas toucher les autres onglets)
# --------------------------------------------------------------------------------------------------
accueil_css <- "
.accueil-page {
    --accueil-orange: #F8B063;
    --accueil-orange-fonce: #E8913A;
    --accueil-creme: #FFF6EC;
    --accueil-texte: #4A2C0F;
    --accueil-peek: 64px;
    flex: 1;
    min-height: 100vh;
    background: var(--accueil-creme);
    display: flex;
    align-items: center;
    justify-content: center;
    padding-bottom: var(--accueil-peek);
    margin: -1rem;
}

/* ---------- Les 3 boutons mozzasticks au centre ---------- */
.accueil-boutons {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 2.5rem;
    padding: 1rem;
}

.accueil-stick {
    position: relative;
    width: 340px;
    max-width: 85vw;
    aspect-ratio: 555 / 151;
    padding: 0;
    border: none;
    background: none;
    cursor: pointer;
    filter: drop-shadow(0 10px 10px rgba(120, 60, 10, 0.30));
    transition: transform 0.2s ease, filter 0.2s ease;
}
.accueil-stick:hover {
    transform: translateY(-6px) rotate(-2deg);
    filter: drop-shadow(0 16px 14px rgba(120, 60, 10, 0.35));
}
.accueil-stick:focus-visible {
    outline: 3px dashed var(--accueil-orange-fonce);
    outline-offset: 8px;
    border-radius: 40px;
}

/* Les deux moitiés du bâtonnet : même image, découpée en dents de scie au milieu */
.accueil-stick .moitie {
    position: absolute;
    inset: 0;
    z-index: 1;
    transform-origin: 50% 50%;
    transition: transform 0.45s cubic-bezier(0.2, 0.9, 0.3, 1.3);
}
.accueil-stick .pane {
    position: absolute;
    inset: 0;
    background: url('accueil_stick.png') center / 100% 100% no-repeat;
}
.accueil-stick .gauche .pane {
    clip-path: polygon(0 0, 51% 0, 48% 22%, 53% 45%, 47% 68%, 52% 85%, 49% 100%, 0 100%);
}
.accueil-stick .droite .pane {
    clip-path: polygon(51% 0, 100% 0, 100% 100%, 49% 100%, 52% 85%, 47% 68%, 53% 45%, 48% 22%);
}

/* Face coupée : le coeur de mozzarella qui apparaît à la cassure */
.accueil-stick .coeur {
    position: absolute;
    top: 18%;
    height: 64%;
    width: 10px;
    filter: blur(0.6px);
    border-radius: 50%;
    background: radial-gradient(ellipse at 50% 40%, #FFFDF2 0%, #FBEBB5 60%, #E9C064 100%);
    box-shadow: inset 0 -3px 5px rgba(170, 110, 30, 0.35);
    opacity: 0;
    transition: opacity 0.15s ease 0.1s;
}
.accueil-stick .gauche .coeur { left: calc(50% - 10px); }
.accueil-stick .droite .coeur { left: calc(50% - 6px); }

/* Filament de fromage qui s'étire entre les deux moitiés */
.accueil-stick .fil {
    position: absolute;
    z-index: 0;
    left: 50%;
    top: 28%;
    height: 48%;
    width: 0;
    overflow: visible;
    transform: translateX(-50%);
    filter: drop-shadow(0 2px 2px rgba(150, 100, 30, 0.35));
    transition: width 0.55s cubic-bezier(0.3, 0.8, 0.4, 1) 0.08s;
}
.accueil-stick.coupe .fil {
    animation: accueil-fil-pend 0.9s ease-in-out 0.45s;
}
@keyframes accueil-fil-pend {
    0%, 100% { transform: translateX(-50%) translateY(0); }
    45%      { transform: translateX(-50%) translateY(3px); }
}

/* Titre en mozzarella fondue écrit sur le bâtonnet.
   Le contour doré et l'ombre sont posés sur le conteneur pour englober lettres + gouttes. */
.accueil-stick .accueil-libelle {
    position: absolute;
    inset: 0;
    z-index: 2;
    display: flex;
    align-items: center;
    justify-content: center;
    pointer-events: none;
    filter: drop-shadow(0 0 1px #B8761E) drop-shadow(0 1px 0 #B8761E)
            drop-shadow(0 3px 4px rgba(60, 30, 5, 0.6));
    transition: opacity 0.2s ease;
}
/* Le filtre gluant fait fusionner les gouttes avec le bas des lettres */
.accueil-stick .fromage {
    position: relative;
    display: inline-block;
    padding: 12px 6px 14px;
    font-family: 'Fredoka', 'Arial Rounded MT Bold', sans-serif;
    font-size: 1.7rem;
    font-weight: 700;
    line-height: 1;
    letter-spacing: 1px;
    white-space: nowrap;
    filter: url(#accueil-gluant);
}
.accueil-stick .fromage .texte {
    background: linear-gradient(to bottom, #FFFFFF 0%, #FFF9E4 35%, #FCEBB2 70%, #F3D27A 100%);
    -webkit-background-clip: text;
    background-clip: text;
    color: transparent;
}
.accueil-stick .goutte {
    position: absolute;
    top: 30px;
    width: 5px;
    height: var(--h);
    margin-left: -2.5px;
    border-radius: 0 0 3px 3px;
    background: #F4D57E;
    transform-origin: top center;
    animation: accueil-goutte 2.6s ease-in-out var(--d) infinite alternate;
}
.accueil-stick .goutte::after {
    content: '';
    position: absolute;
    left: 50%;
    bottom: -3px;
    width: 8px;
    height: 8px;
    margin-left: -4px;
    border-radius: 50%;
    background: #F2CF6E;
}
@keyframes accueil-goutte {
    from { transform: scaleY(0.55); }
    to   { transform: scaleY(1.15); }
}

/* État coupé (ajouté au clic) */
.accueil-stick.coupe .gauche { transform: translateX(-34px) rotate(-12deg); }
.accueil-stick.coupe .droite { transform: translateX(34px) rotate(12deg); }
.accueil-stick.coupe .coeur { opacity: 1; }
.accueil-stick.coupe .fil { width: 110px; }
.accueil-stick.coupe .accueil-libelle { opacity: 0; }

/* Éclats de chapelure au moment de la cassure */
.accueil-miette {
    position: absolute;
    left: 50%;
    top: 40%;
    z-index: 3;
    border-radius: 40%;
    pointer-events: none;
    animation: accueil-eclat 0.7s ease-out forwards;
}
@keyframes accueil-eclat {
    0%   { transform: translate(0, 0) rotate(0deg); opacity: 1; }
    100% { transform: translate(var(--dx), var(--dy)) rotate(var(--rot)); opacity: 0; }
}

/* ---------- Fenêtre à tirer vers le haut ---------- */
.accueil-tiroir {
    position: fixed;
    left: 0;
    right: 0;
    bottom: 0;
    height: 85vh;
    z-index: 1000;
    background: #FFFFFF;
    border-radius: 24px 24px 0 0;
    box-shadow: 0 -6px 24px rgba(0, 0, 0, 0.15);
    transform: translateY(calc(100% - var(--accueil-peek)));
    transition: transform 0.3s ease;
    display: flex;
    flex-direction: column;
}
.accueil-tiroir.ouvert { transform: translateY(0); }
.accueil-tiroir.en-glissement { transition: none; }

/* Poignée : le mozzastick coupé en deux, une moitié de chaque côté, reliées par un long filet
   de mozzarella (dessiné en JS) avec une pointe étirée vers le haut au milieu */
.accueil-poignee {
    position: relative;
    height: var(--accueil-peek);
    flex-shrink: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    padding-top: 14px;   /* le filet occupe le haut de la poignée : on centre le texte dessous */
    cursor: grab;
    touch-action: none;
    user-select: none;
    border-bottom: 1px solid #F3E3D0;
}
.accueil-tiroir.en-glissement .accueil-poignee { cursor: grabbing; }

.accueil-poignee .poignee-moitie {
    position: absolute;
    top: -38px;
    z-index: 2;
    width: 140px;
    height: 76px;
    background: url('accueil_stick.png') no-repeat;
    background-size: 280px 76px;
    transition: transform 0.2s ease;
}
.accueil-poignee .poignee-moitie.gauche {
    left: 16px;
    background-position: left center;
    clip-path: polygon(0 0, 100% 0, 95% 22%, 100% 45%, 93% 68%, 99% 85%, 96% 100%, 0 100%);
}
.accueil-poignee .poignee-moitie.droite {
    right: 16px;
    background-position: right center;
    clip-path: polygon(4% 0, 100% 0, 100% 100%, 1% 100%, 6% 85%, 0 68%, 7% 45%, 0 22%);
}
/* Face coupée : coeur de mozzarella */
.accueil-poignee .poignee-moitie::after {
    content: '';
    position: absolute;
    top: 18%;
    height: 64%;
    width: 10px;
    border-radius: 50%;
    background: radial-gradient(ellipse at 50% 40%, #FFFDF2 0%, #FBEBB5 60%, #E9C064 100%);
    filter: blur(0.6px);
}
.accueil-poignee .poignee-moitie.gauche::after { right: 3px; }
.accueil-poignee .poignee-moitie.droite::after { left: 3px; }
.accueil-tiroir.en-glissement .poignee-moitie.gauche { transform: rotate(-4deg); }
.accueil-tiroir.en-glissement .poignee-moitie.droite { transform: rotate(4deg); }

/* Le filet : seul le fromage attrape la souris, pas le rectangle vide du SVG */
.accueil-poignee .poignee-filet {
    position: absolute;
    left: 0;
    top: -90px;
    z-index: 1;
    width: 100%;
    height: 110px;
    overflow: visible;
    pointer-events: none;
    filter: drop-shadow(0 2px 2px rgba(150, 100, 30, 0.35));
}
.accueil-poignee .poignee-filet path.corps { pointer-events: visiblePainted; }
.accueil-poignee .libelle {
    display: flex;
    flex-direction: column;
    align-items: center;
    font-family: 'Fredoka', 'Arial Rounded MT Bold', sans-serif;
    font-size: 1.05rem;
    line-height: 1;
    font-weight: 600;
    letter-spacing: 0.5px;
    color: #8B4A12;
}
.accueil-poignee .libelle .fleche {
    font-size: 1.1rem;
    line-height: 0.6;
    color: var(--accueil-orange-fonce);
    animation: accueil-invite 1.6s ease-in-out infinite;
    transition: transform 0.3s ease;
}
@keyframes accueil-invite {
    0%, 100% { translate: 0 0; }
    50%      { translate: 0 -4px; }
}
.accueil-poignee .quand-ouvert { display: none; }
.accueil-tiroir.ouvert .accueil-poignee .quand-ouvert { display: inline; }
.accueil-tiroir.ouvert .accueil-poignee .quand-ferme { display: none; }
.accueil-tiroir.ouvert .accueil-poignee .fleche { transform: rotate(180deg); }

/* Miettes qui tombent de la poignée pendant qu'on la tire (texture prise dans la même image) */
.accueil-miette-tiroir {
    position: fixed;
    z-index: 1001;
    border-radius: 40%;
    pointer-events: none;
    background-image: url('accueil_stick.png');
    background-size: 280px auto;
    animation: accueil-chute cubic-bezier(0.5, 0, 1, 1) forwards;
}
@keyframes accueil-chute {
    0%   { transform: translate(0, 0) rotate(0deg); opacity: 1; }
    80%  { opacity: 1; }
    100% { transform: translate(var(--dx), var(--chute)) rotate(var(--rot)); opacity: 0; }
}

.accueil-contenu {
    overflow-y: auto;
    padding: 2rem 2rem 3rem;
    margin: 0 auto;
    width: 100%;
    max-width: 960px;
    color: var(--accueil-texte);
    font-family: 'Fredoka', 'Arial Rounded MT Bold', sans-serif;
}
.accueil-contenu h3 {
    margin: 2rem 0 0.9rem;
    font-size: 1.35rem;
    font-weight: 700;
    color: var(--accueil-orange-fonce);
}
.accueil-contenu h4 {
    margin: 0 0 0.4rem;
    font-size: 1.1rem;
    font-weight: 700;
}

/* La question du projet */
.accueil-question { text-align: center; max-width: 760px; margin: 0 auto; }
.accueil-surtitre {
    display: inline-block;
    padding: 0.15rem 0.8rem;
    border-radius: 999px;
    background: var(--accueil-creme);
    color: #8B4A12;
    font-size: 0.85rem;
    font-weight: 600;
    letter-spacing: 1px;
    text-transform: uppercase;
}
.accueil-question h2 {
    margin: 0.6rem 0 0.8rem;
    font-size: 1.7rem;
    font-weight: 700;
    line-height: 1.25;
    color: var(--accueil-orange-fonce);
}
.accueil-question p { font-size: 1.05rem; line-height: 1.55; margin: 0; }

/* Chiffres clés */
.accueil-chiffres {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    gap: 0.8rem;
    margin-top: 1.6rem;
}
.accueil-chiffre {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 0.8rem;
    border-radius: 16px;
    background: var(--accueil-creme);
    border: 1px solid #F3E3D0;
}
.accueil-chiffre strong { font-size: 2rem; line-height: 1.1; color: var(--accueil-orange-fonce); }
.accueil-chiffre span { font-size: 0.9rem; color: #8B4A12; }

/* Les deux jeux de données */
.accueil-donnees {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(340px, 1fr));
    gap: 1rem;
}
.accueil-carte {
    min-width: 0;
    padding: 1rem 1.1rem;
    border-radius: 18px;
    border: 1px solid #F3E3D0;
    box-shadow: 0 6px 18px rgba(120, 60, 10, 0.08);
    background: #FFFFFF;
}
.accueil-carte > p { font-size: 0.95rem; line-height: 1.45; }
.accueil-table-cadre { overflow-x: auto; border-radius: 10px; border: 1px solid #F3E3D0; }
.accueil-table { width: 100%; border-collapse: collapse; font-size: 0.85rem; }
.accueil-table th {
    padding: 0.4rem 0.55rem;
    background: var(--accueil-orange);
    color: #FFFFFF;
    font-weight: 600;
    white-space: nowrap;
    text-align: left;
}
.accueil-table td {
    padding: 0.35rem 0.55rem;
    border-top: 1px solid #F3E3D0;
    white-space: nowrap;
    font-variant-numeric: tabular-nums;
}
.accueil-table tbody tr:nth-child(even) td { background: var(--accueil-creme); }
.accueil-legende { margin: 0.45rem 0 0; font-size: 0.8rem !important; color: #8B4A12; }
.accueil-note { margin: 0.8rem 0 0; font-size: 0.85rem; font-style: italic; color: #8B4A12; }

/* Titres de section numérotés */
.accueil-section {
    display: flex;
    align-items: baseline;
    gap: 0.6rem;
}
.accueil-section .num {
    font-family: 'Pacifico', 'Brush Script MT', cursive;
    font-size: 1.5rem;
    font-weight: 400;
    color: var(--accueil-orange);
}

/* L'idée globale : deux sources réunies, puis le produit idéal */
.accueil-schema {
    display: grid;
    grid-template-columns: 1fr auto 1.1fr auto 1fr;
    align-items: center;
    gap: 0.7rem;
}
.accueil-schema .sources { display: flex; flex-direction: column; gap: 0.6rem; }
.accueil-bulle {
    padding: 0.7rem 0.9rem;
    border-radius: 16px;
    border: 1px solid #F3E3D0;
    background: #FFFFFF;
    font-size: 0.92rem;
    line-height: 1.35;
}
.accueil-bulle strong { display: block; font-size: 1rem; }
.accueil-bulle.centre { background: var(--accueil-creme); border-color: var(--accueil-orange); }
.accueil-bulle.fin {
    background: var(--accueil-orange-fonce);
    border-color: var(--accueil-orange-fonce);
    color: #FFFFFF;
}
.accueil-schema .lien { font-size: 1.5rem; color: var(--accueil-orange-fonce); text-align: center; }
@media (max-width: 720px) {
    .accueil-schema { grid-template-columns: 1fr; }
    .accueil-schema .lien { transform: rotate(90deg); }
}

/* Le parcours */
.accueil-etapes {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));
    gap: 1rem;
}
.accueil-etape {
    display: flex;
    flex-direction: column;
    gap: 0.35rem;
    padding: 1rem 1.1rem;
    text-align: left;
    font: inherit;
    color: inherit;
    border-radius: 18px;
    border: 1px solid #F3E3D0;
    background: linear-gradient(135deg, #FFFDF8 0%, #FFF4E3 100%);
    cursor: pointer;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.accueil-etape:hover { transform: translateY(-4px); box-shadow: 0 10px 20px rgba(120, 60, 10, 0.12); }
.accueil-etape:focus-visible { outline: 3px dashed var(--accueil-orange-fonce); outline-offset: 4px; }
.accueil-etape-num {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 2rem;
    height: 2rem;
    border-radius: 50%;
    background: var(--accueil-orange-fonce);
    color: #FFFFFF;
    font-weight: 700;
}
.accueil-etape strong { font-size: 1.1rem; }
.accueil-etape span { font-size: 0.92rem; line-height: 1.4; }
.accueil-etape .accueil-etape-lien { margin-top: auto; font-weight: 600; color: var(--accueil-orange-fonce); }

/* ---------- Titre de l'accueil, en haut au centre ---------- */
.accueil-page { position: relative; }
.accueil-titre {
    position: absolute;
    top: 1.5rem;
    left: 0;
    right: 0;
    margin: 0;
    padding: 0 1rem;
    text-align: center;
    font-family: 'Pacifico', 'Brush Script MT', cursive;
    font-size: clamp(2rem, 5.5vw, 3.4rem);
    font-weight: 400;
    line-height: 1.3;
    color: var(--accueil-orange-fonce);
    text-shadow: 0 2px 0 #FCEBB2, 0 5px 10px rgba(139, 74, 18, 0.22);
}

/* ---------- Mozzasticks de navigation autour du titre de chaque onglet ---------- */
.nav-stick {
    position: relative;
    height: 56px;
    aspect-ratio: 555 / 151;
    padding: 0;
    border: none;
    background: url('accueil_stick.png') center / 100% 100% no-repeat;
    cursor: pointer;
    filter: drop-shadow(0 6px 6px rgba(120, 60, 10, 0.30));
    transition: transform 0.2s ease, filter 0.2s ease;
}
.nav-stick.gauche { transform: rotate(-8deg); }
.nav-stick.droite { transform: rotate(8deg); }
.nav-stick.gauche:hover { transform: rotate(-8deg) translateX(-6px) scale(1.05); }
.nav-stick.droite:hover { transform: rotate(8deg) translateX(6px) scale(1.05); }
.nav-stick:hover { filter: drop-shadow(0 10px 10px rgba(120, 60, 10, 0.35)); }
.nav-stick:focus-visible {
    outline: 3px dashed #E8913A;
    outline-offset: 6px;
    border-radius: 30px;
}
.nav-stick .nav-stick-libelle {
    position: absolute;
    inset: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.35rem;
    padding: 0 12%;
    font-family: 'Fredoka', 'Arial Rounded MT Bold', sans-serif;
    font-size: 0.9rem;
    font-weight: 700;
    line-height: 1.05;
    color: #FFF9E4;
    text-shadow: 0 0 2px #8B4A12, 0 1px 0 #8B4A12, 0 2px 4px rgba(60, 30, 5, 0.6);
    pointer-events: none;
}
"

# --------------------------------------------------------------------------------------------------
# JavaScript : tiroir à glisser + coupure des mozzasticks avec bruit de crunch
# --------------------------------------------------------------------------------------------------
accueil_js <- "
// ---------- Glisser le tiroir à la souris (pas d'ouverture au simple clic) ----------
$(function() {
    var tiroir  = document.getElementById('accueil_tiroir');
    var poignee = document.getElementById('accueil_poignee');
    if (!tiroir || !poignee) return;

    var moities = poignee.querySelectorAll('.poignee-moitie');
    var filet   = poignee.querySelector('.poignee-filet');
    var corps   = filet.querySelector('.corps');
    var reflet  = filet.querySelector('.reflet');
    var debutY = null, decalageDepart = 0, decalage = 0, dernierY = 0, parcours = 0, etirement = 0;

    function decalageMax() {
        return tiroir.offsetHeight - poignee.offsetHeight;
    }

    function hasard(min, max) { return min + Math.random() * (max - min); }

    // Dessine le filet entre les deux faces coupées. y0 = bord haut de la fenêtre dans le SVG.
    // 'bonus' allonge la pointe du milieu (quand on tire).
    function dessinerFilet(bonus) {
        var W = poignee.clientWidth;
        if (!W) return;
        var y0 = 90, cx = W / 2;
        var x1 = 16 + moities[0].offsetWidth - 10;
        var x2 = W - 16 - moities[1].offsetWidth + 10;
        var ay = y0 - 58 - bonus;   // sommet de la pointe

        var dessus = ['M', x1, y0 - 16,
            'C', x1 + 50, y0 - 4, cx - 110, y0 - 3, cx - 60, y0 - 6,
            'C', cx - 22, y0 - 8, cx - 7, ay + 12, cx - 3, ay + 3,
            'Q', cx, ay - 3, cx + 3, ay + 3,
            'C', cx + 7, ay + 12, cx + 22, y0 - 8, cx + 60, y0 - 6,
            'C', cx + 110, y0 - 3, x2 - 50, y0 - 4, x2, y0 - 16];
        var dessous = ['L', x2, y0 + 14,
            'C', x2 - 50, y0 + 7, cx + 110, y0 + 6, cx + 60, y0 + 5,
            'L', cx - 60, y0 + 5,
            'C', cx - 110, y0 + 6, x1 + 50, y0 + 7, x1, y0 + 14, 'Z'];
        corps.setAttribute('d', dessus.concat(dessous).join(' '));

        reflet.setAttribute('d', [
            'M', x1 + 14, y0 - 9, 'C', x1 + 60, y0 - 1, cx - 110, y0 - 1, cx - 70, y0 - 3,
            'M', cx - 8, ay + 30, 'C', cx - 6, ay + 20, cx - 4, ay + 12, cx - 2, ay + 7,
            'M', cx + 70, y0 - 3, 'C', cx + 110, y0 - 1, x2 - 60, y0 - 1, x2 - 14, y0 - 9].join(' '));
        filet.setAttribute('viewBox', '0 0 ' + W + ' 110');
    }

    // Au relâchement, la pointe revient en place avec un petit rebond
    function ressort(depuis) {
        var t0 = performance.now();
        function pas(t) {
            var p = Math.min(1, (t - t0) / 500);
            dessinerFilet(p < 1 ? depuis * Math.exp(-5 * p) * Math.cos(12 * p) : 0);
            if (p < 1) requestAnimationFrame(pas);
        }
        requestAnimationFrame(pas);
    }

    dessinerFilet(0);
    window.addEventListener('resize', function() { dessinerFilet(0); });
    $(document).on('shown.bs.tab', function() { dessinerFilet(0); });

    // Une miette = un petit morceau de l'image du mozzastick qui tombe d'une des deux moitiés
    function lacherMiette() {
        var r = moities[Math.floor(Math.random() * moities.length)].getBoundingClientRect();
        var m = document.createElement('span');
        var taille = hasard(4, 8);
        m.className = 'accueil-miette-tiroir';
        m.style.left = (r.left + hasard(0.15, 0.85) * r.width) + 'px';
        m.style.top = (r.top + hasard(0.55, 0.85) * r.height) + 'px';
        m.style.width = taille + 'px';
        m.style.height = taille * hasard(0.6, 1) + 'px';
        m.style.backgroundPosition = '-' + hasard(20, 250) + 'px -' + hasard(15, 55) + 'px';
        m.style.animationDuration = hasard(0.8, 1.4) + 's';
        m.style.setProperty('--dx', hasard(-25, 25) + 'px');
        m.style.setProperty('--chute', hasard(120, 260) + 'px');
        m.style.setProperty('--rot', hasard(-400, 400) + 'deg');
        m.addEventListener('animationend', function() { m.remove(); });
        document.body.appendChild(m);
    }

    poignee.addEventListener('pointerdown', function(e) {
        debutY = dernierY = e.clientY;
        parcours = 0;
        decalageDepart = tiroir.classList.contains('ouvert') ? 0 : decalageMax();
        decalage = decalageDepart;
        tiroir.classList.add('en-glissement');
        poignee.setPointerCapture(e.pointerId);
    });

    poignee.addEventListener('pointermove', function(e) {
        if (debutY === null) return;
        decalage = Math.min(Math.max(decalageDepart + e.clientY - debutY, 0), decalageMax());
        tiroir.style.transform = 'translateY(' + decalage + 'px)';

        // Plus on tire vers le haut, plus la pointe du filet s'étire
        etirement = Math.min(35, Math.max(0, debutY - e.clientY) * 0.12);
        dessinerFilet(etirement);

        // Quelques miettes tombent au fil du mouvement (environ une tous les 14 px)
        parcours += Math.abs(e.clientY - dernierY);
        dernierY = e.clientY;
        while (parcours > 14) {
            parcours -= 14;
            if (Math.random() < 0.7) lacherMiette();
        }
    });

    function relacher() {
        if (debutY === null) return;
        debutY = null;
        tiroir.classList.remove('en-glissement');
        tiroir.style.transform = '';
        tiroir.classList.toggle('ouvert', decalage < decalageMax() / 2);
        ressort(etirement);
        etirement = 0;
    }
    poignee.addEventListener('pointerup', relacher);
    poignee.addEventListener('pointercancel', relacher);
});

// ---------- Coupure des mozzasticks ----------
$(function() {
    var audio = null;
    function hasard(min, max) { return min + Math.random() * (max - min); }

    // Bruit de crunch synthétisé : une rafale de petits craquements de bruit filtré
    function crunch() {
        var Ctx = window.AudioContext || window.webkitAudioContext;
        if (!Ctx) return;
        audio = audio || new Ctx();
        audio.resume();
        var t0 = audio.currentTime;
        for (var i = 0; i < 9; i++) {
            var duree = hasard(0.02, 0.07);
            var n = Math.floor(audio.sampleRate * duree);
            var buffer = audio.createBuffer(1, n, audio.sampleRate);
            var d = buffer.getChannelData(0);
            for (var j = 0; j < n; j++) d[j] = (Math.random() * 2 - 1) * Math.pow(1 - j / n, 3);

            var source = audio.createBufferSource();
            source.buffer = buffer;
            var filtre = audio.createBiquadFilter();
            filtre.type = 'bandpass';
            filtre.frequency.value = hasard(1200, 4500);
            filtre.Q.value = 0.9;
            var volume = audio.createGain();
            volume.gain.value = hasard(0.4, 0.9);

            source.connect(filtre);
            filtre.connect(volume);
            volume.connect(audio.destination);
            source.start(t0 + i * 0.022 + hasard(0, 0.015));
        }
    }

    function eclats(stick) {
        var couleurs = ['#8B4A12', '#B8661E', '#E8913A', '#FCD99A'];
        for (var i = 0; i < 12; i++) {
            var m = document.createElement('span');
            var taille = hasard(3, 7);
            m.className = 'accueil-miette';
            m.style.width = taille + 'px';
            m.style.height = taille * hasard(0.6, 1) + 'px';
            m.style.background = couleurs[i % couleurs.length];
            m.style.setProperty('--dx', hasard(-50, 50) + 'px');
            m.style.setProperty('--dy', hasard(-40, 70) + 'px');
            m.style.setProperty('--rot', hasard(-360, 360) + 'deg');
            m.addEventListener('animationend', function() { this.remove(); });
            stick.appendChild(m);
        }
    }

    $(document).on('click', '.accueil-stick', function() {
        var stick = this;
        if (stick.classList.contains('coupe')) return;
        stick.classList.add('coupe');
        crunch();
        eclats(stick);
        // On change d'onglet une fois l'animation vue, puis on recolle le bâtonnet
        setTimeout(function() {
            Shiny.setInputValue(stick.dataset.input, Date.now(), {priority: 'event'});
        }, 900);
        setTimeout(function() { stick.classList.remove('coupe'); }, 1500);
    });
});

// ---------- Mozzasticks de navigation des en-têtes ----------
$(document).on('click', '.nav-stick', function() {
    Shiny.setInputValue('nav_aller', this.dataset.cible, {priority: 'event'});
    window.scrollTo(0, 0);
});

// Étapes du parcours dans la fenêtre de présentation : on referme la fenêtre puis on change d'onglet
$(document).on('click', '.accueil-etape', function() {
    document.getElementById('accueil_tiroir').classList.remove('ouvert');
    Shiny.setInputValue('nav_aller', this.dataset.cible, {priority: 'event'});
    window.scrollTo(0, 0);
});
"

# Filet de mozzarella étiré (SVG) : épais et crémeux aux bords, fin et un peu tombant au milieu,
# avec un reflet brillant et quelques fibres fines
accueil_fil_svg <- HTML('
<svg class="fil" viewBox="0 0 100 60" preserveAspectRatio="none" aria-hidden="true">
  <defs>
    <linearGradient id="accueil-fromage" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0"    stop-color="#FFFEF8"/>
      <stop offset="0.45" stop-color="#FFF5D8"/>
      <stop offset="0.8"  stop-color="#F3DEA4"/>
      <stop offset="1"    stop-color="#DDBB6A"/>
    </linearGradient>
  </defs>
  <path d="M22,21 C40,26 60,26 80,19" fill="none" stroke="#FBF0CF" stroke-width="0.7"
        vector-effect="non-scaling-stroke" opacity="0.9"/>
  <path d="M2,10 C0,24 0,40 4,50 C16,52 28,50 38,48 C46,47 54,48 62,49 C74,50 86,52 96,50
           C100,40 100,22 97,9 C86,8 74,20 62,30 C54,33 46,33 38,31 C26,22 14,8 2,10 Z"
        fill="url(#accueil-fromage)"/>
  <path d="M7,15 C18,14 28,24 40,34 C50,36 58,35 64,33 C74,24 84,15 93,14" fill="none"
        stroke="#FFFFFF" stroke-width="2" vector-effect="non-scaling-stroke"
        stroke-linecap="round" opacity="0.85"/>
  <path d="M10,40 C22,42 32,40 42,40" fill="none" stroke="#E6CB86" stroke-width="0.8"
        vector-effect="non-scaling-stroke" opacity="0.7"/>
  <path d="M10,48 C30,57 68,58 90,48" fill="none" stroke="#F8EAC2" stroke-width="1"
        vector-effect="non-scaling-stroke"/>
</svg>')

# Un bouton mozzastick : deux moitiés, le filet de mozzarella et le titre
accueil_stick <- function(input_id, titre) {
    moitie <- function(cote) {
        div(class = paste("moitie", cote), div(class = "pane"), div(class = "coeur"))
    }
    tags$button(
        type = "button",
        class = "accueil-stick",
        `data-input` = input_id,
        `aria-label` = titre,
        accueil_fil_svg,
        moitie("gauche"),
        moitie("droite"),
        span(class = "accueil-libelle", accueil_titre_fromage(titre))
    )
}

# Titre en fromage : le texte + des gouttes qui coulent (placées hors des espaces entre les mots)
accueil_titre_fromage <- function(titre) {
    gouttes <- data.frame(
        x = c(10, 26, 58, 73, 89),     # position en % de la largeur du titre
        h = c(14, 9, 18, 10, 15),      # longueur en px
        d = c(0, -1.1, -0.5, -1.8, -0.9) # décalage de l'animation en s
    )
    span(
        class = "fromage",
        span(class = "texte", titre),
        lapply(seq_len(nrow(gouttes)), function(i) {
            span(
                class = "goutte",
                style = sprintf("left: %s%%; --h: %spx; --d: %ss;", gouttes$x[i], gouttes$h[i], gouttes$d[i])
            )
        })
    )
}

# Mozzastick de navigation posé à gauche ou à droite du titre d'un onglet :
# un clic envoie input$nav_aller = cible (valeur du nav_panel) au serveur
nav_stick <- function(cible, libelle, cote = c("gauche", "droite")) {
    cote <- match.arg(cote)
    tags$button(
        type = "button",
        class = paste("nav-stick", cote),
        `data-cible` = cible,
        `aria-label` = libelle,
        title = libelle,
        span(
            class = "nav-stick-libelle",
            if (cote == "gauche") "←",
            span(libelle),
            if (cote == "droite") "→"
        )
    )
}

# Filtre SVG « gluant » (défini une seule fois) : flou + seuil pour souder gouttes et lettres
accueil_filtre_gluant <- HTML('
<svg width="0" height="0" style="position: absolute;" aria-hidden="true">
  <filter id="accueil-gluant">
    <feGaussianBlur in="SourceGraphic" stdDeviation="1" result="flou"/>
    <feColorMatrix in="flou" mode="matrix"
                   values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 14 -6" result="colle"/>
    <feComposite in="SourceGraphic" in2="colle" operator="atop"/>
  </filter>
</svg>')

# --------------------------------------------------------------------------------------------------
# Contenu de la fenêtre de présentation
# --------------------------------------------------------------------------------------------------

# Un chiffre clé
accueil_chiffre <- function(valeur, libelle) {
    div(class = "accueil-chiffre", strong(valeur), span(libelle))
}

# Une étape du parcours : cliquer dessus ouvre l'onglet correspondant
accueil_etape <- function(numero, cible, titre, texte) {
    tags$button(
        type = "button",
        class = "accueil-etape",
        `data-cible` = cible,
        span(class = "accueil-etape-num", numero),
        strong(titre),
        span(texte),
        span(class = "accueil-etape-lien", "Y aller →")
    )
}

# Petit tableau HTML (extrait de données)
accueil_tableau <- function(df) {
    div(
        class = "accueil-table-cadre",
        tags$table(
            class = "accueil-table",
            tags$thead(tags$tr(lapply(names(df), tags$th))),
            tags$tbody(lapply(seq_len(nrow(df)), function(i) {
                tags$tr(lapply(df[i, ], function(v) tags$td(as.character(v))))
            }))
        )
    )
}

# Extrait consommateurs : les notes de deux consommateurs sur trois produits
accueil_extrait_conso <- dta_cons %>%
    filter(Consommateurs %in% unique(Consommateurs)[1:2]) %>%
    group_by(Consommateurs) %>%
    slice_head(n = 3) %>%
    ungroup() %>%
    transmute(Consommateur = Consommateurs, Produit = magasins_noms[as.character(Produit)],
              Global, Visuel, Goût, Texture) %>%
    accueil_tableau()

# Extrait jury : quelques descripteurs parlants, pour 4 produits
accueil_extrait_jury <- dta_panel %>%
    slice_head(n = 4) %>%
    transmute(Produit = magasins_noms[as.character(Produit)],
              Croustillant = croustillant, Dureté = dureté, Salé = salé,
              Gras = Aspect_gras, Mozzarella = mozzarella, Grillé = Arôme_grillé) %>%
    mutate(across(where(is.numeric), ~ format(round(.x, 1), nsmall = 1))) %>%
    accueil_tableau()

onglet_accueil <- nav_panel(
    title = "Accueil",
    value = "accueil",
    icon = icon("house"),

    tags$head(
        tags$link(
            rel = "stylesheet",
            href = "https://fonts.googleapis.com/css2?family=Fredoka:wght@400;600;700&family=Pacifico&display=swap"
        ),
        tags$style(HTML(accueil_css)),
        tags$script(HTML(accueil_js))
    ),

    div(
        class = "accueil-page",
        accueil_filtre_gluant,

        h1(class = "accueil-titre", "Mozzarella Sensory Analysis"),

        # Les 3 boutons mozzasticks au centre
        div(
            class = "accueil-boutons",
            accueil_stick("accueil_go_descriptive", "Analyse descriptive"),
            accueil_stick("accueil_go_recherche_opti", "Produit Optimal"),
            accueil_stick("accueil_go_analyse", "Analyse Factorielle")
        ),

        # Fenêtre descriptive à tirer vers le haut
        div(
            id = "accueil_tiroir",
            class = "accueil-tiroir",
            div(
                id = "accueil_poignee",
                class = "accueil-poignee",
                HTML('
                <svg class="poignee-filet" aria-hidden="true">
                  <defs>
                    <linearGradient id="accueil-fromage-filet" gradientUnits="userSpaceOnUse"
                                    x1="0" y1="20" x2="0" y2="104">
                      <stop offset="0"    stop-color="#FFF4D2"/>
                      <stop offset="0.6"  stop-color="#FBE8B0"/>
                      <stop offset="0.85" stop-color="#F3D68E"/>
                      <stop offset="1"    stop-color="#DDBB6A"/>
                    </linearGradient>
                  </defs>
                  <path class="corps" fill="url(#accueil-fromage-filet)"/>
                  <path class="reflet" fill="none" stroke="#FFFFFF" stroke-width="2"
                        stroke-linecap="round" opacity="0.85"/>
                </svg>'),
                div(class = "poignee-moitie gauche"),
                div(class = "poignee-moitie droite"),
                span(
                    class = "libelle",
                    span(class = "fleche", "︿"),
                    span(class = "quand-ferme", "Découvrir le projet"),
                    span(class = "quand-ouvert", "Refermer")
                )
            ),
            div(
                class = "accueil-contenu",

                # La question du projet
                div(
                    class = "accueil-question",
                    span(class = "accueil-surtitre", "Le projet"),
                    h2("Comment les notes du jury et des consommateurs permettent-elles de retrouver votre mozzastick idéal ?"),
                    p("Huit mozzarella sticks ont été goûtés deux fois : par un jury entraîné, qui les a
                       décrits avec précision, et par des consommateurs, qui ont simplement dit s'ils les
                       aimaient. L'application relie ces deux regards pour comprendre ce qui fait un bon
                       mozzastick, et trouver celui qui vous correspond.")
                ),

                # Les chiffres clés
                div(
                    class = "accueil-chiffres",
                    accueil_chiffre(8, "produits goûtés"),
                    accueil_chiffre(n_distinct(dta_cons$Consommateurs), "consommateurs"),
                    accueil_chiffre(ncol(dta_panel) - 1, "descripteurs du jury"),
                    accueil_chiffre(4, "notes d'appréciation")
                ),

                # Les deux jeux de données, avec un extrait de chacun
                h3(class = "accueil-section", span(class = "num", "1"), "Deux regards sur les mêmes produits"),
                div(
                    class = "accueil-donnees",
                    div(
                        class = "accueil-carte",
                        h4("🙋 Les consommateurs"),
                        p("Chaque consommateur note chaque produit de 1 (je déteste) à 9 (j'adore) :
                           une note globale, puis l'aspect, le goût et la texture."),
                        accueil_extrait_conso,
                        p(class = "accueil-legende",
                          sprintf("Extrait : %s lignes au total, une par consommateur et par produit.",
                                  format(nrow(dta_cons), big.mark = " ")))
                    ),
                    div(
                        class = "accueil-carte",
                        h4("🔬 Le jury entraîné"),
                        p("Des dégustateurs formés mesurent l'intensité de 37 caractéristiques
                           (forme, panure, croustillant, goût de fromage...). On garde la moyenne par produit."),
                        accueil_extrait_jury,
                        p(class = "accueil-legende",
                          "Extrait : 6 descripteurs sur 37, intensités moyennes du jury.")
                    )
                ),
                p(class = "accueil-note",
                  "Les 8 produits sont anonymes dans l'étude : chacun est associé ici à une enseigne
                   tirée au hasard, pour les rendre plus faciles à reconnaître."),

                # Le parcours dans l'application
                h3(class = "accueil-section", span(class = "num", "2"), "L'idée : relier les deux"),
                div(
                    class = "accueil-schema",
                    div(
                        class = "sources",
                        div(class = "accueil-bulle", strong("Le jury"), "décrit comment est chaque produit"),
                        div(class = "accueil-bulle", strong("Les consommateurs"), "disent s'il leur plaît")
                    ),
                    span(class = "lien", "→"),
                    div(class = "accueil-bulle centre",
                        strong("On les croise"),
                        "pour voir quelles caractéristiques (croustillant, goût de fromage...)
                         vont avec les meilleures notes"),
                    span(class = "lien", "→"),
                    div(class = "accueil-bulle fin",
                        strong("Votre produit idéal"),
                        "on en déduit le mozzastick qui vous correspond")
                ),

                h3(class = "accueil-section", span(class = "num", "3"), "Le parcours"),
                div(
                    class = "accueil-etapes",
                    accueil_etape(1, "descriptive", "Analyse descriptive",
                                  "Qui aime quoi ? Les notes des consommateurs et les profils du jury,
                                   produit par produit."),
                    accueil_etape(2, "analyse", "Analyse Factorielle",
                                  "Une AFM superpose les deux jeux de données pour voir quelles
                                   caractéristiques vont avec l'appréciation."),
                    accueil_etape(3, "recherche_opti", "Produit Optimal",
                                  "Réglez votre mozzastick idéal avec 5 curseurs : l'application trouve
                                   le produit le plus proche et le magasin où l'acheter.")
                )
            )
        )
    )
)


