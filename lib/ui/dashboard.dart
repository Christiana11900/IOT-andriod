import 'package:breathcare/ui/sensor_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../controller/breathsafe_controller.dart';

import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreen();
}

class _DashboardScreen extends State<DashboardScreen> {
  bool showGraph = false;    // toggle state

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;
    return GetX<BreathsafeController>(
        init: BreathsafeController(context: context),
    builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          // toolbarHeight: 40,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(15),

          ),
          title: Text(
            ''.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.blueAccent,
              fontSize: 20,
              fontFamily: 'inter',
              fontWeight: FontWeight.w600,
              letterSpacing: 0.14,
            ),
          ),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent, // Transparent status bar
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness
                .dark, // Dark text for status bar
          ),
          actions: [
            // toggle button top right
            IconButton(
              onPressed: () => setState(() => showGraph = !showGraph),
              icon: Icon(
                showGraph ? Icons.speed : Icons.show_chart,
                color: Colors.blueAccent,
              ),
              tooltip: showGraph ? 'Show Gauges' : 'Show Graph',
            )
          ],
        ),
        body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //SizedBox(height: 2,),
            Text(
              'BreathSafe'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 20,
                fontFamily: 'inter',
                fontWeight: FontWeight.w600,
                letterSpacing: 0.14,
              ),
            ),

            const SizedBox(height: 10),

            // toggle label
            Text(
              showGraph ? 'Graph View' : 'Gauge View',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            // show gauges or graphs
            if (!showGraph) ...[
              // your existing 3 gauges here unchanged
              _buildGauges(controller),
            ] else ...[
              SensorGraph(
                spots: controller.tempHistory,
                label: 'Temperature (°C)',
                lineColor: Colors.orange,
                minY: 0,
                maxY: 50,
              ),
              SensorGraph(
                spots: controller.humHistory,
                label: 'Humidity (%)',
                lineColor: Colors.blue,
                minY: 0,
                maxY: 100,
              ),
              SensorGraph(
                spots: controller.gasHistory,
                label: 'Air Quality (0–100)',
                lineColor: Colors.red,
                minY: 0,
                maxY: 100,
              ),
            ]


          ],
        ),
      ),
      );
    }
    );
  }

  Widget _buildGauges(BreathsafeController controller) {
    // move your existing 3 SfRadialGauge widgets here
    return Column(
      children: [
        SizedBox(height: 20,),
        Center(
          child: SizedBox(
            height: 200,
            width: 200,
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(minimum: 0,
                    maximum: 42,
                    ranges: <GaugeRange>[
                      GaugeRange(
                          startValue: 0, endValue: 14, color: Colors.orange),
                      GaugeRange(startValue: 14,
                          endValue: 32,
                          color: Colors.green),
                      GaugeRange(
                          startValue: 32, endValue: 42, color: Colors.red)
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(value: controller.field1.value)],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(widget: Container(child:
                      Text('Temperature', style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold))),
                          angle: 90, positionFactor: 0.5
                      )
                    ]
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20,),
        Center(
          child: SizedBox(
            height: 200,
            width: 200,
            child: SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(minimum: 0,
                    maximum: 150,
                    ranges: <GaugeRange>[
                      GaugeRange(
                          startValue: 0, endValue: 50, color: Colors.green),
                      GaugeRange(startValue: 50,
                          endValue: 100,
                          color: Colors.orange),
                      GaugeRange(
                          startValue: 100, endValue: 150, color: Colors.red)
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(value: controller.field2.value)],
                    annotations: const <GaugeAnnotation>[
                      GaugeAnnotation(widget: SizedBox(child:
                      Text('Humidity', style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold))),
                          angle: 90, positionFactor: 0.5
                      )
                    ]
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 200,
          width: 200,
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(minimum: 0,
                  maximum: 130,
                  showLabels: false,
                  showAxisLine: true,
                  ranges: <GaugeRange>[
                    GaugeRange(startValue: 0,
                      endValue: 40,
                      color: Colors.green,
                      label: 'Good',),
                    GaugeRange(startValue: 40,
                        endValue: 130,
                        color: Colors.orange,
                        label: 'Poor'),
                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(value: controller.field3.value)],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(widget: Container(child:
                    Text('Air Quality', style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold))),
                        angle: 90, positionFactor: 0.5
                    )
                  ]
              )
            ],
          ),
        )
      ],
    );
  }

}