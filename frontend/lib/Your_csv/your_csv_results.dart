import 'package:flutter/material.dart';
import 'package:frontend/app_bar.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class YourCSVResults extends StatefulWidget {
  YourCSVResults({@required this.data});
  final data;
  @override
  _YourCSVResultsState createState() => _YourCSVResultsState();
}

class _YourCSVResultsState extends State<YourCSVResults> {
  @override
  Widget build(BuildContext context) {
    List barData = widget.data["scores_csv"].entries.toList();
    print(barData);
    List barSeries = [];
    barData.map((mapEntry) {
      barSeries = barSeries + mapEntry.value.entries.toList();
    }).toList();
    return Scaffold(
        appBar: MyAppBar(),
        body: Center(
          child: Container(
            width: Get.width * 0.9,
            child: ListView(
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text("De-biasing results",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.apply(color: Colors.black)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Align(
                    child: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      border: TableBorder(
                          horizontalInside: BorderSide(width: 2.0),
                          verticalInside: BorderSide(width: 2.0)),
                      defaultColumnWidth: FixedColumnWidth(220),
                      children: [
                            TableRow(
                                children: [Container(child: Text(""))] +
                                    widget.data["scores_csv"]["ACF"].keys
                                        .map<Container>((key) {
                                      return Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          key,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.0),
                                        ),
                                      );
                                    }).toList())
                          ] +
                          widget.data["scores_csv"].keys
                              .map<TableRow>((keyBig) {
                            return TableRow(
                              children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        keyBig,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0),
                                      ),
                                    )
                                  ] +
                                  widget.data["scores_csv"][keyBig].values
                                      .map<Container>((value) {
                                    return Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          value.toString(),
                                          style: TextStyle(fontSize: 17.0),
                                        ));
                                  }).toList(),
                            );
                          }).toList(),
                    ),
                  ),
                ),
                Align(
                  child: Container(
                    padding: EdgeInsets.only(top: 50.0),
                    width: 1000.0,
                    height: 500.0,
                    child: SfCartesianChart(
                      legend: Legend(
                          isVisible: true,
                          legendItemBuilder: (name, series, point, index) {
                            List<String> keys = [
                              'auc_race',
                              'auc_sex',
                              'mean_difference_race',
                              'mean_difference_sex'
                            ];
                            List<MaterialColor> colors = [
                              Colors.red,
                              Colors.yellow,
                              Colors.green,
                              Colors.blue
                            ];
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: keys
                                  .map<Widget>((key) => Container(
                                        height: 60.0,
                                        width: 220.0,
                                        child: Text(
                                          key,
                                          style: TextStyle(
                                              color: colors[keys.indexOf(key)],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0),
                                        ),
                                      ))
                                  .toList(),
                            );
                          }),
                      primaryXAxis: NumericAxis(
                        majorGridLines: MajorGridLines(width: 0),
                      ),
                      primaryYAxis: NumericAxis(
                        majorGridLines: MajorGridLines(width: 0),
                      ),
                      annotations: <CartesianChartAnnotation>[
                        CartesianChartAnnotation(
                            widget: Container(
                              child: Text(
                                "ACF",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0),
                              ),
                            ),
                            coordinateUnit: CoordinateUnit.point,
                            region: AnnotationRegion.plotArea,
                            x: 1.6,
                            y: -1.1),
                        CartesianChartAnnotation(
                            widget: Container(
                              child: Text(
                                "B",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0),
                              ),
                            ),
                            coordinateUnit: CoordinateUnit.point,
                            region: AnnotationRegion.plotArea,
                            x: 5.7,
                            y: -1.14),
                        CartesianChartAnnotation(
                            widget: Container(
                              child: Text(
                                "ROC",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0),
                              ),
                            ),
                            coordinateUnit: CoordinateUnit.point,
                            region: AnnotationRegion.plotArea,
                            x: 9.7,
                            y: -1.1),
                        CartesianChartAnnotation(
                            widget: Container(
                              child: Text(
                                "RPA",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0),
                              ),
                            ),
                            coordinateUnit: CoordinateUnit.point,
                            region: AnnotationRegion.plotArea,
                            x: 13.7,
                            y: -1.1),
                      ],
                      // series: barData.map<BarSeries>((mapEntry) {
                      //   List<dynamic> values = mapEntry.value.values.toList();
                      //   String key = mapEntry.key.toString();
                      //   List<Map<String, dynamic>> maps = [];
                      //   for (var value in values) {
                      //     maps.add({key: value.toString()});
                      //   }
                      //   print(barData.indexOf(mapEntry));
                      //   return BarSeries(
                      //       dataSource: maps,
                      //       xValueMapper: (map, index) {
                      //         List<dynamic> value = map.values.toList();
                      //         return double.parse(value[0]);
                      //       },
                      //       yValueMapper: (map, index) {
                      //         List<String> smallKey = map.keys.toList();
                      //         return index + 0.1;
                      //       });
                      // }).toList(),
                      series: <CartesianSeries>[
                        BarSeries(
                          spacing: -0.5,
                          dataSource: barSeries,
                          xValueMapper: (map, index) {
                            return index + 0.1;
                          },
                          yValueMapper: (map, _) {
                            return double.parse(map.value.toString());
                          },
                          pointColorMapper: (map, int) =>
                              map.key == "mean(auc_race)"
                                  ? Colors.red
                                  : map.key == "mean(auc_sex)"
                                      ? Colors.yellow
                                      : map.key == "mean(mean_difference_race)"
                                          ? Colors.green
                                          : Colors.blue,
                        )
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Text(""),
                )
              ],
            ),
          ),
        ));
  }
}
