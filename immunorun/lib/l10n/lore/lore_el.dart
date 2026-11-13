// Překlad pojmů registru z češtiny (lib/domain/lore.dart). Generováno ze
// zdroje překladů; ruční úpravy jsou v pořádku, klíče = id záznamů.

import 'lore_tables.dart';

const LoreTable loreEl = LoreTable(
  names: {
    'upgrade.opsonin': 'Οψωνοποίηση (IgG)',
    'upgrade.histamin': 'Ισταμίνη',
    'upgrade.pyrogen': 'Πυρετογόνο (IL-6)',
    'upgrade.treg': 'Treg (IL-10)',
    'upgrade.mitochondrie': 'Μιτοχόνδρια',
    'upgrade.membrana': 'Ρευστότητα μεμβράνης',
    'upgrade.cytotoxin': 'Κυτταροτοξικά κοκκία',
    'enemy.swarmer': 'Σμήνος (κόκκοι)',
    'enemy.tank': 'Βιοφίλμ (σωρός σταφυλόκοκκων)',
    'enemy.boss': 'Χρυσίζων σταφυλόκοκκος (αρχηγός)',
    'enemy.boss.phase2': 'Χρυσίζων σταφυλόκοκκος — δεύτερη φάση',
    'status.opsonized': 'Σημαδεμένος (οψωνοποιημένος)',
    'status.slowed': 'Επιβραδυμένος',
    'damage.kinetic': 'Σωματική ζημιά',
    'damage.inflammatory': 'Φλεγμονώδης ζημιά',
    'mechanic.fever': 'Πυρετός',
    'fever.normo': 'Φυσιολογική θερμοκρασία',
    'fever.febrile': 'Ήπιος πυρετός',
    'fever.hyper': 'Υψηλός πυρετός',
    'fever.critical': 'Κρίσιμος πυρετός',
    'room.combat': 'Μάχη',
    'room.elite': 'Ελίτ',
    'room.treasure': 'Θεραπεία',
    'room.boss': 'Αρχηγός',
    'meta.memoryCells': 'Κύτταρα μνήμης',
    'meta.vaccination': 'Εμβολιασμός',
    'ability.phagocytosis': 'Φαγοκυττάρωση (βασική επίθεση)',
    'ability.dash': 'Αμοιβαδοειδής κίνηση (εφόρμηση)',
    'ability.chargeDash': 'Ψευδοπόδια (φορτισμένη εφόρμηση)',
    'ability.oxidativeBurst': 'Οξειδωτική έκρηξη (ROS)',
    'ability.lysozymeBurst': 'Ριπή λυσοζύμης',
    'resource.atp': 'ATP',
    'mechanic.microscope': 'Ψευδοχρώματα (SEM)',
  },
  inGame: {
    'upgrade.opsonin':
        'Τα χτυπήματα σημαδεύουν τον στόχο — δέχεται {{balance.opsonizedDamageTakenMulti|pctDelta}} ζημιά για {{balance.opsonizedDuration|s}}.',
    'upgrade.histamin':
        'Τα χτυπήματα επιβραδύνουν τον στόχο κατά {{balance.slowedSpeedMulti|pctLess}} για {{balance.slowedDuration|s}}.',
    'upgrade.pyrogen':
        '{{balance.pyrogenDamageMulti|pctDelta}} ζημιά, αλλά κάθε βολή ανεβάζει τον πυρετό.',
    'upgrade.treg':
        'Ο πυρετός πέφτει {{balance.tregDecayBonus|degC}}/s γρηγορότερα.',
    'upgrade.mitochondrie':
        'Η ειδική επίθεση κοστίζει {{balance.mitochondrieCostMulti|pctLess}} λιγότερο ATP.',
    'upgrade.membrana':
        '+{{balance.membranaExtraDashCharges|int}} μέγιστο φορτίο εφόρμησης.',
    'upgrade.cytotoxin':
        '{{balance.cytotoxinDamageMulti|pctDelta}} βασική ζημιά βλημάτων.',
  },
);
