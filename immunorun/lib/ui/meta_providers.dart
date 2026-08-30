import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/meta_progress.dart';

class MetaNotifier extends Notifier<MetaProgress> {
  @override
  MetaProgress build() => MetaProgress.empty;

  void set(MetaProgress meta) => state = meta;
}

final metaProvider =
    NotifierProvider<MetaNotifier, MetaProgress>(MetaNotifier.new);
