import 'dart:io' show Platform;

class mySecrets {
  static const ANDROID_CLIENT_ID = "1046346519724-enk2ao5kfp1f27k3ugak9qfe9chv02ok.apps.googleusercontent.com";
  static const IOS_CLIENT_ID = "<enter your iOS client secret>";

  static String getId() => Platform.isAndroid ? mySecrets.ANDROID_CLIENT_ID : mySecrets.IOS_CLIENT_ID;
}
