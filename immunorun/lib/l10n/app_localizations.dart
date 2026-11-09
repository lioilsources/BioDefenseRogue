import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('en'),
  ];

  /// Podtitul v hlavním menu pod názvem hry IMMUNORUN.
  ///
  /// In cs, this message translates to:
  /// **'Imunitní buňka vs. infekce'**
  String get menuSubtitle;

  /// Stav mety v menu: název pojmu (Paměťové buňky), počet buněk a bonus k maximálnímu zdraví. HP nechat.
  ///
  /// In cs, this message translates to:
  /// **'{name}: {count}  ·  +{hp} max HP'**
  String menuMemoryCells(String name, int count, int hp);

  /// Tlačítko: začít nový run (jedno kolo roguelite hry). Verzálky.
  ///
  /// In cs, this message translates to:
  /// **'SPUSTIT RUN'**
  String get menuStartRun;

  /// Tlačítko otevírající knihu Lexikon zdraví (encyklopedie těla pro děti). Verzálky.
  ///
  /// In cs, this message translates to:
  /// **'LEXIKON'**
  String get menuBook;

  /// Přepínač zvuku, stav zapnuto. Verzálky.
  ///
  /// In cs, this message translates to:
  /// **'ZVUK: ZAP'**
  String get menuSoundOn;

  /// Přepínač zvuku, stav vypnuto. Verzálky.
  ///
  /// In cs, this message translates to:
  /// **'ZVUK: VYP'**
  String get menuSoundOff;

  /// Nadpis obrazovky pauzy.
  ///
  /// In cs, this message translates to:
  /// **'PAUZA'**
  String get pauseTitle;

  /// Tlačítko: pokračovat ve hře.
  ///
  /// In cs, this message translates to:
  /// **'POKRAČOVAT'**
  String get pauseResume;

  /// Tlačítko: začít aktuální run znovu.
  ///
  /// In cs, this message translates to:
  /// **'RESTART RUNU'**
  String get pauseRestart;

  /// Tlačítko: návrat do hlavního menu.
  ///
  /// In cs, this message translates to:
  /// **'ZPĚT DO MENU'**
  String get backToMenu;

  /// Nadpis po prohře.
  ///
  /// In cs, this message translates to:
  /// **'GAME OVER'**
  String get gameOverTitle;

  /// Kolik vln nepřátel hráč přežil.
  ///
  /// In cs, this message translates to:
  /// **'Přežito vln: {count}'**
  String gameOverWaves(int count);

  /// Hráč prohrál dřív, než přežil první vlnu.
  ///
  /// In cs, this message translates to:
  /// **'Padl jsi hned.'**
  String get gameOverInstant;

  /// Tlačítko: otevře v knize stránku o tom, co hráče porazilo.
  ///
  /// In cs, this message translates to:
  /// **'CO MĚ ZABILO?'**
  String get gameOverCause;

  /// Tlačítko: hrát znovu.
  ///
  /// In cs, this message translates to:
  /// **'ZKUSIT ZNOVU'**
  String get gameOverRetry;

  /// Nadpis po výhře runu (boss poražen).
  ///
  /// In cs, this message translates to:
  /// **'IMMUNITA DOSAŽENA'**
  String get runWonTitle;

  /// Podtitul po výhře. Host = hostitel, tělo, které imunita chrání.
  ///
  /// In cs, this message translates to:
  /// **'Patogen zničen. Host přežil.'**
  String get runWonSubtitle;

  /// Tlačítko: začít nový run.
  ///
  /// In cs, this message translates to:
  /// **'NOVÝ RUN'**
  String get runWonNewRun;

  /// Kolik paměťových buněk (meta měna) hráč za run získal.
  ///
  /// In cs, this message translates to:
  /// **'{count, plural, =1{+1 paměťová buňka} few{+{count} paměťové buňky} other{+{count} paměťových buněk}}'**
  String metaCellsEarned(int count);

  /// Vakcinace: v příštím runu dáváš víc poškození tomu, kdo tě zabil. enemy je název nepřítele (v češtině ve 3. pádě), bonus je třeba „+25 %“. dmg = poškození.
  ///
  /// In cs, this message translates to:
  /// **'Příště: imunizace proti {enemy} ({bonus} dmg)'**
  String metaVaccinationHint(String enemy, String bonus);

  /// Výběr další místnosti (dveří).
  ///
  /// In cs, this message translates to:
  /// **'VYBER CESTU'**
  String get roomChoiceTitle;

  /// Výběr karty vylepšení; karty jsou cytokiny a receptory imunitní buňky.
  ///
  /// In cs, this message translates to:
  /// **'VYBER CYTOKIN / RECEPTOR'**
  String get upgradeChoiceTitle;

  /// Tooltip ikony info na kartě: otevře stránku v knize Lexikon.
  ///
  /// In cs, this message translates to:
  /// **'Co to je? (Lexikon)'**
  String get upgradeInfoTooltip;

  /// Odpočet před první vlnou; s = sekundy.
  ///
  /// In cs, this message translates to:
  /// **'ZAČÍNÁME ZA {secs}s'**
  String hudStartingIn(int secs);

  /// Odpočet do další vlny; s = sekundy.
  ///
  /// In cs, this message translates to:
  /// **'VLNA {wave} ZA {secs}s'**
  String hudWaveIn(int wave, int secs);

  /// Probíhající vlna nepřátel.
  ///
  /// In cs, this message translates to:
  /// **'VLNA {wave}'**
  String hudWave(int wave);

  /// Vlna nepřátel poražena.
  ///
  /// In cs, this message translates to:
  /// **'VLNA {wave} — VYČIŠTĚNO!'**
  String hudWaveCleared(int wave);

  /// Oznámení: hráč potkal nový pojem, v knize se mu odemkla stránka.
  ///
  /// In cs, this message translates to:
  /// **'Nová stránka v knize: {name}'**
  String bookToastOne(String name);

  /// Oznámení: víc nových stránek v knize; name je první pojem, count počet dalších.
  ///
  /// In cs, this message translates to:
  /// **'Nové stránky v knize: {name} a další ({count})'**
  String bookToastMany(String name, int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['cs', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
