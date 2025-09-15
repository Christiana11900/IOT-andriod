import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:dio/dio.dart' as dio;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../model/breathsafe_model.dart';
import '../repository/repository.dart';
import '../ui/util/Notification_util.dart';
import '../ui/util/app_string.dart';
import '../ui/util/create_uid.dart';

class BreathsafeController extends GetxController {

  RxDouble field1 = 0.0.obs;
  RxDouble field2 = 0.0.obs;
  RxDouble field3 = 0.0.obs;
  var pongCount = 0; // Pong counter
  var pingCount = 0; // Ping counter
  late NotificationUtil notificationUtil;
  BuildContext? context;
  Timer? timer;

  BreathsafeController({required this.context});


  @override
  void onInit() async {
    notificationUtil = NotificationUtil(
      awesomeNotifications: AwesomeNotifications(),
    );
    try {
      AwesomeNotifications().setListeners(
        onNotificationCreatedMethod: (notification) async =>
            NotificationUtil.onNotificationCreatedMethod(
                notification, context),
        onActionReceivedMethod: NotificationUtil.onActionReceivedMethod,
        onDismissActionReceivedMethod: (ReceivedAction receivedAction) =>
            NotificationUtil.onDismissActionReceivedMethod(receivedAction),
        onNotificationDisplayedMethod:
            (ReceivedNotification receivedNotification) =>
            NotificationUtil.onNotificationDisplayedMethod(
                receivedNotification),
      );
    } catch (e) {
      debugPrint('$e');
    }
    requestPermission();
    createBasicNotification(title: 'BreathSafe', content: 'This is for safe breath');
    await feed1();
    await feed2();
    await feed3();
    await pushNotification();


    super.onInit();
  }

  @override
  void onReady() async {
    timer = Timer.periodic(const Duration(milliseconds: 2000), ((timer) async{
      await feed1();
      await feed2();
      await feed3();
    }));
    super.onReady();
  }

  void createBasicNotification({required String title, required String content}) {
    try {
      notificationUtil.createBasicNotification(
        id: createUniqueId(),
        channelKey: AppStrings.BASIC_CHANNEL_KEY,
        title: title,
        body: content,
        bigPicture: 'asset://assets/icons/breathsafe.png',   //
      );
    }on PlatformException catch(error){
      debugPrint(error.message!.toString());
    }
  }


  Future<void> feed1() async {
    debugPrint('From arrived page');
    try {
      dio.Response response = await Repository.temp();
      if (kDebugMode) {
        debugPrint('response');
        debugPrint(response.data['feeds'].toString());

        //response.data['data']['token']
      }
      for (var rides in List.from(response.data['feeds'])) {
        if(rides['field1'] != null){
          debugPrint(rides['field1']);
          field1.value = double.parse(rides['field1']) ;
        }
        update();
        notifyChildrens();
      }

      update();
      notifyChildrens();
    } on dio.DioException catch (e) {
      if (kDebugMode) {
        print(e);
        print(e.error);
      }
    } finally {}
  }

  void requestPermission() {
    notificationUtil.requestPermissionToSendNotifications(context: context);
  }

  Future<void> feed2() async {
    debugPrint('From arrived page');
    try {
      dio.Response response = await Repository.hum();
      if (kDebugMode) {
        debugPrint('response');
        debugPrint(response.data['feeds'].toString());

        //response.data['data']['token']
      }
      for (var rides in List.from(response.data['feeds'])) {
        if(rides['field2'] != null){
          debugPrint(rides['field2']);
          field2.value = double.parse(rides['field2']);
        }
        update();
        notifyChildrens();
      }

      update();
      notifyChildrens();
    } on dio.DioException catch (e) {
      if (kDebugMode) {
        print(e);
        print(e.error);
      }
    } finally {}
  }

  Future<void> feed3() async {
    debugPrint('From arrived page');
    try {
      dio.Response response = await Repository.gas_level();
      if (kDebugMode) {
        debugPrint('response');
        debugPrint(response.data['feeds'].toString());

        //response.data['data']['token']
      }
      for (var rides in List.from(response.data['feeds'])) {
        if(rides['field3'] != null){
          debugPrint(rides['field3']);
          field2.value = double.parse(rides['field3']);
          if( field2.value > 50){
            createBasicNotification(title: 'BreathSafe', content: 'Unhealthy air');
          }else{

          }
        }
        update();
        notifyChildrens();
      }

      update();
      notifyChildrens();
    } on dio.DioException catch (e) {
      if (kDebugMode) {
        print(e);
        print(e.error);
      }
    } finally {}
  }

  Future<void> pushNotification() async {
    MqttServerClient client = MqttServerClient.withPort('broker.emqx.io', 'Javaworld', 1883);
    client.keepAlivePeriod = 60;
    final connMessage = MqttConnectMessage()
        .authenticateAs('username', 'password')
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;


    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;

    const topic = 'vent2%^'; // Not a wildcard topic


    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      // Raised by the client when connection fails.
      debugPrint('EXAMPLE::client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      // Raised by the socket layer
      debugPrint('EXAMPLE::socket exception - $e');
      client.disconnect();
    }
    /// Check we are connected
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
      client.subscribe(topic, MqttQos.atMostOnce);
      /// Ok, lets try a subscription
      debugPrint('EXAMPLE::Subscribing to the venttopic1 topic');
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMess = c![0].payload as MqttPublishMessage;
        final pt = MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message,
        );

        BreathsafeModel bsm =  BreathsafeModel.fromJson(json.decode(pt));
        debugPrint('Received message:${bsm.temp} from topic: ${c[0].topic}');
        debugPrint('Received message:${bsm.humidity} from topic: ${c[0].topic}');

      });
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
        'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}',
      );
      client.disconnect();
      //exit(-1);
    }

        }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  // Disconnected callback
  void onDisconnected() {
    print('Disconnected');
  }

  /// The successful connect callback
  void onConnected() {
    print(
      'EXAMPLE::OnConnected client callback - Client connection was successful',
    );
  }

  // Ping callback
 void pong() {
   print('Ping response client callback invoked');
 }


}