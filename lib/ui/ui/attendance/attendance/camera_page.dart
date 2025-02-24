part of '../../../pages.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final FaceDetector faceDetector =
      GoogleMLKit.vision.faceDetector(FaceDetectorOptions(
    enableClassification: true,
    enableContours: true,
    enableLandmarks: true,
    enableTracking: true,
  ));

  List<CameraDescription>? cameras;
  CameraController? controller;
  XFile? image;
  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    loadCamera();
  }

  Future<void> loadCamera() async {
    cameras = await availableCameras();
    if (cameras == null || cameras!.isEmpty) {
      showSnackBar('No camera available');
      return;
    }
    controller = CameraController(
      cameras!.length > 1 ? cameras![1] : cameras![0],
      ResolutionPreset.max,
    );
    try {
      await controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      showSnackBar('Failed to initialize camera: $e');
    }
  }

  Future<void> prosesImage(InputImage inputImage) async {
    isBusy = true;
    final faces = await faceDetector.processImage(inputImage);
    isBusy = false;

    if (mounted) {
      setState(() {
        Navigator.pop(context);
        if (faces.isNotEmpty) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AttendancePage(image: image)));
        }
      });
    } else {
      showSnackBar('Make sure your face is clearly visibly!');
    }
  }

  Future<void> captureImage() async {
    final hasPermission = await handleLocationPermission();
    if (!hasPermission) return;

    try {
      if (controller != null && controller!.value.isInitialized) {
        controller!.setFlashMode(FlashMode.off);
        image = await controller!.takePicture();
        setState(() {
          showLoaderDialog();
          final inputImage = InputImage.fromFilePath(image!.path);
          if (Platform.isAndroid) {
            prosesImage(inputImage);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AttendancePage(image: image),
              ),
            );
          }
        });
      }
    } catch (e) {
      showSnackBar('Error:$e');
    }
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showSnackBar('Location service are disable. Please eneble them.');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showSnackBar("Location permission denied");
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showSnackBar("Location permission denied");
      return false;
    }
    return true;
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  void showLoaderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Processing...'),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Camera'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: size.height,
            width: size.width,
            child: controller == null || !controller!.value.isInitialized
                ? const Center(child: CircularProgressIndicator())
                : CameraPreview(controller!),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Lottie.asset("assets/raw/face_id_ring.json", fit: BoxFit.cover),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: buildBottomContainer(size),
          ),
        ],
      ),
    );
  }

  Widget buildBottomContainer(Size size) {
    return Container(
      width: size.width,
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "make sure youre in a well-lit area so your face is clearly visible",
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: ClipOval(
              child: Material(
                color: Colors.blueAccent,
                child: InkWell(
                  splashColor: Colors.blue,
                  onTap: captureImage,
                  child: const SizedBox(
                    width: 56,
                    height: 56,
                    child: Icon(
                      Icons.camera_enhance_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
