import 'package:flutter/material.dart';
import 'package:frontend/Your_csv/your_csv_analysis.dart';
import 'package:frontend/Your_csv/your_csv_facts.dart';
import 'package:get/get.dart';

class YourCsvView extends StatefulWidget {
  YourCsvView({this.filename, this.yourCsvData, this.pickedFile});
  final yourCsvData;
  final filename;
  final pickedFile;
  @override
  _YourCsvViewState createState() => _YourCsvViewState();
}

class _YourCsvViewState extends State<YourCsvView> {
  List<String> metrics = [
    "Disparate Impact",
    "Group Fairness",
    "Fairness of Error Distribution"
  ];

  List<bool> selectedMetrics = [true, true, true];
  @override
  Widget build(BuildContext context) {
    print(widget.yourCsvData);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Align(
          alignment: Alignment.topCenter,
          child: ListView(
            shrinkWrap: true,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Text("Data set Fairness",
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.apply(color: Colors.black)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "See difference between groups and measure fairness",
                    style: Theme.of(context).textTheme.bodyLarge ,
                  ),
                ),
              ),
              Align(
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    defaultColumnWidth: FixedColumnWidth(300.0),
                    border: TableBorder(horizontalInside: BorderSide(width: 1)),
                    children: [
                      TableRow(
                        children: [
                          Text('Attribute'),
                          Text('Protected attributes')
                        ],
                      ),
                      TableRow(children: [
                        Row(
                          children: [
                            Checkbox(value: true, onChanged: (value) {}),
                            Text('Race')
                          ],
                        ),
                        Text('African-American'),
                      ]),
                      TableRow(children: [
                        Row(
                          children: [
                            Checkbox(value: true, onChanged: (value) {}),
                            Text('Sex')
                          ],
                        ),
                        Text('Female'),
                      ]),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: Get.width * 0.2),
                      child: Table(
                        defaultColumnWidth: FixedColumnWidth(Get.width * 0.3),
                        children: [
                              TableRow(children: [
                                Text(
                                  "Select metrics",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.apply(color: Colors.black),
                                ),
                              ])
                            ] +
                            metrics.map<TableRow>((metric) {
                              return TableRow(children: [
                                CheckboxListTile(
                                  value:
                                      selectedMetrics[metrics.indexOf(metric)],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedMetrics[metrics.indexOf(metric)] =
                                          !selectedMetrics[
                                              metrics.indexOf(metric)];
                                    });
                                  },
                                  title: Text(metric),
                                )
                              ]);
                            }).toList(),
                      ),
                    ),
                    Container(
                      width: Get.width * 0.4,
                      height: Get.height * 0.4,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'images/Theme-navy_FATE_header_12_2019_1920x720-800x550.png'),
                              fit: BoxFit.fill,
                              alignment: Alignment.center)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Align(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: Size(20, 50)),
                    child: Text("Generate fairness report"),
                    onPressed: () {
                      Get.to(YourCsvAnalysis(
                        fileName: widget.filename,
                        data: widget.yourCsvData,
                      ));
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Align(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: Size(20, 50)),
                    child: Text("De-biasing experiment"),
                    onPressed: () {
                      Get.to(CSVFacts(
                        data: widget.yourCsvData,
                        pickedFile: widget.pickedFile,
                      ));
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
