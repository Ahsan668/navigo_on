import 'package:firebase_auth/firebase_auth.dart';
import 'package:navigo_on/models/direction_detail_info.dart';

import '../models/user_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

User? currentUser;

UserModel? userModelCurrentInfo;

//firebase messaging server_token_url
String cloudMessagingServerToken = "key=";

List driversList = [];
DirectionDetailsInfo? tripDirectionDetailsInfo;
String userDropOffAddress = "";
String driverCarDetails = "";
String driverName = "";
String driverPhone = "";
String driverRatings = "";

double countRatingStars = 0.0;
String titleStarsRating = "";
