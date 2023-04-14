import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:zebraserviceprovider/help/globals.dart';

class CallSystemModel{
  Future<void> showCallkitIncoming(String uuid,socketChannel) async {
    CallKitParams callKitParams = CallKitParams(
      id: uuid,
      nameCaller: callerName,
      appName: 'Callkit',
      avatar: 'https://i.ibb.co/jWh4nty/appLogo.png',
     // handle: '0123456789',
      type: 0,
      textAccept: 'Accept',
      textDecline: 'Decline',
      textMissedCall: 'Missed call',
      textCallback: 'Call back',
      duration: 30000,
      extra: <String, dynamic>{'userId': '1a2b3c4d','socketChannel': socketChannel},
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: const AndroidParams(
          isCustomNotification: true,
          isShowLogo: false,
          isShowCallback: false,
          isShowMissedCallNotification: true,
          ringtonePath: 'system_ringtone_default',
          backgroundColor: '#ffffff',
          backgroundUrl: 'https://i.ibb.co/mhXrPq6/500.png',
          actionColor: '#4CAF50',
          incomingCallNotificationChannelName: "Incoming Call",
          missedCallNotificationChannelName: "Missed Call"),
      ios: IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
  }
}