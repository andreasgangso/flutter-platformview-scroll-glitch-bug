import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView(
          children: <Widget>[
            Column(children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: PlatformViewLink(
                  viewType: 'NativeView',
                  surfaceFactory: (context, controller) {
                    return AndroidViewSurface(
                      controller: controller as AndroidViewController,
                      hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                      gestureRecognizers: <
                          Factory<OneSequenceGestureRecognizer>>{
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      },
                    );
                  },
                  onCreatePlatformView: (params) {
                    var controller =
                        PlatformViewsService.initExpensiveAndroidView(
                      id: params.id,
                      viewType: 'NativeView',
                      layoutDirection: TextDirection.ltr,
                      onFocus: () {
                        params.onFocusChanged(true);
                      },
                    );
                    controller
                      ..addOnPlatformViewCreatedListener((val) {
                        params.onPlatformViewCreated(val);
                      })
                      ..create();
                    return controller;
                  },
                ),
              ),
              SizedBox(
                height: 100,
                child: Container(
                  color: Colors.redAccent,
                  alignment: Alignment.bottomCenter,
                  child: const Text('this is the end of the column'),
                ),
              ),
            ]),
            // Just to create some scrolling:
            ...List.generate(
                10,
                (index) => SizedBox(
                      width: 100,
                      height: 500,
                      child: Container(color: Colors.green),
                    ))
          ],
        ),
      ),
    ]);
  }
}
