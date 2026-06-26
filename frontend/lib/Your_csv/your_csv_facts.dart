import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Your_csv/your_csv_model_trained.dart';
import 'package:frontend/Your_csv/your_csv_provider.dart';
import 'package:frontend/app_bar.dart';
import 'package:frontend/dataFetching.dart';
import 'package:get/get.dart';

class CSVFacts extends StatefulWidget {
  CSVFacts({@required this.data, this.pickedFile});
  final pickedFile;
  final data;
  @override
  _CSVFactsState createState() => _CSVFactsState();
}

class _CSVFactsState extends State<CSVFacts> {
  YourCSVProvider viewProvider = YourCSVProvider();
  @override
  Widget build(BuildContext context) {
    final fairness_analysis = widget.data["fairness_analysis"];
    final five_most = jsonDecode(fairness_analysis["five_most"])["prediction"];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(),
      body: FutureBuilder(
        future: yourCsvPlot(widget.pickedFile),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // var data = snapshot.data['data'];
            // var data = (snapshot.data as Map<String, dynamic>)['data'];
            Uint8List subplot = (snapshot.data as Map<String, dynamic>)['subplot'];
            Uint8List heatmap = (snapshot.data as Map<String, dynamic>)['heatmap'];
            return Center(
              child: Container(
                width: Get.width * 0.85,
                child: ListView(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: Text(
                        "Data Set Features",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.apply(color: Colors.black),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontSize: 17.0, letterSpacing: 0.9, height: 1.2),
                          children: [
                            TextSpan(
                                text:
                                    "Measuring Potential Discrimination in the Dataset: The target  y∈{0,1} is binary variable where  y+=1 is a beneficial outcome and  y−=0 is a harmful outcome "
                                    "The protected attribute  s∈{d,a} is a binary variable where d=1 is some putatively advantaged group and a=0 is an disadvantaged group.\n"),
                            TextSpan(children: [
                              TextSpan(
                                  text: "\nTarget variable: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                          ]),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 50.0,
                        child: DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TyperAnimatedText(
                                  '${fairness_analysis['favourable_results']}',
                                  speed: Duration(milliseconds: 350))
                            ],
                            onTap: () {},
                          ),
                        ),
                      ),
                      Text("positive outcomes"),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 50.0,
                        child: DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TyperAnimatedText(
                                  '${fairness_analysis['unfavourable_results']}',
                                  speed: Duration(milliseconds: 350))
                            ],
                            onTap: () {},
                          ),
                        ),
                      ),
                      Text("negative outcomes"),
                    ],
                  ),
                  Text(
                    "\nConsidering the protected attributes, the distribution is as follows:\n",
                    style: TextStyle(
                      fontSize: 17.0,
                      letterSpacing: 0.9,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    "For the sex values",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        letterSpacing: 0.9,
                        height: 1.2,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 50.0,
                        child: DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TyperAnimatedText(
                                  '${fairness_analysis['disadvantaged_sex_counts']}',
                                  speed: Duration(milliseconds: 350))
                            ],
                            onTap: () {},
                          ),
                        ),
                      ),
                      Text(" females"),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 50.0,
                        child: DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TyperAnimatedText(
                                  '${fairness_analysis['advantaged_sex_counts']}',
                                  speed: Duration(milliseconds: 350))
                            ],
                            onTap: () {},
                          ),
                        ),
                      ),
                      Text(" males\n"),
                    ],
                  ),
                  Text(
                    "For the race values",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        letterSpacing: 0.9,
                        height: 1.2,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 50.0,
                        child: DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TyperAnimatedText(
                                  '${fairness_analysis['disadvantaged_counts_race']}',
                                  speed: Duration(milliseconds: 350))
                            ],
                            onTap: () {},
                          ),
                        ),
                      ),
                      Text("in disadvantaged category"),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 50.0,
                        child: DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TyperAnimatedText(
                                  '${fairness_analysis['advantaged_counts_race']}',
                                  speed: Duration(milliseconds: 350))
                            ],
                            onTap: () {},
                          ),
                        ),
                      ),
                      Text(" in advantaged category"),
                    ],
                  ),
                  Container(
                      height: 500.0,
                      width: 700.0,
                      child: Image.memory(subplot)),
                  Text(
                    "For the purposes of this tutorial, we'll use mean difference as our measure of potential discrimination with respect to a binary target variable and two protected classes sex and race."
                    "This metric belongs to a class of group-level discrimination measures that captures differences in outcome between populations, e.g. female vs. male",
                    style: TextStyle(
                        fontSize: 17.0,
                        letterSpacing: 0.9,
                        height: 1.2,
                        color: Colors.black),
                  ),
                  Text(
                    "\nSee mean difference scores:",
                    style: TextStyle(
                        fontSize: 17.0,
                        letterSpacing: 0.9,
                        height: 1.2,
                        color: Colors.black),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Container(
                          width: 400,
                          child: ListTile(
                            title: Text(
                              "\nprotected attribute = sex",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            trailing: Padding(
                              padding: EdgeInsets.only(top: 22.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    viewProvider.meanDifferenceSex(
                                        fairness_analysis[
                                            "mean_difference_sex"]);
                                  },
                                  child: Icon(Icons.play_arrow)),
                            ),
                          ),
                        ),
                        Obx(() => Padding(
                              padding: EdgeInsets.only(top: 22.0),
                              child: Text(viewProvider.meanDifferenceSex.value
                                  .split(':')[1]),
                            )),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Container(
                          width: 400,
                          child: ListTile(
                            title: Text(
                              "\nprotected attribute = race",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            trailing: Padding(
                              padding: EdgeInsets.only(top: 22.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    viewProvider.meanDifferenceRace(
                                        fairness_analysis[
                                            'mean_difference_race']);
                                  },
                                  child: Icon(Icons.play_arrow)),
                            ),
                          ),
                        ),
                        Obx(() => Padding(
                              padding: EdgeInsets.only(top: 22.0),
                              child: Text(viewProvider.meanDifferenceRace.value
                                  .split(':')[1]),
                            )),
                      ],
                    ),
                  ),
                  Text(
                    "\nThe 5 most correlated features with the target variable are:\n",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        letterSpacing: 0.9,
                        height: 1.2,
                        fontWeight: FontWeight.bold),
                  ),
                  Table(
                    children: five_most.keys.map<TableRow>((key) {
                      return TableRow(children: [
                        Text(key),
                        Text(five_most[key].toString()),
                      ]);
                    }).toList(),
                  ),
                  Text(
                    '\nCorrelations',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0),
                  ),
                  Container(
                      height: 500.0,
                      width: 700.0,
                      child: Image.memory(heatmap)),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      "\nWe start by training our baseline model using Logistic Regression, a classifier trained on all input variable, including protected attributes.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        letterSpacing: 0.9,
                        height: 1.2,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40.0, bottom: 40.0),
                    child: Align(
                        child: ElevatedButton(
                      onPressed: () {
                        Future.delayed(Duration(seconds: 1), () {
                          Get.back();
                          Get.to(YourCSVModelTrained(
                            trainedData: widget.data,
                            pickedFile: widget.pickedFile,
                          ));
                        });
                        Get.defaultDialog(
                            barrierDismissible: false,
                            title: '',
                            content: SingleChildScrollView(
                              child: Container(
                                child: Center(
                                  child: Column(
                                    children: [
                                      CircularProgressIndicator(),
                                      Text("training model..."),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                      },
                      child: Text(
                        "Train model",
                        style: TextStyle(fontSize: 17.0),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(200.0, 70.0)),
                    )),
                  ),
                ]),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.none)
            return Center(
              child: Text("Something went wrong"),
            );
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
