import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/book.dart';
import 'package:video_player/video_player.dart';

import 'package:wakelock_plus/wakelock_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VideoScreen(),
    );
  }
}

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _controller = VideoPlayerController.asset('assets/video.mp4')
      ..initialize().then((_) {
        setState(() {
          _controller.play(); // تشغيل الفيديو تلقائياً
        });
      });

    // إضافة مستمع للأحداث لاكتشاف انتهاء الفيديو
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        // إذا انتهى الفيديو، إعادة تشغيله من البداية
        _controller.seekTo(Duration.zero);
        _controller.play();
      }
    });
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // استخدام MediaQuery للحصول على أبعاد الشاشة
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MainPage()));
          },
          child: _controller.value.isInitialized
              ? FittedBox(
                  fit: BoxFit.cover, // ضبط الفيديو باستخدام BoxFit.cover
                  child: SizedBox(
                    width: screenSize.width,
                    height: screenSize.height,
                    child: VideoPlayer(_controller),
                  ),
                )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_application_6/book.dart';

// void main() {
//   runApp(const WebViewPlusExample());
// }

// class WebViewPlusExample extends StatelessWidget {
//   const WebViewPlusExample({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: home());
//   }
// }

// class home extends StatelessWidget {
//   const home({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                   context, MaterialPageRoute(builder: (context) => MainPage()));
//             },
//             child: const Text("Enter")),
//       ),
//     );
//   }
// }
