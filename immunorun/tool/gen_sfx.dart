// Procedurální generátor placeholder SFX — 16-bit PCM mono WAV.
// Spusť jednou: `dart run tool/gen_sfx.dart` (z adresáře immunorun/).
// Výstup: assets/audio/*.wav (+ book_ambient.m4a přes ffmpeg) — licence CC0
// (vlastní syntéza, viz CREDITS.md).

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

const sampleRate = 22050;

void main() {
  final outDir = Directory('assets/audio');
  outDir.createSync(recursive: true);

  _write('hit.wav',          _hit());
  _write('death.wav',        _death());
  _write('dash.wav',         _dash());
  _write('pickup.wav',       _pickup());
  _write('boss_phase.wav',   _bossPhase());
  _write('player_hurt.wav',  _playerHurt());
  // Kniha Lexikon zdraví (05-kniha K6, ADR 0005)
  _write('book_open.wav',    _bookOpen());
  _write('page_turn.wav',    _pageTurn());
  _write('book_close.wav',   _bookClose());
  _writeAmbient('book_ambient.m4a', _bookAmbient());

  stdout.writeln('SFX vygenerovány do ${outDir.path}/');
}

// ── Syntéza ────────────────────────────────────────────────────────────────

/// Krátký šumový burst s rychlým dozvukem — zásah nepřítele.
List<double> _hit() {
  final rng = Random(1);
  return _samples(0.08, (t, n) {
    final env = exp(-t * 60);
    return (rng.nextDouble() * 2 - 1) * env * 0.7;
  });
}

/// Klesající tón — smrt nepřítele.
List<double> _death() {
  return _samples(0.22, (t, n) {
    final freq = 440.0 - 300.0 * (t / 0.22);
    final env  = exp(-t * 14);
    return sin(2 * pi * freq * t) * env * 0.6;
  });
}

/// Whoosh — filtrovaný šum s obálkou nájezd/dojezd — dash.
List<double> _dash() {
  final rng = Random(2);
  var low = 0.0; // jednoduchý low-pass
  return _samples(0.16, (t, n) {
    final raw = rng.nextDouble() * 2 - 1;
    low += 0.25 * (raw - low);
    final env = sin(pi * (t / 0.16)); // nájezd a dojezd
    return low * env * 0.9;
  });
}

/// Dvoutónový vzestupný blip — sběr ATP.
List<double> _pickup() {
  return _samples(0.12, (t, n) {
    final freq = t < 0.06 ? 660.0 : 990.0;
    final env  = exp(-t * 18);
    return sin(2 * pi * freq * t) * env * 0.5;
  });
}

/// Hluboký boom s dozvukem — přechod bossa do fáze 2.
List<double> _bossPhase() {
  final rng = Random(3);
  return _samples(0.35, (t, n) {
    final freq = 80.0 - 30.0 * (t / 0.35);
    final env  = exp(-t * 8);
    final tone = sin(2 * pi * freq * t);
    final noise = (rng.nextDouble() * 2 - 1) * exp(-t * 25) * 0.3;
    return (tone * 0.8 + noise) * env;
  });
}

/// Tlumený nízký úder — zásah hráče.
List<double> _playerHurt() {
  return _samples(0.12, (t, n) {
    final env = exp(-t * 30);
    return sin(2 * pi * 120 * t) * env * 0.8;
  });
}

/// Měkké vzestupné zazvonění (dvě kvinty) — otevření knihy.
List<double> _bookOpen() {
  return _samples(0.45, (t, n) {
    final env = (1 - exp(-t * 40)) * exp(-t * 6);
    final a = sin(2 * pi * 523.25 * t);
    final b = t > 0.09 ? sin(2 * pi * 783.99 * (t - 0.09)) : 0.0;
    return (a * 0.35 + b * 0.3) * env;
  });
}

