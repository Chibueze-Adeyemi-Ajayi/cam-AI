import 'package:cam_ai/Utils/ImageProcessor.dart';
import 'package:cam_ai/Utils/TextRecognition.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

late CameraController camController;
late Future<void> cameraValue;
late List <CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp()); 
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
    camController = CameraController(cameras[0], ResolutionPreset.max);
    cameraValue = camController.initialize().then((_) => {
        if (!mounted) {
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              title: Text("Camera Error"),
              content: Text("Unable to initialize the camera"),
              actions: [TextButton(onPressed: () {
                Navigator.pop(context);
                return null;
              }, child: Text("Text"))],
            );
          })
        } else setState(() { })
    }).catchError((Object e) {print(e.toString());});
  }

  @override
  void initState() {
    // TODO: implement initState
    initCam();
    super.initState();
  }

  void capture () {
    camController.takePicture();
  }

  // alert dialog
  Widget dialog () {
    return Center(child: Container(
           height: 300, width: MediaQuery.of(context).size.width,
           child: Column(children: [
             Container(child: Text("\nRECOGNIZED TEXT\n", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),), height: 50,)
           ],),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white)
            ),
          ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(
        decoration: BoxDecoration(color: Color.fromARGB(100, 8, 8, 8),
            border: Border(right: BorderSide(color: Color.fromARGB(255, 255, 255, 255)))
        ),
        padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
        width: 325, 
        child: Column(children: [
          
        ],),
      ),
      body: Container(
        child: Stack(children: [
          FutureBuilder(
            future: cameraValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  child: CameraPreview(camController),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ) ;
              }
              return Center(child: CircularProgressIndicator(),);
          }),
          Container(
            margin: EdgeInsets.fromLTRB(0, 65, 0, 0),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // activity widget
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white)),
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Row(children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(
                      color: Colors.redAccent, borderRadius: BorderRadius.circular(10)
                    ),),
                    Container(width: 10, height: 10,),
                    Text("Text Recognition", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15))
                  ]),
                )
                // dropdown widget
              ],
            ),
          ),
          // alert dialog
          dialog()
        ],),
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 150, 6, 6),
        onPressed: () async {
          try {

            XFile file = await camController.takePicture();
            InputImage image = ImageProcessor.getInputImage(file);

            String text = await TextRecognition.captureText(image);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Unexpected Error")));
          }
           
        },
        tooltip: 'Camera',
        child: const Icon(CupertinoIcons.camera_fill),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  
}
