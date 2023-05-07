import 'package:flutter/foundation.dart';

String path(str) {
  return (kIsWeb) ? 'assets/$str' : str;
}