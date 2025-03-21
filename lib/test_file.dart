//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TestChartRealTime extends StatefulWidget {
  const TestChartRealTime({super.key});

  @override
  State<TestChartRealTime> createState() => _TestChartRealTimeState();
}

class _TestChartRealTimeState extends State<TestChartRealTime> {
  List<_ChartData> chartData = [
    _ChartData(timestamp: DateTime(2022, 10, 12, 8), tempdata: 30),
    _ChartData(timestamp: DateTime(2022, 10, 13), tempdata: 30),
    _ChartData(timestamp: DateTime(2022, 10, 14), tempdata: 28),
    _ChartData(timestamp: DateTime(2022, 10, 15), tempdata: 34),
    _ChartData(timestamp: DateTime(2022, 10, 16, 16, 32), tempdata: 33),
    _ChartData(timestamp: DateTime(2022, 10, 17), tempdata: 32),
    _ChartData(timestamp: DateTime(2022, 10, 18), tempdata: 22),
    _ChartData(timestamp: DateTime(2022, 10, 19), tempdata: 24),
  ];

  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void getData() {
    Query starCountRef =
        FirebaseDatabase.instance.ref('Data/da6J63iVOSh2YdTFrHP22NPQmWw1/readings').limitToLast(100).orderByKey();
      //FirebaseDatabase.instance.ref('data').limitToLast(100).orderByKey();

    starCountRef.onValue.listen((DatabaseEvent event) {
      print("lay du lieu ...");

      //print(data);
      setState(() {
        Map data = event.snapshot.value as Map;
        chartData = data.entries
            .map((e) => _ChartData(
               
                timestamp:
                    DateTime.fromMillisecondsSinceEpoch(e.value['time'] * 1000),
                speed: e.value['speed'],
                depth: e.value['depth'],
                tempdata: e.value['tempdata'],
                //depth:e.value['int']
                ))
            .toList();
        
       
        //print(data);
        print('da lay du lieu ....');

        //print(e.value['time']);
      });
      chartData.sort((a, b) => a.timestamp!.compareTo(b.timestamp!)); 
      print(chartData.first.timestamp);
      //print(chartData[1].timestamp);
    });
  }

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      zoomMode: ZoomMode.x,
      enablePanning: true,
    );
    getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              //Text(""),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 40),
                      child: Row(
                        children: [
                          Text(
                            "Channel1 ",// + chartData.last.depth.toString(),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.blue),
                          ),
                          SizedBox(
                            width: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  SizedBox(
                    height: 200,
                    child: SfCartesianChart(
                        zoomPanBehavior: _zoomPanBehavior,
                        primaryXAxis:
                            //DateTimeAxis(intervalType: DateTimeIntervalType.hours),
                            DateTimeAxis(
                          dateFormat: DateFormat('dd-MM hh:mm'),
                          //intervalType: DateTimeIntervalType.seconds,
                          //interval: 20,
                          rangePadding: ChartRangePadding.additional,
                        ),
                        primaryYAxis: const NumericAxis(
                          minimum: 0,
                          maximum: 200,
                        ),
                        axes: const <ChartAxis>[
                          NumericAxis(
                            name: 'yAxis',
                            minimum: 10,
                            maximum: 20,
                          ),
                          NumericAxis(
                            minimum: 0,
                            maximum: 20,
                          )
                        ],
                        series:<CartesianSeries<_ChartData,DateTime>> [
                          LineSeries<_ChartData, DateTime>(
                            color: Colors.red,
                            animationDuration: 0,
                            dataSource: chartData,
                            xValueMapper: (_ChartData data, _) =>
                                data.timestamp,
                            yValueMapper: (_ChartData data, _) => data.depth,
                            name: 'oC',
                            //yAxisName: 'yAxis'
                          ),
                        ],
                        ),
                  ),
                ],
              ),

              Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 40),
                      child: Text(
                        "Channel2 ",// + chartData.last.speed.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  SizedBox(
                    height: 200,
                    child: SfCartesianChart(
                        zoomPanBehavior: _zoomPanBehavior,
                        primaryXAxis: DateTimeAxis(
                          dateFormat: DateFormat('HH:mm'),
                        ),
                        primaryYAxis: const NumericAxis(
                          minimum: 0,
                          maximum: 50,
                        ),
                        series:<CartesianSeries<_ChartData,DateTime>> [
                          LineSeries<_ChartData, DateTime>(
                            color: Colors.red,
                            animationDuration: 0,
                            dataSource: chartData,
                            xValueMapper: (_ChartData data, _) =>
                                data.timestamp,
                            yValueMapper: (_ChartData data, _) => data.speed,
                            name: 'oC',
                            //yAxisName: 'yAxis'
                          ),
                        ],
                        ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 40),
                      child: Text(
                        "Channel3 " ,//+ chartData.last.tempdata.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.green),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  SizedBox(
                    height: 200,
                    child: SfCartesianChart(
                        zoomPanBehavior: _zoomPanBehavior,
                        primaryXAxis:
                            //DateTimeAxis(intervalType: DateTimeIntervalType.hours),
                            DateTimeAxis(
                          dateFormat: DateFormat('dd-MM hh:mm'),
                          //intervalType: DateTimeIntervalType.seconds,
                          //interval: 20,
                          rangePadding: ChartRangePadding.additional,
                        ),
                        primaryYAxis: const NumericAxis(
                          minimum: 0,
                          maximum: 400,
                        ),
                        series:<CartesianSeries<_ChartData,DateTime>> [
                          LineSeries<_ChartData, DateTime>(
                            color: Colors.red,
                            animationDuration: 0,
                            dataSource: chartData,
                            xValueMapper: (_ChartData data, _) =>
                                data.timestamp,
                            yValueMapper: (_ChartData data, _) => data.tempdata,
                            name: 'oC',
                            //yAxisName: 'yAxis'
                          ),
                        ],
                        ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

class _ChartData {
  _ChartData({this.timestamp, this.tempdata, this.speed, this.depth});
  final DateTime? timestamp;
  final dynamic tempdata; //tension
  final dynamic speed;
  final dynamic depth;
  //final dynamic tension;
}


