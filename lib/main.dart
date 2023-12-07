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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ...List.generate(
                10,
                (index) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  width: double.infinity,
                  height: 500,
                  child: PlatformViewLink(
                    viewType: 'NativeView',
                    surfaceFactory: (context, controller) {
                      return AndroidViewSurface(
                        controller: controller as AndroidViewController,
                        hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                        gestureRecognizers: const <Factory<
                            OneSequenceGestureRecognizer>>{},
                      );
                    },
                    onCreatePlatformView: (params) {
                      var controller = PlatformViewsService.initAndroidView(
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
              )
            ],
          ),
        ),
      ),
    ]);
  }
}
