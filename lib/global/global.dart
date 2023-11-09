import 'package:firebase_auth/firebase_auth.dart';
import 'package:tunctaxidriver/models/user_model.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
String mapKey = "AIzaSyCKDYvMGPo386lnpGr11t2bIox7BE7SHGM";
