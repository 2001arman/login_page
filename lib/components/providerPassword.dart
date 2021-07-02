import 'package:flutter/foundation.dart';

class ProviderPassword with ChangeNotifier {
  bool _lihatPassword = true;
  bool get lihatPassword => _lihatPassword;
  set lihatPassword(bool value) {
    _lihatPassword = value;
    notifyListeners();
  }
}
