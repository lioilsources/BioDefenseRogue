// Čistý Dart — bez Flame importů.
// Registr pojmů hry: jediný zdroj českých názvů, vět „ve hře", vět „doopravdy"
// a odkazů do knihy (Prompts/06-sync, ADR 0001). UI hry i kniha čtou odsud.
//
// Pravidla (hlídá validateLore + test/lore_registry_test.dart):
// - co má české jméno viditelné hráčem, má záznam; žádná kopie textu jinde v lib/,
// - realityCz je tvrzení o biologii → sourceRef (zdroj, nebo 'TODO-FACT: …'),
// - lie = none ⇔ realityCz == null (03-mechaniky-z-biologie.md),
// - čísla v textech nikdy natvrdo: jen placeholdery {{balance.<konstanta>|<formát>}}
//   (06-sync ADR 0002, render v lore_text.dart); validateLore hlídá obojí.

import '../config/balance_map.g.dart';
import 'damage.dart';
import 'enemy_archetype.dart';
import 'lore_text.dart';
import 'fever_zone.dart';
import 'room_type.dart';
import 'status_effects.dart';
import 'upgrade.dart';

enum LoreKind {
  upgrade,
  enemy,
  status,
  damage,
  feverZone,
  room,
  meta,
  ability,
  resource,
  mechanic,
  hero,
  biome,
}

enum LoreStatus { live, planned, retired }

/// Jak moc hra lže (03-mechaniky-z-biologie.md): `large` = honesty box musí
/// popřít hlavní dojem z mechaniky, ne jen detail.
enum LieSize { none, small, large }

/// Prefix id podle druhu záznamu ('upgrade.opsonin', 'fever.febrile' …).
const Map<LoreKind, String> loreIdPrefix = {
  LoreKind.upgrade:   'upgrade.',
  LoreKind.enemy:     'enemy.',
  LoreKind.status:    'status.',
  LoreKind.damage:    'damage.',
  LoreKind.feverZone: 'fever.',
  LoreKind.room:      'room.',
  LoreKind.meta:      'meta.',
  LoreKind.ability:   'ability.',
  LoreKind.resource:  'resource.',
  LoreKind.mechanic:  'mechanic.',
  LoreKind.hero:      'hero.',
  LoreKind.biome:     'biome.',
};

/// Prefix sourceRef pro tvrzení, které ještě nemá ověřený zdroj
/// (05-kniha ADR 0003: do release nesmí).
const String loreTodoFact = 'TODO-FACT';

/// Kapitoly knihy (05-kniha/01-scope.md §4). Soubory vzniknou v K0/K3;
/// existenci souborů a kotev ověří S2.
abstract final class BookChapter {
  static const mikroskop   = '00-mikroskop';
  static const teloHrad    = '01-telo-jako-hrad';
  static const krvinky     = '02-bile-krvinky';
  static const nepratele   = '03-nepratele';
  static const fagocytoza  = '04-fagocytoza';
  static const horecka     = '05-horecka';
  static const zanet       = '06-zanet-a-histamin';
  static const cytokiny    = '07-cytokiny';
  static const protilatky  = '08-protilatky';
  static const energie     = '09-energie-bunky';
  static const zabijaci    = '10-zabijacke-bunky';
  static const uzlina      = '11-lymfaticka-uzlina';
  static const pamet       = '12-pamet-a-ockovani';
  // Fáze 2: pahýly se status: planned, v knize skryté (06-sync S5)
  static const evoluce     = '13-evoluce-nepratel';
  static const selhani     = '14-kdyz-obrana-selze';

  static const all = [
    mikroskop, teloHrad, krvinky, nepratele, fagocytoza, horecka, zanet,
    cytokiny, protilatky, energie, zabijaci, uzlina, pamet,
  ];

  static const planned = [evoluce, selhani];

  /// Všechny kapitoly, na které smí registr a validace odkazovat.
  static const known = [...all, ...planned];
}

class LoreEntry {
  const LoreEntry({
    required this.id,
    required this.kind,
    required this.nameCz,
    required this.inGameCz,
    this.status = LoreStatus.live,
    this.realityCz,
    this.lie = LieSize.none,
    this.chapter,
    this.anchor,
    this.ref,
    this.sourceRef,
    this.dativeCz,
  });

  final String     id;
  final LoreKind   kind;
  final LoreStatus status;

  /// Název viditelný hráčem i v knize.
  final String nameCz;

  /// Jedna věta: co pojem dělá ve hře.
  final String inGameCz;

  /// Jedna věta: jak je to doopravdy; null = hra nelže.
  final String? realityCz;
  final LieSize lie;

  /// Kapitola knihy (BookChapter) a kotva nadpisu v ní.
  final String? chapter;
  final String? anchor;

  /// Hodnota enumu v kódu (test úplnosti nad enumy).
  final Enum? ref;

  /// Zdroj pro realityCz: 'src: KLÍČ místo' nebo 'TODO-FACT: KLÍČ – co ověřit';
  /// klíč existuje v Prompts/05-kniha/sources.md (test, S4).
  final String? sourceRef;

  /// 3. pád pro věty typu „proti komu" (game-over: „imunizace proti …").
  final String? dativeCz;

