import 'package:flutter/material.dart';

import 'app.dart';
import 'data/local_store.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PixelzApp(state: AppState(await LocalStore.open())));
}
