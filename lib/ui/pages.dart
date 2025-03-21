import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/service/services.dart';
import 'package:firebase/themes/shared.dart';
import 'package:firebase/ui/ui/attendance/history/widget/attendance_card_widget.dart';
import 'package:firebase/utils/detection/google_ml_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';

part 'auth/sign_in_page.dart';
part 'auth/sign_up_page.dart';
part 'ui/home_page.dart';
part 'ui/note_page.dart';
part 'ui/profile_page.dart';
part 'ui/update_profile_page.dart';
part 'ui/change_password_page.dart';
part 'ui/attendance/home_attendance_page.dart';
part 'ui/attendance/attendance/attendance_page.dart';
part 'ui/attendance/attendance/camera_page.dart';
part 'ui/attendance/permit/leave_page.dart';
part 'ui/attendance/history/history_Page.dart';