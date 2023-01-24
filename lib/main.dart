import 'package:cam_ai/Camera/Camera.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Color.fromARGB(255, 223, 222, 222), // transparent status bar
  ));
  runApp(const MyApp()); initCamera();
}

late CameraController camController;
late Future<void> cameraValue;

void initCamera () async {
  camController = await Camera.getCameraController(0);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.red,),
      home: const MyHomePage(title: 'Came AI'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    camController.dispose();
  }

  void initCam () async {
    camController = await Camera.getCameraController(0);
    cameraValue = Camera.initCamera(camController, (bool status, value){
    print(value);
  });
  }

  @override
  void initState() {
    // TODO: implement initState
    initCam();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
        padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
        width: 325, color: Colors.white,
        child: Column(children: [
          Padding(padding: EdgeInsets.all(8), child: Icon(CupertinoIcons.camera_circle_fill, size: 120,color: Color.fromARGB(255, 150, 6, 6),),),
          Text("AI Camera", style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 35),),
          Container(
            margin: EdgeInsets.fromLTRB(0, 25, 0, 25),
            decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey))
          ),)
        ],),
      ),
      body: Container(
        child: Stack(children: [
          FutureBuilder(
            future: cameraValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Text("data");
              }
              return Center(child: CircularProgressIndicator(),);
          })
        ],),
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 150, 6, 6),
        onPressed: (){
       
        },
        tooltip: 'Camera',
        child: const Icon(CupertinoIcons.camera_fill),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
