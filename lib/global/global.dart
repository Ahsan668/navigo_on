import 'package:firebase_auth/firebase_auth.dart';
import 'package:navigo_on/models/direction_detail_info.dart';

import '../models/user_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

User? currentUser;

UserModel? userModelCurrentInfo;

String cloudMessagingServerToken = "key=AAAAsSNhq_g:APA91bGtfDynUNJH41Hzjpnm0BbsgKM5VOk9G_XULMRcDyTqwUXWpCxZac6Fmsd8z0EcjZfEWXpyMHF-0om1xqY1_ZAVKzuk2KDXY1nqABM7Cz-Aotj7pNLla8HlfyNUwEGPK8lhy-K3";

List driversList = [];
DirectionDetailsInfo? tripDirectionDetailsInfo;
String userDropOffAddress = "";
String driverCarDetails = "";
String driverName = "";
String driverPhone = "";
String driverRatings = "";

double countRatingStars = 0.0;
String titleStarsRating = "";