  bool get needsFact => sourceRef?.startsWith(loreTodoFact) ?? false;
}

class LoreRegistry {
  LoreRegistry(this.entries)
      : _byId  = {for (final e in entries) e.id: e},
        _byRef = {for (final e in entries) if (e.ref != null) e.ref!: e};

  final List<LoreEntry>       entries;
  final Map<String, LoreEntry> _byId;
  final Map<Enum, LoreEntry>   _byRef;

  LoreEntry byId(String id) =>
      _byId[id] ?? (throw ArgumentError.value(id, 'id', 'není v registru'));

  LoreEntry byRef(Enum ref) =>
      _byRef[ref] ?? (throw ArgumentError.value(ref, 'ref', 'není v registru'));

  Iterable<LoreEntry> where({LoreKind? kind, LieSize? lie}) => entries.where(
      (e) => (kind == null || e.kind == kind) && (lie == null || e.lie == lie));
}

final LoreRegistry lore = LoreRegistry(allLore);

/// Enum hodnoty, které musí mít v registru právě jeden záznam.
final List<Enum> loreRequiredRefs = [
  ...UpgradeId.values,
  ...EnemyType.values,
  ...StatusEffect.values,
  ...DamageType.values,
  ...RoomType.values,
  ...FeverZone.values,
];

/// Ref existuje v kódu, ale nemá zatím gameplay → záznam musí být `planned`
/// (a naopak: jakmile gameplay dostane, záznam musí být `live`).
/// null = doména to neumí poznat (např. DamageType) → nekontroluje se.
bool? loreRefIsPlanned(Enum ref) => switch (ref) {
      StatusEffect() => statusBaseDuration(ref) == 0,
      // Hodnota těchto enumů existuje jen tehdy, když má gameplay (S5):
      // planned záznam s takovým ref se musí přepnout na live.
      EnemyType() || UpgradeId() || RoomType() || FeverZone() => false,
      _ => null,
    };

/// Vrátí seznam porušení pravidel registru (prázdný = v pořádku).
List<String> validateLore(
  Iterable<LoreEntry> entries, {
  Iterable<Enum>? requiredRefs,
  bool? Function(Enum ref) isPlannedRef = loreRefIsPlanned,
  Iterable<String> knownChapters = BookChapter.known,
  Map<String, num> lookup = balanceLookup,
}) {
  final registry = LoreRegistry(entries.toList());
  final errors   = <String>[];
  final ids      = <String>{};
  final names    = <String>{};
  final refCount = <Enum, int>{};
  final chapters = knownChapters.toSet();

  for (final e in entries) {
    final at = '${e.id}:';
    if (!ids.add(e.id))         errors.add('$at duplicitní id');
    if (!names.add(e.nameCz))   errors.add('$at duplicitní nameCz „${e.nameCz}"');
    if (!e.id.startsWith(loreIdPrefix[e.kind]!)) {
      errors.add('$at id nezačíná „${loreIdPrefix[e.kind]}" (kind ${e.kind.name})');
    }
    if (e.nameCz.trim().isEmpty)   errors.add('$at prázdné nameCz');
    if (e.inGameCz.trim().isEmpty) errors.add('$at prázdné inGameCz');

    // Čísla jen přes placeholdery; každý placeholder musí jít vyrenderovat.
    if (e.inGameCz.replaceAll(loreTextPlaceholder, '').contains(RegExp(r'[0-9]'))) {
      errors.add('$at číslo natvrdo v inGameCz (použij {{balance.…|…}})');
    }
    for (final text in [e.inGameCz, ?e.realityCz]) {
      for (final err in checkLoreText(text, lookup: lookup, registry: registry)) {
        errors.add('$at $err');
      }
    }

    if (e.status == LoreStatus.live && e.chapter == null) {
      errors.add('$at live záznam bez kapitoly');
    }
    if (e.chapter != null && !chapters.contains(e.chapter)) {
      errors.add('$at neznámá kapitola „${e.chapter}"');
    }

    final hasReality = e.realityCz != null;
    if (hasReality && (e.sourceRef == null || e.sourceRef!.trim().isEmpty)) {
      errors.add('$at realityCz bez sourceRef');
    }
    if (hasReality && e.lie == LieSize.none) {
      errors.add('$at realityCz s lie: none (hra lže → small|large)');
    }
    if (!hasReality && e.lie != LieSize.none) {
      errors.add('$at lie: ${e.lie.name} bez realityCz');
    }

    final ref = e.ref;
    if (ref != null) {
      refCount[ref] = (refCount[ref] ?? 0) + 1;
      final planned = isPlannedRef(ref);
      if (planned == true && e.status == LoreStatus.live) {
        errors.add('$at ref $ref nemá gameplay, záznam má být planned');
      }
      if (planned == false && e.status == LoreStatus.planned) {
        errors.add('$at ref $ref už má gameplay, záznam má být live');
      }
    }
  }

  for (final ref in requiredRefs ?? loreRequiredRefs) {
    final n = refCount[ref] ?? 0;
    if (n == 0) errors.add('$ref: chybí záznam v registru');
    if (n > 1)  errors.add('$ref: $n záznamů, má být právě jeden');
  }
  return errors;
}

