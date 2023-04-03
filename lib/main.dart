import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DefaultPage(),
    );
  }
}

class DefaultPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState()=>DefaultState();
}

class DefaultState extends State<DefaultPage> {
  NativeViewController controller;
  double sz = 200;
  @override
  void initState() {
    controller = NativeViewController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellowAccent,
        appBar: AppBar(title: Text("Default Page")),
        body:  Center(
          child: Container(width: sz, height:sz,
              child: SampleView(controller: controller)),
        ),
        floatingActionButton: FloatingActionButton(child: Icon(Icons.change_history), onPressed: () {
          setState(() {
            sz = (sz == 200) ? 100 : 200;
            controller.changeBackgroundColor();
          });
        })
    );
  }
}



class SampleView extends StatefulWidget {
  const SampleView({
    Key key,
    this.controller,
  }) : super(key: key);

  final NativeViewController controller;

  @override
  State<StatefulWidget> createState() => _SampleViewState();
}

class _SampleViewState extends State<SampleView> {

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'SampleView',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else {
      return UiKitView(viewType: 'SampleView',
          onPlatformViewCreated: _onPlatformViewCreated
      );
    }
  }

  _onPlatformViewCreated(int id)=> widget.controller?.onCreate(id);
}



class NativeViewController {
  MethodChannel _channel;
  bool colorFlag = false;

  onCreate(int id) {
    _channel = MethodChannel('samples.chenhang/native_views_$id');
  }

  changeBackgroundColor() async
  {
    colorFlag = !colorFlag;
    var colorJson = colorFlag ? {"r":0, "g":0, "b": 1, "a":1} : {"r":1, "g":0, "b": 0, "a":1};
    _channel.invokeMethod('changeBackgroundColor', colorJson);
  }
}