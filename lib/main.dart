// mobile app for:
// 1. recognize texts
// 2. scanning bar codes
// 3. detecting pose

import 'package:cam_ai/Utils/BarcodeRecognition.dart';
import 'package:cam_ai/Utils/ImageProcessor.dart';
import 'package:cam_ai/Utils/PoseDetection.dart';
import 'package:cam_ai/Utils/TextRecognition.dart';
import 'package:cam_ai/Utils/mycanvas.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

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

  bool streaming = false;

  // continously capturing video
  void captureVideo () {
    camController.startVideoRecording();
  }

  @override
  void dispose() {
    // TODO: implement dispose 
    super.dispose();
    camController.dispose();
  }

  void initCam () async {
    camController = CameraController(cameras[0], ResolutionPreset.low);
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

  // option menu
  Widget _options_ () {
    return Center(child: Container(
      child : Column(children: [
        list(Text("Choose Action", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 20),)),
        GestureDetector(onTap: () {
          setState(() {
              action = 0; _code = false;
              mode = "Text Recognition";
              _options = false;
              if (streaming) stopLiveImageStream(); // stoping livestream if running
            });
        }, child: list(Text("Text Recognition", textAlign: TextAlign.start, style: TextStyle(color: Colors.white,),)),),
        GestureDetector(onTap: () {
          setState(() {
              action = 1;  _code = true;
              mode = "Barcode Scanning";
              _options = false;
              if (streaming) stopLiveImageStream(); // stoping livestream if running
            });
        }, child: list(Text("Barcode Scanning", textAlign: TextAlign.start, style: TextStyle(color: Colors.white,),)),),
        GestureDetector(onTap: () {
          setState(() {
              action = 2;  _code = false;
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

  // bar code region
  Widget _barCodeRegion () {
    return Center(
      child: Container(
        height: 300,
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 5, style: BorderStyle.solid)
        )
      ),
    );
  }

  Widget poseWidget () {
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      height:  MediaQuery.of(context).size.height,
      color: Color.fromARGB(125, 41, 40, 40),
      child: Column(children: [
        Text("Detecting Pose Landmarks", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
        Container(height: 1, margin: EdgeInsets.fromLTRB(0, 10, 0, 10),),
      ],),
    );
  }

  void streamLiveImage () async {
    await camController.startImageStream((CameraImage cameraImage) async {
        // processing the capturing frame
        streaming = true;
        InputImage image = ImageProcessor.getInputImageFromLiveStream(cameraImage, cameras[0]);
        // detecting poses from that frame
        List<Pose> poses = await PoseDetection.getPose(image);
        // printing out the poses
        List <Offset> landmarks = [];
        String output = "";
        for (Pose pose in poses) {
          final right_shoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
          final right_shoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
          final right_shoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
          final right_shoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
          final right_shoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
          final right_shoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
          final right_shoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
          final right_shoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
          final right_shoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
          final right_shoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
          final right_shoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
          final right_shoulder = pose.landmarks[PoseLandmarkType.rightShoulder];
          // pose.landmarks.forEach((_, landmark) {
          //   final type = landmark.type;
          //   final x = landmark.x;
          //   final y = landmark.y;
          //   landmarks.add(Offset(x, y));
          //   output += type.toString() + "\n" + "X:$x\nY:$y";
          // });
        }
        print(output);
    }); 
  }

  void stopLiveImageStream () async {
    await camController.stopImageStream();
  }

  void capture () {
    camController.takePicture();
  }

  String _data = "", mode = "Text Recognition"; Widget pose_widget = Container();
  bool _showDialog = false, _loading = false, _options = false, _code = false;
  int action = 0; String title = "RECOGNIZED TEXT";  
  
  // painitng palava
  Widget canvas (List <Offset> array) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: CustomPaint(
          painter: OpenPainter(offsets: array),
        ),
    );
  }

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
                Text("$title", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 15,),),
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
                    padding: EdgeInsets.all(8), 
                    child: title.indexOf("POSES") > -1 ? pose_widget : Text(_data, style: TextStyle(color: Colors.white),
                  ),)
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
                        setState(() { _options = true; _code = false; });
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
          _code ? _barCodeRegion() : Container(),
          //canvas()
        ],),
        //color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 150, 6, 6),
        onPressed: () async {
          try {

            setState(() { _showDialog = false; _loading = true; _options = false; });
            
            XFile file = await camController.takePicture();
            InputImage image = ImageProcessor.getInputImage(file);
            
            if (action == 0) { // recognizing text
              String text = await TextRecognition.captureText(image);
              setState(() { title = "RECOGNIZED TEXT"; _data = text; _showDialog = true; });
            } else if (action == 1) { //scanning bar code
              var result = await BarcodeRecognition().processCode(image);
              //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
              setState(() { title = "SCANNED CODE"; _data = result; _showDialog = true; });
            } else if (action == 2) { //detecting pose
              streamLiveImage();
            }
            
            setState(() { _loading = false; });

          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Unexpected Error" + e.toString())));
          }
           
        },
        tooltip: 'Camera',
        child: const Icon(CupertinoIcons.camera_fill),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  
}
