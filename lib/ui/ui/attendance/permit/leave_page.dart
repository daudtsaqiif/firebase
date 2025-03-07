part of '../../../pages.dart';

class LeavePage extends StatefulWidget {
  const LeavePage({super.key});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  String strAddress = '';
  String strDate = '';
  String strTime = '';
  String strDateTime = '';
  int dateHour = 0;
  int dateMinute = 0;
  double dLat = 0.0;
  double dLong = 0.0;
  final controllerName = TextEditingController();
  final fromController = TextEditingController();
  final untilController = TextEditingController();
  String dropValueCategories = "Please Choose";
  var caetgoryList = <String>[
    "Please Choose",
    "Sick",
    "Permission",
    "Other",
  ];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String userId = FirebaseAuth.instance.currentUser?.uid ?? 'Unknown';

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? 'Unknown';

    if (userId == 'Unknown') {
      return;
    }

    try {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(userId).get();
      print("user doc: ${userDoc.data()}");

      String firstName = userDoc['first_name'];
      String lastName = userDoc['last_name'];
      String fullName = '$firstName $lastName';

      setState(() {
        controllerName.text = fullName;
      });
    } catch (e) {
      print("Error fetching user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave page'),
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 12),
                      Icon(Icons.home_filled, color: Colors.white),
                      const SizedBox(width: 12),
                      Text(
                        'Please fill the form below',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    enabled: false,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    controller: controllerName,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      labelText: "Your Name",
                      hintText: "Please enter your name",
                      hintStyle:
                          const TextStyle(fontSize: 14, color: Colors.grey),
                      labelStyle:
                          const TextStyle(fontSize: 14, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blueAccent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blueAccent),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Leave Type',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: DropdownButton(
                      value: dropValueCategories,
                      onChanged: (value) {
                        setState(() {
                          dropValueCategories = value.toString();
                        });
                      },
                      items: caetgoryList.map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      isExpanded: true,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Text('From'),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: fromController,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(9999),
                                  );
                                  if (pickedDate != null) {
                                    fromController.text =
                                        DateFormat('dd/M/yyyy')
                                            .format(pickedDate);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            const Text('Until'),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: untilController,
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(9999),
                                  );
                                  if (pickedDate != null) {
                                    untilController.text =
                                        DateFormat('dd/M/yyyy')
                                            .format(pickedDate);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(8),
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: size.width * 0.8,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.amber,
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.blueAccent,
                          child: InkWell(
                            splashColor: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              if (controllerName.text.isEmpty ||
                                  dropValueCategories == "Please Choose" ||
                                  fromController.text.isEmpty ||
                                  untilController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        Icon(Icons.info_outline,
                                            color: Colors.white),
                                        SizedBox(width: 10),
                                        Text(
                                          "Please Fill all the form",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: Colors.blueAccent,
                                    shape: StadiumBorder(),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              } else {
                                submitAbsent(
                                    controllerName.text.toString(),
                                    dropValueCategories.toString(),
                                    fromController.text,
                                    untilController.text);
                              }
                            },
                            child: Center(
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submitAbsent(
      String name, String note, String from, String until) async {
    showLoaderDialog(context);

    String userId = FirebaseAuth.instance.currentUser?.uid ?? 'Unknown';
    print("USER ID =  $userId");
    if (userId == 'Unknown') {
      print("ERROR: User ID is unknowner");
      return;
    }

    DocumentReference UserDocRef = firestore.collection('users').doc(userId);
    CollectionReference attendanceCollection =
        UserDocRef.collection('attendance');

    attendanceCollection.add({
      'name': name,
      'description': note,
      'dateTime': '$from-$until',
      'createdAt': FieldValue.serverTimestamp(),
    }).then(
      (result) {
        print("Data has been saved whit ID = ${result.id}");
        setState(
          () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      "Data has been saved",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                backgroundColor: Colors.greenAccent,
                behavior: SnackBarBehavior.floating,
                shape: StadiumBorder(),
                duration: Duration(seconds: 3),
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeAttendancePage(),
              ),
            );
          },
        );
      },
    ).catchError((error) {
      print("filed to save data: $error");
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Upss...$error",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.blueGrey,
          behavior: SnackBarBehavior.floating,
          shape: StadiumBorder(),
          duration: Duration(seconds: 3),
        ),
      );
    });
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      content: Row(
        children: <Widget>[
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
          Container(
            margin: const EdgeInsets.only(left: 7),
            child: const Text("Please Wait..."),
          ),
        ],
      ),
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
