import 'dart:io' show Platform;

class Secret {
  static const ANDROID_CLIENT_ID = "343705544018-0cb9qkn2u600pr79m422qto877hc4s3b.apps.googleusercontent.com";
  static const IOS_CLIENT_ID = "343705544018-p9q83gog6ehsjtsm2pbnva49065dho50.apps.googleusercontent.com";
  static String getId() => Platform.isAndroid ? Secret.ANDROID_CLIENT_ID : Secret.IOS_CLIENT_ID;
}