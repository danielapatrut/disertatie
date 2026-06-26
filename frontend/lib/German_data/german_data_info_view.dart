import 'dart:convert';
import 'dart:typed_data';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:frontend/German_data/german_views_provider.dart';
import 'package:frontend/German_data/model_trained.dart';
import 'package:frontend/app_bar.dart';
import 'package:frontend/dataFetching.dart';
import 'package:get/get.dart';

class GermanDataInfoView extends StatefulWidget {
  @override
  _GermanDataInfoViewState createState() => _GermanDataInfoViewState();
}

class _GermanDataInfoViewState extends State<GermanDataInfoView> {
  GermanViewsProvider viewProvider = GermanViewsProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(),
      body: FutureBuilder(
        future: germanDataInfo(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            var data = (snapshot.data as Map<String, dynamic>)['data'];
            var creditRisk = jsonDecode(data["credit_risk_counts"]);
            var sexCounts = jsonDecode(data["sex_counts"]);
            var foreignCounts = jsonDecode(data["foreign_counts"]);
            var tenMostCorrelated = jsonDecode(data['ten_most_correlated']);
            Uint8List subplot = (snapshot.data as Map<String, dynamic>)['subplot'];
            Uint8List correlation = (snapshot.data as Map<String, dynamic>)['correlation'];
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
                                    "Measuring Potential Discrimination in the German Credit Dataset: The target  y∈{0,1} is binary variable where  y+=1 is a beneficial outcome (e.g. low credit risk) and  y−=0 is a harmful outcome (e.g. high credit risk)"
                                    "The protected attribute  s∈{d,a} is a binary variable where d=1 is some putatively disadvantaged group and a=0 is an advantaged group.\n"),
                            TextSpan(children: [
                              TextSpan(
                                  text: "\nTarget variable: credit_risk",
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
                              TyperAnimatedText('${creditRisk["1"]}',
                                  speed: Duration(milliseconds: 350))
                            ],
                            onTap: () {},
                          ),
                        ),
                      ),
                      Text(" low credit risk values"),
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
                              TyperAnimatedText('${creditRisk["0"]}',
                                  speed: Duration(milliseconds: 350))
                            ],
                            onTap: () {},
                          ),
                        ),
                      ),
                      Text(" high credit risk values"),
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
                    "For the sex values:",
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
                              TyperAnimatedText('${sexCounts["1"]}',
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
                              TyperAnimatedText('${sexCounts["0"]}',
                                  speed: Duration(milliseconds: 350))
                            ],
                            onTap: () {},
                          ),
                        ),
                      ),
                      Text(" males"),
                    ],
                  ),
                  Text(
                    "For the immigration status:",
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
                              TyperAnimatedText('${foreignCounts["1"]}',
                                  speed: Duration(milliseconds: 350))
                            ],
                            onTap: () {},
                          ),
                        ),
                      ),
                      Text(" foreign"),
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
                              TyperAnimatedText('${foreignCounts["0"]}',
                                  speed: Duration(milliseconds: 350))
                            ],
                            onTap: () {},
                          ),
                        ),
                      ),
                      Text(" citizens"),
                    ],
                  ),
                  Container(
                      height: 500.0,
                      width: 700.0,
                      child: Image.memory(subplot)),
                  Text(
                    "For the purposes of this tutorial, we'll use mean difference as our measure of potential discrimination with respect to a binary target variable credit risk and two protected classes sex and immigration status."
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
                                        data['mean_difference_sex']);
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
                              "\nprotected attribute = immigration status",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                            trailing: Padding(
                              padding: EdgeInsets.only(top: 22.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    viewProvider.meanDifferenceForeign(
                                        data['mean_difference_foreign']);
                                  },
                                  child: Icon(Icons.play_arrow)),
                            ),
                          ),
                        ),
                        Obx(() => Padding(
                              padding: EdgeInsets.only(top: 22.0),
                              child: Text(viewProvider
                                  .meanDifferenceForeign.value
                                  .split(':')[1]),
                            )),
                      ],
                    ),
                  ),
                  Text(
                    '\nThe mean differences above suggest that men and citizen workers are more likely to have low credit risks compared to women and foreign workers, respectively.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.0,
                      letterSpacing: 0.9,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    "\nThe 10 most correlated features with the target variable credit risk are:\n",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17.0,
                        letterSpacing: 0.9,
                        height: 1.2,
                        fontWeight: FontWeight.bold),
                  ),
                  Table(
                    children: tenMostCorrelated['credit_risk']
                        .keys
                        .map<TableRow>((key) {
                      return TableRow(children: [
                        Text(key),
                        Text(tenMostCorrelated['credit_risk'][key].toString()),
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
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                        height: 700.0,
                        width: 700.0,
                        child: Image.memory(correlation)),
                  ),
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
                          Get.to(ModelTrained(
                            trainedData: {
                              'lr_training_score': data['LR_training_score'],
                              'lr_accuracy': data['lr_accuracy'],
                              'lr_classification_report':
                                  data['lr_classification_report']
                            },
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
