import 'dart:js_interop';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

/// A web implementation of the SecureApplication plugin.
class SecureApplicationWeb {
  bool secured = false;
  JSFunction? _visibilityListener;
  final MethodChannel _channel;
  SecureApplicationWeb(this._channel);

  void secureApplication() {
    _cancelListener();
    _visibilityListener = (JSAny? _) {
      if (web.document.visibilityState == 'hidden') {
        _channel.invokeMethod('lock', 'web');
      }
    }.toJS;
    web.document.addEventListener('visibilitychange', _visibilityListener);
    secured = true;
  }

  void _cancelListener() {
    if (_visibilityListener != null) {
      web.document.removeEventListener('visibilitychange', _visibilityListener);
      _visibilityListener = null;
    }
  }

  void unsecureApplication() {
    _cancelListener();
    secured = false;
  }

  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'secure_application',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = SecureApplicationWeb(channel);
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'secure':
        secureApplication();
        return true;
      case 'open':
        unsecureApplication();
        return true;
      default:
        return true;
    }
  }

  Future<String> getPlatformVersion() {
    final version = web.window.navigator.userAgent;
    return Future.value(version);
  }
}
