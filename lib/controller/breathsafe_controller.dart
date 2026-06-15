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

import 'package:fl_chart/fl_chart.dart';

class BreathsafeController extends GetxController {

  RxDouble field1 = 0.0.obs;
  RxDouble field2 = 0.0.obs;
  RxDouble field3 = 0.0.obs;
  var pongCount = 0; // Pong counter
  var pingCount = 0; // Ping counter
  late NotificationUtil notificationUtil;
  BuildContext? context;
  Timer? timer;

  RxList<FlSpot> tempHistory    = <FlSpot>[].obs;
  RxList<FlSpot> humHistory     = <FlSpot>[].obs;
  RxList<FlSpot> gasHistory     = <FlSpot>[].obs;
  var dataIndex = 0;             // x-axis counter

// Max points to show on graph
  static const int MAX_POINTS = 20;

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
    try {
      dio.Response response = await Repository.temp();
      final feeds = List.from(response.data['feeds']);

      if (feeds.isNotEmpty) {
        final lastFeed = feeds.last;           // get only last entry
        if (lastFeed['field1'] != null) {      // only update if not null
          field1.value = double.parse(lastFeed['field1']);
         // debugPrint('Temp updated: ${field1.value}');
          tempHistory.add(FlSpot(dataIndex.toDouble(), field1.value));
          if (tempHistory.length > MAX_POINTS) tempHistory.removeAt(0);
          dataIndex++;
          debugPrint('Temp: ${field1.value} | History: ${tempHistory.length} points');
        } else {
          debugPrint('No new temp data, keeping: ${field1.value}');
          // add to graph history
        }
      }

      update();
      notifyChildrens();
    } on dio.DioException catch (e) {
      debugPrint('feed1 error: $e');
      // value stays unchanged on error ✅
    }
  }

  void requestPermission() {
    notificationUtil.requestPermissionToSendNotifications(context: context);
  }

  Future<void> feed2() async {
    try {
      dio.Response response = await Repository.hum();
      final feeds = List.from(response.data['feeds']);

      if (feeds.isNotEmpty) {
        final lastFeed = feeds.last;
        if (lastFeed['field2'] != null) {
          field2.value = double.parse(lastFeed['field2']);
         // debugPrint('Humidity updated: ${field2.value}');
          humHistory.add(FlSpot(dataIndex.toDouble(), field2.value));
          if (humHistory.length > MAX_POINTS) humHistory.removeAt(0);
          dataIndex++;
          debugPrint('Temp: ${field2.value} | History: ${humHistory.length} points');
        } else {
          debugPrint('No new humidity data, keeping: ${field2.value}');
          // add to graph history
          humHistory.add(FlSpot(dataIndex.toDouble(), field2.value));
          if (humHistory.length > MAX_POINTS) {
            humHistory.removeAt(0);       // keep rolling window
          }
          dataIndex++;
          debugPrint('Humidity: ${field2.value} | History: ${humHistory.length} points');
        }
      }
      update();
      notifyChildrens();
    } on dio.DioException catch (e) {
      debugPrint('feed2 error: $e');
    }
  }

  Future<void> feed3() async {
    try {
      dio.Response response = await Repository.gas_level();
      final feeds = List.from(response.data['feeds']);

      if (feeds.isNotEmpty) {
        final lastFeed = feeds.last;
        if (lastFeed['field3'] != null) {
          field3.value = double.parse(lastFeed['field3']);  // ✅ fixed field3
         // debugPrint('Gas updated: ${field3.value}');
          gasHistory.add(FlSpot(dataIndex.toDouble(), field3.value));
          if (gasHistory.length > MAX_POINTS) gasHistory.removeAt(0);
          dataIndex++;
          debugPrint('Temp: ${field3.value} | History: ${gasHistory.length} points');
          if (field3.value > 50) {
            createBasicNotification(
              title: 'BreathSafe',
              content: 'Unhealthy air detected!',
            );
          }
        } else {
          debugPrint('No new gas data, keeping: ${field3.value}');
          // add to graph history
          gasHistory.add(FlSpot(dataIndex.toDouble(), field3.value));
          if (gasHistory.length > MAX_POINTS) {
            gasHistory.removeAt(0);       // keep rolling window
          }
          dataIndex++;
          debugPrint('Gas: ${field3.value} | History: ${gasHistory.length} points');
        }
      }
      update();
      notifyChildrens();
    } on dio.DioException catch (e) {
      debugPrint('feed3 error: $e');
    }
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