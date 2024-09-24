import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import 'dart:async';
import 'package:flutter/services.dart';

import 'package:wakelock_plus/wakelock_plus.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late WebViewControllerPlus _controler;
  Timer? _idleTimer;
  @override
  void initState() {
    _controler = WebViewControllerPlus()
      ..loadFlutterAssetServer('assets/demo-last-swipe.html')
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            _controler.getWebViewHeight().then((value) {
              var height = int.parse(value.toString()).toDouble();
              if (height != _height) {
                if (kDebugMode) {
                  print("Height is: $value");
                }
                setState(() {
                  _height = height;
                });
              }
            });
          },
        ),
      );

    super.initState();

    WakelockPlus.enable();
    startIdleTimer();
  }

  void startIdleTimer() {
    // إلغاء المؤقت الحالي إذا كان موجودًا
    _idleTimer?.cancel();

    // بدء مؤقت جديد لمدة 5 ثوانٍ
    _idleTimer = Timer(const Duration(seconds: 30), () {
      Navigator.pop(context); // تنفيذ pop عند عدم النشاط
    });
  }

  double _height = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffd5bf95),
      body: Listener(
        onPointerMove: (_) {
          // عند لمس الشاشة، نعيد ضبط المؤقت
          startIdleTimer();
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: WebViewWidget(
            controller: _controler,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controler.server.close();
    WakelockPlus.disable();
    super.dispose();
  }
}