/// Krátké „šustnutí" papíru: šum přes pásmový filtr, obálka nájezd/dojezd.
List<double> _pageTurn() {
  final rng = Random(4);
  var low = 0.0, lower = 0.0;
  return _samples(0.18, (t, n) {
    final raw = rng.nextDouble() * 2 - 1;
    low   += 0.45 * (raw - low);
    lower += 0.08 * (low - lower);
    final band = low - lower; // horní propust nad nízkým šumem
    final env  = sin(pi * (t / 0.18)) * exp(-t * 6);
    return band * env * 1.4;
  });
}

/// Tlumené zaklapnutí — zavření knihy.
List<double> _bookClose() {
  final rng = Random(5);
  return _samples(0.2, (t, n) {
    final thump = sin(2 * pi * 95 * t) * exp(-t * 28);
    final noise = (rng.nextDouble() * 2 - 1) * exp(-t * 60) * 0.25;
    return (thump * 0.7 + noise);
  });
}

/// Ambient smyčka knihy: měkký pad. Všechny frekvence a LFO mají celý počet
/// period v délce smyčky → bezešvé opakování (ADR 0005, ≤ 1 MB).
const ambientSeconds = 32;
List<double> _bookAmbient() {
  // Tóny ~ A2, E3, A3, C#4 zaokrouhlené na k / ambientSeconds Hz.
  const notes = [110.0, 164.8125, 220.0, 277.1875];
  const gains = [0.30, 0.22, 0.18, 0.12];
  return _samples(ambientSeconds.toDouble(), (t, n) {
    var v = 0.0;
    for (var i = 0; i < notes.length; i++) {
      final lfo = 0.6 + 0.4 * sin(2 * pi * (i + 1) * t / ambientSeconds);
      v += sin(2 * pi * notes[i] * t) * gains[i] * lfo;
    }
    return v * 0.5;
  });
}

// ── WAV zápis ──────────────────────────────────────────────────────────────

List<double> _samples(double seconds, double Function(double t, int n) f) {
  final count = (seconds * sampleRate).round();
  return List.generate(count, (n) => f(n / sampleRate, n));
}

/// Ambient: WAV do build/, pak ffmpeg → AAC (.m4a). OGG by byl menší, ale
/// audioplayers ho na iOS nepřehraje (05-kniha OQ-27).
void _writeAmbient(String name, List<double> samples) {
  final wav = 'build/${name.replaceAll('.m4a', '.wav')}';
  Directory('build').createSync(recursive: true);
  _write(wav, samples, path: wav);
  final r = Process.runSync('ffmpeg', [
    '-y', '-loglevel', 'error', '-i', wav,
    '-c:a', 'aac', '-b:a', '64k', 'assets/audio/$name',
  ]);
  if (r.exitCode != 0) {
    stderr.writeln('ffmpeg selhal (je nainstalovaný?): ${r.stderr}');
  }
}

void _write(String name, List<double> samples, {String? path}) {
  final data = ByteData(44 + samples.length * 2);
  void str(int offset, String s) {
    for (var i = 0; i < s.length; i++) {
      data.setUint8(offset + i, s.codeUnitAt(i));
    }
  }

  final dataSize = samples.length * 2;
  str(0, 'RIFF');
  data.setUint32(4, 36 + dataSize, Endian.little);
  str(8, 'WAVE');
  str(12, 'fmt ');
  data.setUint32(16, 16, Endian.little);           // PCM chunk size
  data.setUint16(20, 1, Endian.little);            // PCM formát
  data.setUint16(22, 1, Endian.little);            // mono
  data.setUint32(24, sampleRate, Endian.little);
  data.setUint32(28, sampleRate * 2, Endian.little); // byte rate
  data.setUint16(32, 2, Endian.little);            // block align
  data.setUint16(34, 16, Endian.little);           // bits/sample
  str(36, 'data');
  data.setUint32(40, dataSize, Endian.little);

  for (var i = 0; i < samples.length; i++) {
    final v = (samples[i].clamp(-1.0, 1.0) * 32767).round();
    data.setInt16(44 + i * 2, v, Endian.little);
  }

  File(path ?? 'assets/audio/$name').writeAsBytesSync(data.buffer.asUint8List());
}
