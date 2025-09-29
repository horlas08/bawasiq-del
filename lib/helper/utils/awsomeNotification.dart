// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/helper/generalWidgets/permissionHandlerBottomSheet.dart';
import 'package:project/helper/utils/generalImports.dart';

@pragma('vm:entry-point')
class LocalAwesomeNotification {
  static AwesomeNotifications notification = AwesomeNotifications();

  final String normalNotificationChannel = "normalNotification";
  final String soundNotificationChannel = "soundNotification";

  static LocalAwesomeNotification localNotification = LocalAwesomeNotification();

  static StreamSubscription<RemoteMessage>? foregroundStream;
  static StreamSubscription<RemoteMessage>? onMessageOpen;
  static bool isNavigating = false;

  Future<void> init(BuildContext context) async {
    disposeListeners().then((value) async {
      await requestPermission(context: context);

      await notification.initialize('resource://mipmap/ic_launcher', [
        NotificationChannel(
          channelKey: soundNotificationChannel,
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel',
          playSound: true,
          enableVibration: true,
          importance: NotificationImportance.High,
          ledColor: ColorsRes.appColor,
          soundSource: Platform.isIOS ? "order_sound.aiff" : "resource://raw/order_sound",
        ),
        NotificationChannel(
          channelKey: normalNotificationChannel,
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel',
          playSound: true,
          enableVibration: true,
          importance: NotificationImportance.High,
          ledColor: ColorsRes.appColor,
        ),
      ], debug: kDebugMode);
    });

    await registerListeners(context);

    await listenTap(context);
  }

  listenTap(BuildContext context) {
    notification.setListeners(
      onDismissActionReceivedMethod: (receivedAction) async {},
      onNotificationDisplayedMethod: (receivedNotification) async {},
      onNotificationCreatedMethod: (receivedNotification) async {},
      onActionReceivedMethod: (ReceivedAction data) async {},
    );
  }

  // Normal notification
  createImageNotification({required RemoteMessage data, required bool isLocked}) async {
    await notification.createNotification(
      content: NotificationContent(
        id: Random().nextInt(5000),
        color: ColorsRes.appColor,
        title: data.data["title"]/*  ?? data.notification?.title ?? '' */,
        locked: isLocked,
        payload: Map.from(data.data),
        autoDismissible: true,
        showWhen: true,
        notificationLayout: NotificationLayout.BigPicture,
        body: data.data["message"]/*  ?? data.notification?.body ?? '' */,
        wakeUpScreen: true,
        largeIcon: data.data["image"],
        bigPicture: data.data["image"],
        channelKey: normalNotificationChannel,
      ),
    );
  }

  createNotification({required RemoteMessage data, required bool isLocked}) async {
    await notification.createNotification(
      content: NotificationContent(
        id: Random().nextInt(5000),
        color: ColorsRes.appColor,
        title: data.data["title"]/*  ?? data.notification?.title ?? '' */,
        locked: isLocked,
        payload: Map.from(data.data),
        autoDismissible: true,
        showWhen: true,
        notificationLayout: NotificationLayout.Default,
        body: data.data["message"]/*  ?? data.notification?.body ?? '' */,
        wakeUpScreen: true,
        channelKey: normalNotificationChannel,
      ),
    );
  }

  // Sound notification, if new order received sound notification will be played
  createImageNotificationWithSound({required RemoteMessage data, required bool isLocked}) async {
    await notification.createNotification(
      content: NotificationContent(
        id: Random().nextInt(5000),
        color: ColorsRes.appColor,
        title: data.data["title"],
        locked: isLocked,
        payload: Map.from(data.data),
        autoDismissible: true,
        showWhen: true,
        notificationLayout: NotificationLayout.BigPicture,
        body: data.data["message"],
        wakeUpScreen: true,
        largeIcon: data.data["image"],
        bigPicture: data.data["image"],
        channelKey: soundNotificationChannel,
      ),
    );
  }

  createNotificationWithSound({required RemoteMessage data, required bool isLocked}) async {
    await notification.createNotification(
      content: NotificationContent(
        id: Random().nextInt(5000),
        color: ColorsRes.appColor,
        title: data.data["title"],
        locked: isLocked,
        payload: Map.from(data.data),
        autoDismissible: true,
        showWhen: true,
        notificationLayout: NotificationLayout.Default,
        body: data.data["message"],
        wakeUpScreen: true,
        channelKey: soundNotificationChannel,
      ),
    );
  }

  requestPermission({required BuildContext context}) async {
    PermissionStatus notificationPermissionStatus = await Permission.notification.status;

    if (notificationPermissionStatus.isPermanentlyDenied) {
      if (!Constant.session.getBoolData(SessionManager.keyPermissionNotificationHidePromptPermanently)) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Wrap(
              children: [
                PermissionHandlerBottomSheet(
                  titleJsonKey: notificationPermissionTitleLabel,
                  messageJsonKey: notificationPermissionMessageLabel,
                  sessionKeyForAskNeverShowAgain: SessionManager.keyPermissionNotificationHidePromptPermanently,
                ),
              ],
            );
          },
        );
      }
    } else if (notificationPermissionStatus.isDenied) {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      Permission.notification.request();
    }
  }

  @pragma('vm:entry-point')
  static Future<void> onBackgroundMessageHandler(RemoteMessage data) async {
    await Firebase.initializeApp();
    if (data.notification == null){
    if (Platform.isAndroid) {
      if (data.data["sound"] == "default" || data.data["sound"] == null) {
        if (data.data["image"] == "" || data.data["image"] == null) {
          localNotification.createNotification(isLocked: false, data: data);
        } else {
          localNotification.createImageNotification(isLocked: false, data: data);
        }
      } else if (data.data["sound"] != "default") {
        if (data.data["image"] == "" || data.data["image"] == null) {
          localNotification.createNotificationWithSound(isLocked: false, data: data);
        } else {
          localNotification.createImageNotificationWithSound(isLocked: false, data: data);
        }
      }
    }
    }
  }

  static foregroundNotificationHandler() async {
    try {
    onMessageOpen = FirebaseMessaging.onMessage.listen((RemoteMessage data) {
      if (data.notification == null) {
        if (Platform.isAndroid) {
          if (data.data["sound"] == "default" || data.data["sound"] == null) {
            if (data.data["image"] == "" || data.data["image"] == null) {
              localNotification.createNotification(isLocked: false, data: data);
            } else {
              localNotification.createImageNotification(isLocked: false, data: data);
            }
          } else if (data.data["sound"] != "default") {
            if (data.data["image"] == "" || data.data["image"] == null) {
              localNotification.createNotificationWithSound(isLocked: false, data: data);
            } else {
              localNotification.createImageNotificationWithSound(isLocked: false, data: data);
            }
          }
        }
      }
    });
    } catch (e) {
      if (kDebugMode) {
        debugPrint("ISSUE ${e.toString()}");
      }
    }
  }

  static terminatedStateNotificationHandler() {
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? data) {
      if (data == null) {
        return;
      }

      //when app opens on notification tap (firebase-generated notification - for IOS notification tap)
    });
  }

  static registerListeners(context) async {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    await foregroundNotificationHandler();
    await terminatedStateNotificationHandler();
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessageHandler);
  }

  Future disposeListeners() async {
    onMessageOpen?.cancel();
    foregroundStream?.cancel();
  }
}
