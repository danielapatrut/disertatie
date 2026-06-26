import 'package:flutter/material.dart';
import 'package:frontend/app_bar.dart';
import 'package:frontend/dataFetching.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'german_views_provider.dart';

class GermanDataChartView extends StatefulWidget {
  @override
  _GermanDataChartViewState createState() => _GermanDataChartViewState();
}

class _GermanDataChartViewState extends State<GermanDataChartView> {
  GermanViewsProvider viewProvider = Get.put(GermanViewsProvider());
  int? lastSelected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: FutureBuilder(
        future: fetchGermanData(),
        builder: (_, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.connectionState == ConnectionState.none)
            return Center(
              child: Text("Something went wrong!"),
            );
          if (snapshot.hasData) {
            List<Map<String, dynamic>> list = snapshot.data as List<Map<String, dynamic>>; // Cast explicit
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: Get.height,
                    width: Get.width * 0.65,
                    child: SfCartesianChart(
                      primaryXAxis: NumericAxis(
                          title: AxisTitle(
                              text: "Age in years",
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          majorGridLines: MajorGridLines(width: 0),
                          axisLine: AxisLine(width: 0)),
                      primaryYAxis: NumericAxis(
                          title: AxisTitle(
                              text: "Credit amount",
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          majorGridLines: MajorGridLines(width: 0),
                          axisLine: AxisLine(width: 0)),
                      selectionType: SelectionType.point,
                      onPointTapped: (PointTapArgs args) {
                        if (args.pointIndex != null) { // Verificare pentru `args.pointIndex`
                          if (args.pointIndex == lastSelected) {
                            lastSelected = null;
                            viewProvider.pointInfo({});
                          } else {
                            lastSelected = args.pointIndex;
                            viewProvider.pointInfo(list[args.pointIndex!]); // Folosește `!` pentru a forța accesul
                          }
                        }
                      },
                      series: [
                        BubbleSeries(
                            minimumRadius: 4.5,
                            dataSource: list,
                            xValueMapper: (Map<String, dynamic> map, _) =>
                                map["age_in_years"],
                            yValueMapper: (Map<String, dynamic> map, _) =>
                                map["credit_amount"],
                            enableTooltip: true,
                            selectionBehavior: SelectionBehavior(
                                enable: true,
                                selectedColor: Colors.orange,
                                selectedBorderColor: Colors.black),
                            pointColorMapper: (Map<String, dynamic> map, _) =>
                                map["credit_risk"] > 0
                                    ? Colors.blue[900]
                                    : Colors.red[900]),
                      ],
                    ),
                  ),
                  Obx(() => viewProvider.pointInfo.value.keys.isNotEmpty
                      ? Table(
                          border: TableBorder(
                              verticalInside: BorderSide(width: 0.7),
                              horizontalInside: BorderSide(width: 0.5)),
                          defaultColumnWidth: FixedColumnWidth(500),
                          children: viewProvider.pointInfo.value.keys
                              .map<TableRow>((key) {
                            return TableRow(children: [
                              Text(
                                key,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  viewProvider.pointInfo.value[key].toString(),
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 17.0),
                                ),
                              ),
                            ]);
                          }).toList(),
                        )
                      : Text(
                          "Select a data point to see info about it",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.apply(color: Colors.black),
                        )),
                ],
              ),
            );
          }
          return Center(
            child: Text("Something went wrong"),
          );
        },
      ),
    );
  }
}
