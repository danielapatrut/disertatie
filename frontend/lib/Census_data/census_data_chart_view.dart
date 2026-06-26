import 'package:flutter/material.dart';
import 'package:frontend/app_bar.dart';
import 'package:frontend/dataFetching.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'census_views_provider.dart';

class CensusDataChartView extends StatefulWidget {
  @override
  _CensusDataChartViewState createState() => _CensusDataChartViewState();
}

class _CensusDataChartViewState extends State<CensusDataChartView> {
  CensusViewsProvider viewProvider = Get.put(CensusViewsProvider());
  int? lastSelected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: FutureBuilder(
        future: fetchCensusData(),
        builder: (_, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.connectionState == ConnectionState.none)
            return Center(
              child: Text("Something went wrong!"),
            );
          if (snapshot.hasData && snapshot.data != null) {
            List<Map<String, dynamic>> list = snapshot.data as List<Map<String, dynamic>>;
            print(list);
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
                              text: "Education years",
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          majorGridLines: MajorGridLines(width: 0),
                          axisLine: AxisLine(width: 0)),
                      selectionType: SelectionType.point,
                      onPointTapped: (PointTapArgs args) {
                      // Gestionarea lui `args.pointIndex`
                        if (args.pointIndex != null) {
                          if (args.pointIndex == lastSelected) {
                            lastSelected = null;
                            viewProvider.pointInfo({});
                          } else {
                            lastSelected = args.pointIndex;
                            viewProvider.pointInfo(list[args.pointIndex!]);
                          }
                        }
                      },
                      series: [
                        BubbleSeries(
                            minimumRadius: 4.5,
                            dataSource: list,
                            xValueMapper: (Map<String, dynamic> map, _) =>
                                map["age"],
                            yValueMapper: (Map<String, dynamic> map, _) =>
                                map["education"],
                            enableTooltip: true,
                            selectionBehavior: SelectionBehavior(
                                enable: true,
                                selectedColor: Colors.orange,
                                selectedBorderColor: Colors.black),
                            pointColorMapper: (Map<String, dynamic> map, _) =>
                                map["income_gt_50k"] > 0
                                    ? Colors.blue[900]
                                    : Colors.red[900]),
                      ],
                    ),
                  ),
                  Obx(() => viewProvider.pointInfo.value.keys.isNotEmpty
                      ? SingleChildScrollView(
                          child: Table(
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
                                    viewProvider.pointInfo.value[key]
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.black87, fontSize: 17.0),
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
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