// ════════════════════════════════════════════════════════════════════════════
// Záznamy
// ════════════════════════════════════════════════════════════════════════════

const List<LoreEntry> allLore = [
  // ── Upgrady ───────────────────────────────────────────────────────────────
  // inGameCz = text karty (UpgradeDef.descCz ho renderuje).
  LoreEntry(
    id:        'upgrade.opsonin',
    kind:      LoreKind.upgrade,
    ref:       UpgradeId.opsonin,
    nameCz:    'Opsonizace (IgG)',
    inGameCz:  'Zásahy značkují cíl — bere {{balance.opsonizedDamageTakenMulti|pctDelta}} '
               'poškození po {{balance.opsonizedDuration|s}}.',
    realityCz: 'Protilátka nepřítele nezraní ani nezeslabí. Přilepí se na něj '
               'jako značka a fagocyty ho pak snáz poznají a pohltí.',
    lie:       LieSize.small,
    chapter:   BookChapter.protilatky,
    anchor:    'opsonizace',
    sourceRef: '$loreTodoFact: JANEWAY – protilátky, opsonizace',
  ),
  LoreEntry(
    id:        'upgrade.histamin',
    kind:      LoreKind.upgrade,
    ref:       UpgradeId.histamin,
    nameCz:    'Histamin',
    inGameCz:  'Zásahy zpomalují cíl o {{balance.slowedSpeedMulti|pctLess}} '
               'na {{balance.slowedDuration|s}}.',
    realityCz: 'Histamin na bakterie nepůsobí. Uvolní ho žírné buňky, cévy pak '
               'propouštějí víc tekutiny, místo oteče a přiběhnou další obránci.',
    lie:       LieSize.large,
    chapter:   BookChapter.zanet,
    anchor:    'histamin',
    sourceRef: '$loreTodoFact: HOREJSI – žírné buňky, zánět',
  ),
  LoreEntry(
    id:        'upgrade.pyrogen',
    kind:      LoreKind.upgrade,
    ref:       UpgradeId.pyrogen,
    nameCz:    'Pyrogen (IL-6)',
    inGameCz:  '{{balance.pyrogenDamageMulti|pctDelta}} poškození, ale každý '
               'výstřel zvyšuje horečku.',
    realityCz: 'IL-6 opravdu pomáhá zapnout horečku, ale obráncům nepřidává sílu '
               'úderu; horečka jim jen dává lepší podmínky k práci.',
    lie:       LieSize.small,
    chapter:   BookChapter.horecka,
    anchor:    'pyrogeny',
    sourceRef: '$loreTodoFact: JANEWAY – cytokiny, IL-6, horečka',
  ),
  LoreEntry(
    id:        'upgrade.treg',
    kind:      LoreKind.upgrade,
    ref:       UpgradeId.treg,
    nameCz:    'Treg (IL-10)',
    inGameCz:  'Horečka klesá o {{balance.tregDecayBonus|degC}}/s rychleji.',
    realityCz: 'Regulační T buňky a IL-10 tlumí zánět, a tím horečku jen nepřímo; '
               'přímý „chladič" to není.',
    lie:       LieSize.small,
    chapter:   BookChapter.cytokiny,
    anchor:    'treg',
    sourceRef: '$loreTodoFact: HOREJSI – regulační T buňky, IL-10',
  ),
  LoreEntry(
    id:        'upgrade.mitochondrie',
    kind:      LoreKind.upgrade,
    ref:       UpgradeId.mitochondrie,
    nameCz:    'Mitochondrie',
    inGameCz:  'Speciální útok stojí o {{balance.mitochondrieCostMulti|pctLess}} '
               'méně ATP.',
    realityCz: 'Mitochondrie vyrábějí ATP pro celou buňku. Víc energie neznamená '
               'levnější útok, ale víc síly na všechno, co buňka dělá.',
    lie:       LieSize.small,
    chapter:   BookChapter.energie,
    anchor:    'mitochondrie',
    sourceRef: '$loreTodoFact: ALBERTS – mitochondrie, ATP',
  ),
  LoreEntry(
    id:        'upgrade.membrana',
    kind:      LoreKind.upgrade,
    ref:       UpgradeId.membrana,
    nameCz:    'Membránová fluidita',
    inGameCz:  '+{{balance.membranaExtraDashCharges|int}} maximální dash náboj.',
    realityCz: 'Pružná membrána pomáhá buňce měnit tvar a protahovat se tkání; '
               '„náboje" pohybu buňka nemá.',
    lie:       LieSize.small,
    chapter:   BookChapter.energie,
    anchor:    'membrana',
    sourceRef: '$loreTodoFact: ALBERTS – membrána, pohyb buňky',
  ),
  LoreEntry(
    id:        'upgrade.cytotoxin',
    kind:      LoreKind.upgrade,
    ref:       UpgradeId.cytotoxin,
    nameCz:    'Cytotoxické granule',
    inGameCz:  '{{balance.cytotoxinDamageMulti|pctDelta}} základní poškození '
               'projektilů.',
    realityCz: 'Cytotoxické granule (perforin, granzymy) používají hlavně NK '
               'buňky a CD8 T buňky, ne makrofág.',
    lie:       LieSize.small,
    chapter:   BookChapter.zabijaci,
    anchor:    'granule',
    sourceRef: '$loreTodoFact: JANEWAY – NK buňky, CD8 T, perforin',
  ),

  // ── Nepřátelé ─────────────────────────────────────────────────────────────
  LoreEntry(
    id:        'enemy.swarmer',
    kind:      LoreKind.enemy,
    ref:       EnemyType.swarmer,
    nameCz:    'Roj (cocci)',
    dativeCz:  'roji (cocci)',
    inGameCz:  'Malé kulaté bakterie, které na tebe najíždějí ve skupinách.',
    realityCz: 'Koky jako stafylokok nemají bičík a samy neplavou. Za obráncem se '
               'nehoní; nese je tekutina a přibývají dělením.',
    lie:       LieSize.small,
    chapter:   BookChapter.nepratele,
    anchor:    'koky',
    sourceRef: '$loreTodoFact: MIKRO – stafylokoky, pohyblivost',
  ),
  LoreEntry(
    id:        'enemy.tank',
    kind:      LoreKind.enemy,
    ref:       EnemyType.tank,
    // OQ-1: shluk S. aureus v biofilmu (ne houba).
    nameCz:    'Biofilm (shluk stafylokoků)',
    dativeCz:  'biofilmu',
    inGameCz:  'Pomalý a odolný shluk bakterií, který se těžko odstrčí.',
    realityCz: 'Biofilm je sliz, ve kterém bakterie drží pohromadě; obránci i '
               'antibiotika se k nim hůř dostanou. Po tkáni za obráncem neleze, '
               'drží se povrchu.',
    lie:       LieSize.small,
    chapter:   BookChapter.nepratele,
    anchor:    'biofilm',
    sourceRef: '$loreTodoFact: MIKRO – biofilm S. aureus',
  ),
  LoreEntry(
    id:        'enemy.boss',
    kind:      LoreKind.enemy,
    ref:       EnemyType.shooter,
    // OQ-5: v kódu `shooter`, v architektuře „The Coagulase Crown".
    nameCz:    'Zlatý stafylokok (boss)',
    dativeCz:  'bossovi',
    inGameCz:  'Velký stafylokok krouží arénou a střílí po tobě.',
    realityCz: 'Zlatý stafylokok nestřílí. Vylučuje do okolí jedy (toxiny), '
               'z nichž některé umějí zabíjet i bílé krvinky.',
    lie:       LieSize.small,
    chapter:   BookChapter.nepratele,
    anchor:    'stafylokok',
    sourceRef: '$loreTodoFact: MIKRO – toxiny S. aureus, leukocidiny',
  ),
  LoreEntry(
    id:        'enemy.boss.phase2',
    kind:      LoreKind.enemy,
    nameCz:    'Zlatý stafylokok — druhá fáze',
    inGameCz:  'Když stoupne horečka nebo je boss vážně zraněný, zrychlí '
               'a začne střílet dávky.',
    realityCz: 'Horečka bakterie neposiluje, vyšší teplota je naopak brzdí. '
               'Stafylokok ale umí přepnout na výrobu toxinů, když je bakterií '
               'pohromadě hodně (quorum sensing).',
    lie:       LieSize.large,
    chapter:   BookChapter.nepratele,
    anchor:    'stafylokok',
    sourceRef: '$loreTodoFact: MIKRO – agr, quorum sensing S. aureus',
  ),

  // ── Status efekty ─────────────────────────────────────────────────────────
  LoreEntry(
    id:        'status.opsonized',
    kind:      LoreKind.status,
    ref:       StatusEffect.opsonized,
    nameCz:    'Označený (opsonizovaný)',
    inGameCz:  'Cíl nese značku protilátek a dostává víc poškození.',
    realityCz: 'Značka cíl nezranitelnějším nedělá; fagocyty ho jen rychleji '
               'najdou a pohltí.',
    lie:       LieSize.small,
    chapter:   BookChapter.protilatky,
    anchor:    'opsonizace',
    sourceRef: '$loreTodoFact: JANEWAY – opsonizace',
  ),
  LoreEntry(
    id:        'status.slowed',
    kind:      LoreKind.status,
    ref:       StatusEffect.slowed,
    nameCz:    'Zpomalený',
    inGameCz:  'Cíl se chvíli pohybuje pomaleji.',
    realityCz: 'Bakterii nezpomalí žádná látka přímo; v oteklé tkáni je ale víc '
               'tekutiny a víc obránců, kteří jí stojí v cestě.',
    lie:       LieSize.small,
    chapter:   BookChapter.zanet,
    anchor:    'histamin',
    sourceRef: '$loreTodoFact: HOREJSI – zánět, edém',
  ),
  LoreEntry(
    id:        'status.inflamed',
    kind:      LoreKind.status,
    ref:       StatusEffect.inflamed,
    status:    LoreStatus.planned,
    nameCz:    'Zanícený',
    inGameCz:  'Plánováno: cíl v zanícené tkáni.',
    chapter:   BookChapter.zanet,
  ),
  LoreEntry(
    id:        'status.trapped',
    kind:      LoreKind.status,
    ref:       StatusEffect.trapped,
    status:    LoreStatus.planned,
    nameCz:    'Chycený v síti (NET)',
    inGameCz:  'Plánováno: neutrofilní síť drží cíl na místě.',
    chapter:   BookChapter.krvinky,
    anchor:    'neutrofil',
  ),
  LoreEntry(
    id:        'status.stunned',
    kind:      LoreKind.status,
    ref:       StatusEffect.stunned,
    status:    LoreStatus.planned,
    nameCz:    'Omráčený',
    inGameCz:  'Plánováno: cíl na chvíli ztratí schopnost jednat.',
  ),

  // ── Typy poškození ────────────────────────────────────────────────────────
  LoreEntry(
    id:        'damage.kinetic',
    kind:      LoreKind.damage,
    ref:       DamageType.kinetic,
    nameCz:    'Fyzické poškození',
    inGameCz:  'Poškození ze základních střel, z průjezdu nabitým dashem a z pulzu '
               'oxidativního vzplanutí.',
    realityCz: 'Bílé krvinky do bakterií nenarážejí; ničí je chemicky, enzymy '
               'a reaktivním kyslíkem.',
    lie:       LieSize.small,
    chapter:   BookChapter.zabijaci,
    anchor:    'typy-poskozeni',
    sourceRef: '$loreTodoFact: JANEWAY – mechanismy zabíjení fagocytů',
  ),
  LoreEntry(
    id:        'damage.inflammatory',
    kind:      LoreKind.damage,
    ref:       DamageType.inflammatory,
    nameCz:    'Zánětlivé poškození',
    inGameCz:  'Poškození z novy; každý zásah přitopí horečce.',
    chapter:   BookChapter.zabijaci,
    anchor:    'typy-poskozeni',
  ),
  LoreEntry(
    id:        'damage.toxic',
    kind:      LoreKind.damage,
    ref:       DamageType.toxic,
    status:    LoreStatus.planned,
    nameCz:    'Toxické poškození',
    inGameCz:  'Plánováno: poškození jedy.',
    chapter:   BookChapter.zabijaci,
    anchor:    'typy-poskozeni',
  ),
  LoreEntry(
    id:        'damage.thermal',
    kind:      LoreKind.damage,
    ref:       DamageType.thermal,
    status:    LoreStatus.planned,
    nameCz:    'Tepelné poškození',
    inGameCz:  'Plánováno: poškození teplem, výrazně zvedá horečku.',
    chapter:   BookChapter.zabijaci,
    anchor:    'typy-poskozeni',
  ),

  // ── Horečka ───────────────────────────────────────────────────────────────
  LoreEntry(
    id:        'mechanic.fever',
    kind:      LoreKind.mechanic,
    nameCz:    'Horečka',
    dativeCz:  'horečce',
    inGameCz:  'Teplota roste s bojem a klesá v klidu; podle zóny pomáhá i škodí.',
    chapter:   BookChapter.horecka,
    anchor:    'horecka',
  ),
  LoreEntry(
    id:        'fever.normo',
    kind:      LoreKind.feverZone,
    ref:       FeverZone.normal,
    nameCz:    'Normální teplota',
    inGameCz:  'Žádné bonusy ani tresty.',
    chapter:   BookChapter.horecka,
    anchor:    'normalni-teplota',
  ),
  LoreEntry(
    id:        'fever.febrile',
    kind:      LoreKind.feverZone,
    ref:       FeverZone.febrile,
    nameCz:    'Mírná horečka',
    inGameCz:  'Útočíš rychleji a silněji.',
    realityCz: 'Horečka ti útok nezrychlí. Brzdí množení bakterií a pomáhá '
               'obráncům se svolat a pracovat.',
    lie:       LieSize.large,
    chapter:   BookChapter.horecka,
    anchor:    'proc-horecka-pomaha',
    sourceRef: '$loreTodoFact: JANEWAY / HOREJSI – horečka',
  ),
  LoreEntry(
    id:        'fever.hyper',
    kind:      LoreKind.feverZone,
    ref:       FeverZone.hyper,
    nameCz:    'Vysoká horečka',
    inGameCz:  'Zásahy bývají kritické, ale postupně ztrácíš zdraví.',
    realityCz: 'Vysoká horečka obranu nevylepšuje, tělo vyčerpává; s takovou '
               'horečkou patří dítě k lékaři.',
    lie:       LieSize.small,
    chapter:   BookChapter.horecka,
    anchor:    'kdy-je-horecka-nebezpecna',
    sourceRef: '$loreTodoFact: SZU / PEDIATRIE – vysoká horečka',
  ),
  LoreEntry(
    id:        'fever.critical',
    kind:      LoreKind.feverZone,
    ref:       FeverZone.critical,
    nameCz:    'Kritická horečka',
    inGameCz:  'Když v ní zůstaneš příliš dlouho, run končí.',
    chapter:   BookChapter.horecka,
    anchor:    'kdy-je-horecka-nebezpecna',
  ),

  // ── Místnosti ─────────────────────────────────────────────────────────────
  // nameCz = popisek dveří (UI ho převádí na verzálky).
  LoreEntry(
    id:        'room.combat',
    kind:      LoreKind.room,
    ref:       RoomType.combat,
    nameCz:    'Boj',
    inGameCz:  'Místnost s vlnami nepřátel.',
    chapter:   BookChapter.teloHrad,
    anchor:    'mistnosti',
  ),
  LoreEntry(
    id:        'room.elite',
    kind:      LoreKind.room,
    ref:       RoomType.elite,
    nameCz:    'Elite',
    inGameCz:  'Těžší místnost s početnějšími vlnami.',
    chapter:   BookChapter.teloHrad,
    anchor:    'mistnosti',
  ),
  LoreEntry(
    id:        'room.treasure',
    kind:      LoreKind.room,
    ref:       RoomType.treasure,
    nameCz:    'Léčení',
    inGameCz:  'Klidná místnost bez boje, doplní ti zdraví.',
    chapter:   BookChapter.teloHrad,
    anchor:    'mistnosti',
  ),
  LoreEntry(
    id:        'room.boss',
    kind:      LoreKind.room,
    ref:       RoomType.boss,
    nameCz:    'Boss',
    inGameCz:  'Souboj s hlavním nepřítelem; výhra ukončí run.',
    chapter:   BookChapter.teloHrad,
    anchor:    'mistnosti',
  ),

  // ── Meta ──────────────────────────────────────────────────────────────────
  LoreEntry(
    id:        'meta.memoryCells',
    kind:      LoreKind.meta,
    nameCz:    'Paměťové buňky',
    inGameCz:  'Získáváš je za vyčištěné místnosti a výhru; přidávají zdraví '
               'na startu dalších runů.',
    realityCz: 'Paměťová buňka si pamatuje jednoho konkrétního nepřítele; obecně '
               'silnějším tě neudělá.',
    lie:       LieSize.small,
    chapter:   BookChapter.pamet,
    anchor:    'pametove-bunky',
    sourceRef: '$loreTodoFact: JANEWAY – imunologická paměť',
  ),
  LoreEntry(
    id:        'meta.vaccination',
    kind:      LoreKind.meta,
    nameCz:    'Vakcinace',
    inGameCz:  'V dalším runu dáváš víc poškození tomu, kdo tě zabil.',
    realityCz: 'Očkování nepřidává sílu útoku. Ukáže tělu nepřítele předem, '
               'takže odpověď je pak rychlejší a silnější.',
    lie:       LieSize.large,
    chapter:   BookChapter.pamet,
    anchor:    'ockovani',
    sourceRef: '$loreTodoFact: SZU / WHO – jak funguje očkování',
  ),

  // ── Schopnosti hráče (OQ-2) ───────────────────────────────────────────────
  LoreEntry(
    id:        'ability.phagocytosis',
    kind:      LoreKind.ability,
    nameCz:    'Fagocytóza (základní útok)',
    inGameCz:  'Makrofág sám střílí na nejbližší nepřátele.',
    realityCz: 'Makrofág nestřílí. Nepřítele obalí, pohltí a rozloží uvnitř sebe.',
    lie:       LieSize.large,
    chapter:   BookChapter.fagocytoza,
    anchor:    'fagocytoza',
    sourceRef: '$loreTodoFact: JANEWAY / HOREJSI – fagocytóza',
  ),
  LoreEntry(
    id:        'ability.dash',
    kind:      LoreKind.ability,
    nameCz:    'Améboidní pohyb (dash)',
    inGameCz:  'Rychlý přesun švihnutím; chvíli tě nic nezraní, náboje se obnovují.',
    realityCz: 'Buňka neuhýbá rychleji než bakterie a neporazitelnost je herní; '
               'skutečný pohyb je přelévání membrány.',
    lie:       LieSize.small,
    chapter:   BookChapter.energie,
    anchor:    'membrana',
    sourceRef: '$loreTodoFact: ALBERTS – améboidní pohyb',
  ),
  LoreEntry(
    id:        'ability.chargeDash',
    kind:      LoreKind.ability,
    nameCz:    'Panožky (nabitý dash)',
    inGameCz:  'Dvojité švihnutí: delší a rychlejší průjezd, který poškodí, '
               'čím projede.',
    realityCz: 'Makrofág do bakterií nenaráží, natáhne panožky a obalí je; '
               'průjezd je zkratka pro pohlcení za pohybu.',
    lie:       LieSize.small,
    chapter:   BookChapter.energie,
    anchor:    'panozky',
    sourceRef: '$loreTodoFact: ALBERTS / JANEWAY – pseudopodia, aktin',
  ),
  LoreEntry(
    id:        'ability.oxidativeBurst',
    kind:      LoreKind.ability,
    nameCz:    'Oxidativní vzplanutí (ROS)',
    inGameCz:  'Švihnutí tam a zpět: krátká neporazitelnost a pulz poškození '
               'kolem tebe.',
    realityCz: 'Reaktivní kyslík poškozuje i vlastní tkáň a nic jako '
               'neporazitelnost neexistuje; buňka se jen krátce stáhne.',
    lie:       LieSize.large,
    chapter:   BookChapter.fagocytoza,
    anchor:    'ros',
    sourceRef: '$loreTodoFact: JANEWAY – oxidativní vzplanutí',
  ),
  LoreEntry(
    id:        'ability.lysozymeBurst',
    kind:      LoreKind.ability,
    nameCz:    'Lysozymová salva',
    inGameCz:  'Kruhové gesto: střely do všech stran, stojí ATP.',
    realityCz: 'Lysozym není střela, je to enzym rozpuštěný v tekutině kolem '
               'buňky, který štěpí stěnu bakterií.',
    lie:       LieSize.small,
    chapter:   BookChapter.fagocytoza,
    anchor:    'lysozym',
    sourceRef: '$loreTodoFact: JANEWAY – lysozym',
  ),
  LoreEntry(
    id:        'ability.special',
    kind:      LoreKind.ability,
    // Vějíř střel ze hry zmizel (ATP dnes stojí jen nova) — viz OQ-9.
    status:    LoreStatus.retired,
    nameCz:    'Sekreční granule (NO, cytotoxiny)',
    inGameCz:  'Vyřazeno: vějíř silných střel směrem k cíli za ATP.',
    realityCz: 'Makrofág nestřílí; vylučuje látky směrem k cíli.',
    lie:       LieSize.small,
    chapter:   BookChapter.fagocytoza,
    anchor:    'sekrece',
    sourceRef: '$loreTodoFact: JANEWAY – sekrece makrofágů, NO',
  ),

  // ── Zdroje ────────────────────────────────────────────────────────────────
  LoreEntry(
    id:        'resource.atp',
    kind:      LoreKind.resource,
    nameCz:    'ATP',
    inGameCz:  'Energie na speciální útoky; pomalu se obnovuje a padá '
               'z poražených bakterií.',
    realityCz: 'Buňka si ATP vyrábí sama, hlavně v mitochondriích; z mrtvých '
               'bakterií ho nesbírá.',
    lie:       LieSize.large,
    chapter:   BookChapter.energie,
    anchor:    'atp',
    sourceRef: '$loreTodoFact: ALBERTS – ATP, buněčné dýchání',
  ),

  // ── Svět ──────────────────────────────────────────────────────────────────
  LoreEntry(
    id:        'mechanic.microscope',
    kind:      LoreKind.mechanic,
    nameCz:    'Falešné barvy (SEM)',
    inGameCz:  'Svět hry vypadá jako kolorovaný snímek z elektronového mikroskopu.',
    realityCz: 'Elektronový mikroskop barvy nevidí; snímky jsou černobílé '
               'a barvy se dodávají dodatečně. Živé buňky se v něm nepohybují, '
               'vzorek musí být připravený a vysušený.',
    lie:       LieSize.small,
    chapter:   BookChapter.mikroskop,
    anchor:    'falesne-barvy',
    sourceRef: '$loreTodoFact: SEM – SEM, příprava vzorku',
  ),

  // ── Roadmapa (06-sync S5): planned, bez ref; ref + live až s kódem ─────────
  // Postavy (architecture/SYSTEMS §3)
  LoreEntry(
    id:        'hero.neutrophil',
    kind:      LoreKind.hero,
    status:    LoreStatus.planned,
    nameCz:    'Neutrofil (postava)',
    inGameCz:  'Plánováno: rychlý obránce, který první přiběhne a umí vyhodit síť z DNA.',
    chapter:   BookChapter.krvinky,
    anchor:    'neutrofil',
  ),
  LoreEntry(
    id:        'hero.macrophage',
    kind:      LoreKind.hero,
    status:    LoreStatus.planned,
    nameCz:    'Makrofág (postava)',
    inGameCz:  'Plánováno: makrofág jako jedna z více hratelných postav.',
    chapter:   BookChapter.krvinky,
    anchor:    'makrofag',
  ),
  LoreEntry(
    id:        'hero.nk',
    kind:      LoreKind.hero,
    status:    LoreStatus.planned,
    nameCz:    'NK buňka (postava)',
    inGameCz:  'Plánováno: přirozený zabiják, který hledá nakažené buňky.',
    chapter:   BookChapter.krvinky,
    anchor:    'dalsi-clenove',
  ),
  LoreEntry(
    id:        'hero.bcell',
    kind:      LoreKind.hero,
    status:    LoreStatus.planned,
    nameCz:    'B buňka (postava)',
    inGameCz:  'Plánováno: střílí protilátky místo pohlcování.',
    chapter:   BookChapter.krvinky,
    anchor:    'dalsi-clenove',
  ),
  LoreEntry(
    id:        'hero.cd8',
    kind:      LoreKind.hero,
    status:    LoreStatus.planned,
    nameCz:    'Cytotoxická T buňka (postava)',
    inGameCz:  'Plánováno: zabíjí nakažené buňky granulemi.',
    chapter:   BookChapter.zabijaci,
    anchor:    'zabijaci',
  ),
  LoreEntry(
    id:        'hero.eosinophil',
    kind:      LoreKind.hero,
    status:    LoreStatus.planned,
    nameCz:    'Eozinofil (postava)',
    inGameCz:  'Plánováno: obránce proti velkým parazitům.',
    chapter:   BookChapter.krvinky,
  ),
  // Biomy (PLAN §2)
  LoreEntry(
    id:        'biome.epithelium',
    kind:      LoreKind.biome,
    status:    LoreStatus.planned,
    nameCz:    'Epitel (biom)',
    inGameCz:  'Plánováno: první biom, kůže a sliznice; dnes místnosti bez jména biomu.',
    chapter:   BookChapter.teloHrad,
    anchor:    'epitel',
  ),
  LoreEntry(
    id:        'biome.blood',
    kind:      LoreKind.biome,
    status:    LoreStatus.planned,
    nameCz:    'Krev (biom)',
    inGameCz:  'Plánováno: biom krevního řečiště.',
    chapter:   BookChapter.teloHrad,
  ),
  LoreEntry(
    id:        'biome.lung',
    kind:      LoreKind.biome,
    status:    LoreStatus.planned,
    nameCz:    'Plíce (biom)',
    inGameCz:  'Plánováno: biom plic, domov chřipky a plísní.',
    chapter:   BookChapter.teloHrad,
  ),
  LoreEntry(
    id:        'biome.marrow',
    kind:      LoreKind.biome,
    status:    LoreStatus.planned,
    nameCz:    'Kostní dřeň (biom)',
    inGameCz:  'Plánováno: biom, kde se rodí krvinky.',
    chapter:   BookChapter.krvinky,
  ),
  // Bossové (SYSTEMS §2); stafylokok = enemy.boss (OQ-13)
  LoreEntry(
    id:        'enemy.boss.flu',
    kind:      LoreKind.enemy,
    status:    LoreStatus.planned,
    nameCz:    'Chřipkový virus (boss)',
    inGameCz:  'Plánováno: mění svůj vzhled (antigenní drift).',
    chapter:   BookChapter.nepratele,
    anchor:    'viry',
  ),
  LoreEntry(
    id:        'enemy.boss.aspergillus',
    kind:      LoreKind.enemy,
    status:    LoreStatus.planned,
    nameCz:    'Plíseň Aspergillus (boss)',
    inGameCz:  'Plánováno: spory ve vzduchu, nebezpečná pro oslabené tělo.',
    chapter:   BookChapter.nepratele,
    anchor:    'houby',
  ),
  LoreEntry(
    id:        'enemy.boss.apex',
    kind:      LoreKind.enemy,
    status:    LoreStatus.planned,
    nameCz:    'Apex Strain (boss)',
    inGameCz:  'Plánováno: sepse, když se infekce rozlije do celého těla.',
    chapter:   BookChapter.selhani,
  ),
  // Mechaniky (SYSTEMS §5–6, PLAN §7)
  LoreEntry(
    id:        'mechanic.mutation',
    kind:      LoreKind.mechanic,
    status:    LoreStatus.planned,
    nameCz:    'Mutace',
    inGameCz:  'Plánováno: nepřátelé se mezi runy mění.',
    chapter:   BookChapter.evoluce,
  ),
  LoreEntry(
    id:        'mechanic.resistance',
    kind:      LoreKind.mechanic,
    status:    LoreStatus.planned,
    nameCz:    'Rezistence',
    inGameCz:  'Plánováno: bakterie se naučí odolávat útokům, které často dostávají.',
    chapter:   BookChapter.evoluce,
  ),
  LoreEntry(
    id:        'mechanic.sos',
    kind:      LoreKind.mechanic,
    status:    LoreStatus.planned,
    nameCz:    'SOS odpověď',
    inGameCz:  'Plánováno: bakterie v nouzi mutuje rychleji.',
    chapter:   BookChapter.evoluce,
  ),
  LoreEntry(
    id:        'mechanic.thPolarization',
    kind:      LoreKind.mechanic,
    status:    LoreStatus.planned,
    nameCz:    'Polarizace pomocných T buněk',
    inGameCz:  'Plánováno: volba typu odpovědi v lymfatické uzlině.',
    chapter:   BookChapter.uzlina,
  ),
  LoreEntry(
    id:        'mechanic.antigenPresentation',
    kind:      LoreKind.mechanic,
    status:    LoreStatus.planned,
    nameCz:    'Prezentace antigenu',
    inGameCz:  'Plánováno: ukázat kus nepřítele T buňkám a získat antigen.',
    chapter:   BookChapter.uzlina,
    anchor:    'prezentace-antigenu',
  ),
  LoreEntry(
    id:        'mechanic.clonalSelection',
    kind:      LoreKind.mechanic,
    status:    LoreStatus.planned,
    nameCz:    'Klonální selekce',
    inGameCz:  'Plánováno: namnožení obránců, kteří nepřítele poznali.',
    chapter:   BookChapter.uzlina,
    anchor:    'klonalni-selekce',
  ),
  LoreEntry(
    id:        'mechanic.cytokineStorm',
    kind:      LoreKind.mechanic,
    status:    LoreStatus.planned,
    nameCz:    'Cytokinová bouře',
    inGameCz:  'Plánováno: přehnaná odpověď, která škodí tělu.',
    chapter:   BookChapter.selhani,
  ),
  LoreEntry(
    id:        'mechanic.sepsis',
    kind:      LoreKind.mechanic,
    status:    LoreStatus.planned,
    nameCz:    'Sepse',
    inGameCz:  'Plánováno: infekce v celém těle; vede k bossovi Apex Strain.',
    chapter:   BookChapter.selhani,
  ),
];
