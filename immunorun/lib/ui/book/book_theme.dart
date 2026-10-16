// Jediné místo s mapováním část knihy / druh boxu → paleta CuteKidFonts
// (05-kniha ADR 0004: žádné hex barvy ani fonty mimo balíček v ui/book/).

import 'package:cute_kid_fonts/cute_kid_fonts.dart';

import '../../book/model/book_model.dart';
import '../../config/balance.dart';

/// Název knihy a popisek tlačítka (05-kniha OQ-1).
const String bookTitleCz  = 'Lexikon zdraví';
const String bookButtonCz = 'LEXIKON';

KidPalette paletteForPart(int part) => switch (BookPart.byNumber(part)) {
      BookPart.look   => KidPalette.mint,
      BookPart.who    => KidPalette.sky,
      BookPart.how    => KidPalette.peach,
      BookPart.memory => KidPalette.lavender,
      null            => KidPalette.sky,
    };

/// Box: paleta a titulek (čtečka ho sází podle druhu, standard §4).
({KidPalette palette, String title}) boxStyle(BoxKind kind) => switch (kind) {
      BoxKind.doopravdy => (palette: KidPalette.lemon,    title: 'Jak je to doopravdy'),
      BoxKind.vedel     => (palette: KidPalette.mint,     title: 'Věděl/a jsi?'),
      BoxKind.zvedave   => (palette: KidPalette.lavender, title: 'Pro zvědavé'),
      BoxKind.prakticky => (palette: KidPalette.sky,      title: 'Co s tím doma'),
    };

double bookFontScale(int step) => Balance.bookFontScales[
    step.clamp(0, Balance.bookFontScales.length - 1)];
