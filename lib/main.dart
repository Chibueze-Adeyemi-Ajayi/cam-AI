import 'package:cam_ai/Utils/BarcodeRecognition.dart';
import 'package:cam_ai/Utils/ImageProcessor.dart';
import 'package:cam_ai/Utils/PoseDetection.dart';
import 'package:cam_ai/Utils/TextRecognition.dart';
import 'package:cam_ai/Utils/mycanvas.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

late CameraController camController;
late Future<void> cameraValue;
late List <CameraDescription> cameras;

/
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

 // This disposes the camera controller on closing the app 

  @override
  void dispose() {
    // TODO: implement dispose 
    super.dispose();
    camController.dispose();
  }

// this function initializes the camera on the mobile devices

  void initCam () async {
    // initializing the camera controller
    camController = CameraController(
      cameras[0], ResolutionPreset.low
    );
    camController.setFocusPoint(Offset(0, 0));
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
          border: Border.all(color: Colors.white, width: 15, style: BorderStyle.solid)
        )
      ),
    );
  }
  // pose detection parameters 
  // array lists of parameters 
  List <String> landmarks = [ 
    "Right Shoulder", "Left Shoulder", "Right Elbow", "Left Elbow", 
    "Right Wrist", "Left Wrist", "Right Hip", "Left Hip", 
    "Right Knee", "Left Knee", "Right Ankle", "Left Ankle"
  ];
  // parameter variables 
  double r_shoulder_x = 0, r_shoulder_y = 0, l_shoulder_x = 0, l_shoulder_y = 0;
  double r_elbow_x = 0, r_elbow_y = 0, l_elbow_x = 0, l_elbow_y = 0;
  double r_wrist_x = 0, r_wrist_y = 0, l_wrist_x = 0, l_wrist_y = 0;
  double r_hip_x = 0, r_hip_y = 0, l_hip_x = 0, l_hip_y = 0;
  double r_knee_x = 0, r_knee_y = 0, l_knee_x = 0, l_knee_y = 0;
  double r_ankle_x = 0, r_ankle_y = 0, l_ankle_x = 0, l_ankle_y = 0;
  
  // tab widgets 
  Widget tab (String label, List <double> coordinates) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white))),
      padding: EdgeInsets.all(9),
      width: MediaQuery.of(context).size.width, height: 58,
      child: Row(children: [
        Text(label, style: TextStyle(color: Colors.white),), Container(width: 25,),
        Column(children: [
          Text("X: " + coordinates[0].toString(),style: TextStyle(color: Colors.white)),
          Container(height: 10, decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white, width: 1))),),
          Text("Y: " + coordinates[1].toString(),style: TextStyle(color: Colors.white)),
        ],)
      ],),
    );
  }

  Widget poseWidget () {
    var x  = -1; List <Widget> children = [];
    landmarks.forEach((landmark){ x ++;
      double X = 0.0, Y = 0.0;
      if (x == 0) { X = r_shoulder_x; Y = r_shoulder_y;} else 
      if (x == 1) { X = l_shoulder_x; Y = l_shoulder_y;} else 
      if (x == 2) { X = r_elbow_x; Y = r_elbow_y;} else 
      if (x == 3) { X = l_elbow_x; Y = l_elbow_y;} else 
      if (x == 4) { X = r_wrist_x; Y = r_wrist_y;} else 
      if (x == 5) { X = l_wrist_x; Y = l_wrist_y;} else 
      if (x == 6) { X = r_hip_x; Y = r_hip_y;} else 
      if (x == 7) { X = l_hip_x; Y = l_hip_y;} else 
      if (x == 8) { X = r_knee_x; Y = r_knee_y;} else 
      if (x == 9) { X = l_knee_x; Y = l_knee_y;} else 
      if (x == 10) { X = r_ankle_x; Y = r_ankle_y;} else 
      if (x == 11) { X = l_ankle_x; Y = l_ankle_y;}
      children.add(tab(landmark, [X, Y]));
    });
    return Container(
      padding: EdgeInsets.fromLTRB(10, 45, 10, 10),
      width: MediaQuery.of(context).size.width,
      height:  MediaQuery.of(context).size.height,
      color: Color.fromARGB(100, 41, 40, 40),
      child: PageView(children: [
        Column(children: [
          Text("Detecting Pose Landmarks", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          Container(height: 1, margin: EdgeInsets.fromLTRB(0, 10, 0, 10), decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white))
          ),),
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 100,
              child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(children: children,)),
            ),
          ),
        ],),
        Column(children: [
          Text("Pose Graph", textAlign: TextAlign.center , style: TextStyle(color: Colors.white),),
          canvas([
            Offset(r_shoulder_x, r_shoulder_y),
            Offset(l_shoulder_x, l_shoulder_y),
            Offset(r_elbow_x, r_elbow_y),
            Offset(l_elbow_x, l_elbow_y),
            Offset(r_wrist_x, r_wrist_y),
            Offset(l_wrist_x, l_wrist_y),
            Offset(r_hip_x, r_hip_y),
            Offset(l_hip_x, l_hip_y),
            Offset(r_knee_x, r_knee_y),
            Offset(l_knee_x, l_knee_y),
            Offset(r_ankle_x, r_ankle_y),
            Offset(l_ankle_x, l_ankle_y),
          ]),
        ],)
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
          final left_shoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
          final right_elbow = pose.landmarks[PoseLandmarkType.rightElbow];
          final left_elbow = pose.landmarks[PoseLandmarkType.leftElbow];
          final right_wrist = pose.landmarks[PoseLandmarkType.rightWrist];
          final left_wrist = pose.landmarks[PoseLandmarkType.leftWrist];
          final right_hip = pose.landmarks[PoseLandmarkType.rightHip];
          final left_hip = pose.landmarks[PoseLandmarkType.leftHip];
          final right_knee = pose.landmarks[PoseLandmarkType.rightKnee];
          final left_knee = pose.landmarks[PoseLandmarkType.leftKnee];
          final right_ankle = pose.landmarks[PoseLandmarkType.rightAnkle];
          final left_ankle = pose.landmarks[PoseLandmarkType.leftAnkle];
          
          setState(() {
            r_shoulder_x = right_shoulder!.x; r_shoulder_y = right_shoulder.y;
            l_shoulder_x = left_shoulder!.x; l_shoulder_y = left_shoulder.y;
            r_elbow_x = right_elbow!.x; r_elbow_y = right_elbow.y;
            l_elbow_x = left_elbow!.x; l_elbow_y = left_elbow.y;
            r_wrist_x = right_wrist!.x; r_wrist_y = right_wrist.y;
            l_wrist_x = left_wrist!.x; l_wrist_y = left_wrist.y;
            r_hip_x = right_hip!.x; r_hip_y = right_hip.y;
            l_hip_x = left_hip!.x; l_hip_y = left_hip.y;
            r_knee_x = right_knee!.x; r_knee_y = right_knee.y;
            l_knee_x = left_knee!.x; l_knee_y = left_knee.y;
            r_ankle_x = right_ankle!.x; r_ankle_y = right_ankle.y;
            l_ankle_x = left_ankle!.x; l_ankle_y = left_ankle.y;
          });

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

  bool pose_detection = false;

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
          pose_detection ? poseWidget() : Container()
          //canvas()
        ],),
        //color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: pose_detection ? FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 150, 6, 6),
        tooltip: 'Close Pose detection',
        child: const Icon(CupertinoIcons.switch_camera),
        onPressed: () {
          setState(() {
            pose_detection = false;
            PoseDetection.close();
            camController.stopImageStream();
          });
      }) : FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 150, 6, 6),
        onPressed: () async {
          try {

            setState(() { _showDialog = false; _loading = true; _options = false; });
            var image;
            
            if (action != 2) {
              XFile file = await camController.takePicture();
              image = ImageProcessor.getInputImage(file);
            }
            
            if (action == 0) { // recognizing text
              String text = await TextRecognition.captureText(image);
              setState(() { title = "RECOGNIZED TEXT"; _data = text; _showDialog = true; });
            } else if (action == 1) { //scanning bar code
              var result = await BarcodeRecognition().processCode(image);
              //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
              setState(() { title = "SCANNED CODE"; _data = result; _showDialog = true; });
            } else if (action == 2) { //detecting pose
               setState(() {
                 pose_detection = true;
               });
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
