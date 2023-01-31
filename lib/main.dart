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

  Widget list (Widget widget) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: widget,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white))
      ),
    );
  }

  Widget _options_ () {
    return Center(child: Container(
      child : Column(children: [
        list(Text("Choose Action", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20),)),
        GestureDetector(onTap: () {
          setState(() {
              action = 0;
              mode = "Text Recognition";
              _options = false;
            });
        }, child: list(Text("Text Recognition", textAlign: TextAlign.start, style: TextStyle(color: Colors.white,),)),),
        GestureDetector(onTap: () {
          setState(() {
              action = 0;
              mode = "Barcode Scanning";
              _options = false;
            });
        }, child: list(Text("Barcode Scanning", textAlign: TextAlign.start, style: TextStyle(color: Colors.white,),)),),
        GestureDetector(onTap: () {
          setState(() {
              action = 1;
              mode = "Pose detection";
              _options = false;
            });
        }, child: list(Text("Pose detection", textAlign: TextAlign.start, style: TextStyle(color: Colors.white,),)),),
        Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(8)),
          width: 100, height: 40, child: TextButton(child: Text("Close", style: TextStyle(color: Colors.white),), onPressed: () {
            setState(() {
              _options = false;
            });
          },),),
        
      ],),
      width: MediaQuery.of(context).size.width - 50,
      height: 212, decoration: BoxDecoration(
        color: Color.fromARGB(150, 0, 0, 0), border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8))
    ),);
  }

  void capture () {
    camController.takePicture();
  }

  String _data = "", mode = "Text Recognition";
  bool _showDialog = false, _loading = false, _options = false;
  int action = 0;

  // alert dialog
  Widget dialog () {
    return Center(child: Container(
           height: 370, width: MediaQuery.of(context).size.width,
           child: Column(
            children: [
             Container(width: MediaQuery.of(context).size.width,
             padding: EdgeInsets.all(5),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text("RECOGNIZED TEXT", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 15,),),
                Container(width: 20,),
                GestureDetector(onTap: () {
                    setState(() { _showDialog = false; });
                }, child: Icon(Icons.cancel, color: Colors.white, size: 20,),)
              ],), height: 32,),
              Container( 
                width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height - 260,
                child: SingleChildScrollView(child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8), child:  Text(_data, style: TextStyle(color: Colors.white),),)
              ],)),
              )
           ],),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromARGB(125, 0, 0, 0),
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
      body: Container(color: Color.fromARGB(255, 36, 35, 35),
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
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: Row(children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(
                      color: Colors.redAccent, borderRadius: BorderRadius.circular(10)
                    ),),
                    Container(width: 10, height: 10,),
                    Text("$mode", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15)),
                    Container(width: 10, height: 10,),
                    GestureDetector(
                      child : Icon(Icons.more_vert, color: Colors.white, size: 15,),
                      onTap: () {
                        setState(() {
                          _options = true;
                        });
                      },
                    )
                  ]),
                )
                // dropdown widget
              ],
            ),
          ),
          // alert dialog
          _showDialog ? dialog() : Container(),
          _loading ? Center(child: CircularProgressIndicator(),) : Container(),
          _options ? _options_() : Container(),
        ],),
        //color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 150, 6, 6),
        onPressed: () async {
          try {

            setState(() { _showDialog = false; _loading = true; });

            XFile file = await camController.takePicture();
            InputImage image = ImageProcessor.getInputImage(file);

            String text = await TextRecognition.captureText(image);

            setState(() { _data = text; _showDialog = true; });
            
            setState(() { _loading = false; });

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
