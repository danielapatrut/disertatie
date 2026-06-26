import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/app_bar.dart';
import 'package:frontend/dataFetching.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

class Results extends StatefulWidget {
  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: FutureBuilder(
          future: mitigatingModelsGerman(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List barData = (snapshot.data as Map<String, dynamic>).values.toList();
              List barSeries = [];
              barData.map((e) {
                barSeries = barSeries + e.entries.toList();
              }).toList();
              return Center(
                child: Container(
                  width: Get.width * 0.90,
                  child: ListView(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text("De-biasing results",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.apply(color: Colors.black)),
                        ),
                      ),
                      //Table
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Align(
                          child: Table(
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            border: TableBorder(
                                horizontalInside: BorderSide(width: 2.0),
                                verticalInside: BorderSide(width: 2.0)),
                            defaultColumnWidth: FixedColumnWidth(260),
                            children: [
                                  TableRow(
                                      children: [Container(child: Text(""))] +
                                          (snapshot.data as Map<String, dynamic>)["ACF"].keys
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
                                (snapshot.data as Map<String, dynamic>).keys.map<TableRow>((keyBig) {
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
                                        (snapshot.data as Map<String, dynamic>)[keyBig].values
                                            .map<Container>((value) {
                                          return Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                value.toString(),
                                                style:
                                                    TextStyle(fontSize: 17.0),
                                              ));
                                        }).toList(),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),

                      Align(
                        child: SfCartesianChart(
                          legend: Legend(
                              isVisible: true,
                              legendItemBuilder: (name, series, point, index) {
                                List<String> keys = [
                                  'auc_sex',
                                  'mean_difference_foreign',
                                  'auc_foreign',
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
                                                  color:
                                                      colors[keys.indexOf(key)],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0),
                                            ),
                                          ))
                                      .toList(),
                                );
                              }),
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
                                y: -0.03),
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
                                y: -0.03),
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
                                y: -0.03),
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
                                y: -0.03),
                          ],
                          series: <ChartSeries>[
                            BarSeries(
                              dataSource: barSeries,
                              xValueMapper: (map, index) {
                                return index + 0.1;
                              },
                              yValueMapper: (map, _) {
                                print(map.value);
                                return double.parse(map.value.toString());
                              },
                              pointColorMapper: (map, int) =>
                                  map.key == "mean(auc_sex)"
                                      ? Colors.red
                                      : map.key == "mean(mean_difference_sex)"
                                          ? Colors.blue
                                          : map.key == "mean(auc_foreign)"
                                              ? Colors.green
                                              : Colors.yellow,
                            )
                          ],
                        ),
                      ),

                      //TEXT
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Center(
                          child: Container(
                            width: Get.width * 0.9,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Text(
                                "The Fairness-utility Trade-off: \n"
                                "We'll conclude this tutorial by interpreting the results in the de-biasing experiment we just ran."
                                " In the plot that we just made, we can note a few interesting things: \n"
                                "1.Removing the s_sex protected attribute (RPA) decreases mean difference by roughly 3% points compared to baseline (B), mean auc are approximately the same between the two conditions with just a slight reduction of 1% in RPA.\n"
                                "There reduction in mean difference when removing the s_foreign is of ~1% "
                                "variable (RPA) compared to baseline (B), highlighting the fact that the naive fairness-aware approach of removing sensitive attributes does not necessarily result in a fairer model.\n"
                                "2.The reject-option classification (ROC) model lead to a slight reduction in mean difference compared to baseline (~3% points for s_sex "
                                "and no reduction for s_foreign, meaning that the prediction made by these models reduce potential discrimination slightly, but at the cost of about 4% points of auc.\n"
                                "3.In the additive counterfactually fair (ACF) model, we see a ~6.3% point reduction in mean difference with respect to s_sex and an increase of ~1% point with respect to s_foreign"
                                ". However, unlike ROC, we maintain an auc of about 62%, even though we're making fairer predictions.\n"
                                "Note that in the case of ACF, we get a negative mean difference with respect to s_sex, meaning that we're actually now slightly favoring women over men when predicting the beneficial low credit risk outcome.\n"
                                "These observations highlight the fact that with certain methods like ROC, we see evidence of the fairness-utility tradeoff, but with others, like ACF, it's possible to produce a model that reduces potential discrimination in the predictions while preserving its utility with respect to some measure of predictive power (in this case, auc).",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    height: 2),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "References",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge
                                  ?.apply(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.0,
                                    letterSpacing: 0.9,
                                    height: 2.0),
                                children: [
                                  TextSpan(text: "[1] "),
                                  TextSpan(
                                    style: TextStyle(
                                        color: Colors.blue[900],
                                        fontWeight: FontWeight.bold),
                                    text:
                                        "https://github.com/cosmicBboy/themis-ml/blob/master/examples/tutorial_fat*_2018.ipynb/",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        await launch(
                                            "https://github.com/cosmicBboy/themis-ml/blob/master/examples/tutorial_fat*_2018.ipynb/");
                                      },
                                  )
                                ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: CircularProgressIndicator(),
              );
            return Center(
              child: Text("Error"),
            );
          }),
    );
  }
}
