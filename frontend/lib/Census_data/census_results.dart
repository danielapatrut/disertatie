import 'package:flutter/material.dart';
import 'package:frontend/app_bar.dart';
import 'package:frontend/dataFetching.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CensusResults extends StatefulWidget {
  @override
  _CensusResultsState createState() => _CensusResultsState();
}

class _CensusResultsState extends State<CensusResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: FutureBuilder(
          future: mitigatingModelsCensus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List barData = (snapshot.data as Map<String, dynamic>).values.toList();
              List barSeries = [];
              barData.map((e) {
                barSeries = barSeries + e.entries.toList();
              }).toList();
              return Center(
                child: Container(
                  width: Get.width * 0.9,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Center(
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
                            defaultColumnWidth: FixedColumnWidth(220),
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
                                  'mean_difference_sex',
                                  'auc_sex'
                                ];
                                List<MaterialColor> colors = [
                                  Colors.red,
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
                                x: 0.6,
                                y: 0.65),
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
                                x: 2.6,
                                y: 0.65),
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
                                x: 4.6,
                                y: 0.65),
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
                                x: 6.6,
                                y: 0.65),
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
                                  map.key == "mean(mean_difference_sex)"
                                      ? Colors.red
                                      : Colors.blue,
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
                            child: Text(
                              "The Fairness-utility Trade-off: \n"
                              "We'll conclude this tutorial by interpreting the results in the de-biasing experiment we just ran."
                              " In the plot that we just made, we can note a few interesting things: \n"
                              "1. Removing the s_sex protected attribute (RPA) decreases mean difference by roughly 0.1% points compared to baseline (B), mean auc are approximately "
                              "the same between the two conditions. "
                              "This highlights the fact that the naive fairness-aware approach of removing sensitive attributes does not necessarily result in a fairer model.\n"
                              "2. The reject-option classification (ROC) model leads to a slight increase in mean difference compared to baseline (~0.3% points for s_sex, meaning that the prediction made by these models increase potential discrimination instead of reducing it, however ‘auc’ increased by 0.1%.\n"
                              "3. In the additive counterfactually fair (ACF) model, we see a ~0.1% point reduction in mean difference with respect to s_sex. However, unlike RPA, ‘auc’ increases up to 61% from 58%, resulting in a fairer and more accurate model.\n"
                              "These observations highlight the fact that for this dataset, reduction in ‘mean difference’ is quite small and ROC has the opposite effect in this case, increasing ‘mean difference’, instead of reducing it. With the RPA method we obtain the same result as with the ACF method, however the latter has a better performance than the Baseline model trained on Logistic Regression."
                              "This example is contradictory to the one in the German Credit Scoring set, as the ROC model behaves differently. However, the best option is still the ACF model which reduces mean difference and even increases ‘auc’, our performance utility metric.",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  height: 2),
                            ),
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
