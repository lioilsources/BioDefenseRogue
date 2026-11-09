// Index překladů pojmů pro UI hry (lib/l10n/lore_l10n.dart). Klíč = localeName
// z AppLocalizations; čeština tu není, ta žije v lib/domain/lore.dart.

import 'lore_ar.dart';
import 'lore_bn.dart';
import 'lore_ca.dart';
import 'lore_da.dart';
import 'lore_de.dart';
import 'lore_el.dart';
import 'lore_en.dart';
import 'lore_es.dart';
import 'lore_fi.dart';
import 'lore_fr.dart';
import 'lore_gu.dart';
import 'lore_he.dart';
import 'lore_hi.dart';
import 'lore_hr.dart';
import 'lore_hu.dart';
import 'lore_id.dart';
import 'lore_it.dart';
import 'lore_ja.dart';
import 'lore_kn.dart';
import 'lore_ko.dart';
import 'lore_ml.dart';
import 'lore_mr.dart';
import 'lore_ms.dart';
import 'lore_nb.dart';
import 'lore_nl.dart';
import 'lore_or.dart';
import 'lore_pa.dart';
import 'lore_pl.dart';
import 'lore_pt.dart';
import 'lore_pt_br.dart';
import 'lore_ro.dart';
import 'lore_ru.dart';
import 'lore_sk.dart';
import 'lore_sl.dart';
import 'lore_sv.dart';
import 'lore_ta.dart';
import 'lore_te.dart';
import 'lore_th.dart';
import 'lore_tr.dart';
import 'lore_uk.dart';
import 'lore_ur.dart';
import 'lore_vi.dart';
import 'lore_zh.dart';
import 'lore_zh_hant.dart';

/// Přeložené názvy (live pojmy) a věty „ve hře" (karty upgradů).
class LoreTable {
  const LoreTable({required this.names, required this.inGame});

  final Map<String, String> names;

  /// Věty s placeholdery {{balance.X|fmt}} jako v inGameCz.
  final Map<String, String> inGame;
}

const Map<String, LoreTable> loreTables = {
  'ar': loreAr,
  'bn': loreBn,
  'ca': loreCa,
  'da': loreDa,
  'de': loreDe,
  'el': loreEl,
  'en': loreEn,
  'es': loreEs,
  'fi': loreFi,
  'fr': loreFr,
  'gu': loreGu,
  'he': loreHe,
  'hi': loreHi,
  'hr': loreHr,
  'hu': loreHu,
  'id': loreId,
  'it': loreIt,
  'ja': loreJa,
  'kn': loreKn,
  'ko': loreKo,
  'ml': loreMl,
  'mr': loreMr,
  'ms': loreMs,
  'nb': loreNb,
  'nl': loreNl,
  'or': loreOr,
  'pa': lorePa,
  'pl': lorePl,
  'pt': lorePt,
  'pt_BR': lorePtBr,
  'ro': loreRo,
  'ru': loreRu,
  'sk': loreSk,
  'sl': loreSl,
  'sv': loreSv,
  'ta': loreTa,
  'te': loreTe,
  'th': loreTh,
  'tr': loreTr,
  'uk': loreUk,
  'ur': loreUr,
  'vi': loreVi,
  'zh': loreZh,
  'zh_Hant': loreZhHant,
};
