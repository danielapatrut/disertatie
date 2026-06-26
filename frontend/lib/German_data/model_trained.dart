import 'package:flutter/material.dart';
import 'package:frontend/German_data/german_views_provider.dart';
import 'package:frontend/German_data/results.dart';
import 'package:frontend/app_bar.dart';
import 'package:frontend/dataFetching.dart';
import 'package:get/get.dart';
import 'dart:typed_data';

class ModelTrained extends StatefulWidget {
  ModelTrained({required this.trainedData});
  final Map<String, dynamic> trainedData;
  @override
  _ModelTrainedState createState() => _ModelTrainedState();
}

class _ModelTrainedState extends State<ModelTrained> {
  GermanViewsProvider viewProvider = GermanViewsProvider();
  @override
  Widget build(BuildContext context) {
    print(widget.trainedData['lr_training_score']);
    print(widget.trainedData['lr_accuracy']);
    print(widget.trainedData['lr_classification_report']);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(),
      body: FutureBuilder(
          future: getConfusionMatrix(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done)
              return Center(
                child: Container(
                  width: Get.width * 0.9,
                  child: ListView(
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: "Baseline model trained using ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.apply(color: Colors.black)),
                              TextSpan(
                                  text: "Logistic Regression",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.apply(
                                          decoration: TextDecoration.underline,
                                          color: Colors.blue[900])),
                            ]),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 300,
                            child: ListTile(
                              title: Text(
                                "\nSee training score:",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20.0),
                              ),
                              trailing: Padding(
                                padding: EdgeInsets.only(top: 25.0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      viewProvider.trainingScore(widget
                                          .trainedData['lr_training_score']
                                          .toString());
                                    },
                                    child: Icon(Icons.play_arrow)),
                              ),
                            ),
                          ),
                          Obx(() => Padding(
                                padding: EdgeInsets.only(top: 25.0),
                                child: Text(
                                  viewProvider.trainingScore.value
                                      .split(':')[1],
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    backgroundColor: viewProvider
                                                .trainingScore.value.length >
                                            2
                                        ? Colors.grey[350]
                                        : Colors.transparent,
                                  ),
                                ),
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 300,
                            child: ListTile(
                              title: Text(
                                "\nThe  accuracy in the validation set is:",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20.0),
                              ),
                              trailing: Padding(
                                padding: EdgeInsets.only(top: 25.0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      viewProvider.accuracy(widget
                                          .trainedData['lr_accuracy']
                                          .toString());
                                    },
                                    child: Icon(Icons.play_arrow)),
                              ),
                            ),
                          ),
                          Obx(() => Padding(
                                padding: EdgeInsets.only(top: 25.0),
                                child: Text(
                                  viewProvider.accuracy.value.split(':')[1],
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    backgroundColor:
                                        viewProvider.accuracy.value.length > 2
                                            ? Colors.grey[350]
                                            : Colors.transparent,
                                  ),
                                ),
                              )),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 300,
                          child: ListTile(
                            title: Text(
                              "\nSee classification report:",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20.0),
                            ),
                            trailing: Padding(
                              padding: EdgeInsets.only(top: 25.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    viewProvider.classificationReport(widget
                                        .trainedData['lr_classification_report']
                                        .toString());
                                  },
                                  child: Icon(Icons.play_arrow)),
                            ),
                          ),
                        ),
                      ),
                      Obx(() => Padding(
                            padding: EdgeInsets.only(top: 25.0),
                            child: Text(
                              viewProvider.classificationReport.value,
                              style: TextStyle(
                                fontSize: 16.0,
                                backgroundColor: viewProvider
                                            .classificationReport.value.length >
                                        2
                                    ? Colors.grey[350]
                                    : Colors.transparent,
                                wordSpacing: 4,
                              ),
                            ),
                          )),
                      Text(
                        "\nConfusion matrix on the Logistic Regression model",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge 
                            ?.apply(color: Colors.black),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          height: 400.0,
                          width: 600.0,
                          child: snapshot.data != null && snapshot.data is Uint8List
                              ? Image.memory(
                                  snapshot.data as Uint8List, // Cast explicit la Uint8List
                                )
                              : Center(
                                  child: Text("No data available or invalid format"),
                                ),
                        ),
                      ),
                      Center(
                        child: Text("\n\nPostprocessing de-biasing experiment",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.apply(color: Colors.black)),
                      ),
                      Center(
                        child: Text(
                          "\nIn this experiment, we specify three conditions, all using LogisticRegression as the classifier to keep things simple:\n",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      Align(
                        child: Table(
                          columnWidths: {
                            0: FixedColumnWidth(50.0),
                          },
                          children: checkBoxes.map<TableRow>((checkBox) {
                            int index = checkBoxes.indexOf(checkBox);
                            return TableRow(children: [
                              TableCell(
                                  child: Checkbox(
                                      value: true, onChanged: (value) {})),
                              index == 2 || index == 3
                                  ? TableCell(
                                      child: InkWell(
                                      onTap: () {
                                        Get.defaultDialog(
                                          titleStyle: TextStyle(
                                              color: Colors.transparent),
                                          content: Text(tooltips[3 - index]),
                                        );
                                      },
                                      child: Text(checkBox,
                                          style: TextStyle(fontSize: 16.0)),
                                    ))
                                  : TableCell(
                                      child: Text(checkBox,
                                          style: TextStyle(fontSize: 16.0))),
                            ]);
                          }).toList(),
                        ),
                      ),
                      Text(
                        '\nIn this toy example, we\'ll be using mean_difference as our \"fairness\" metric, and area under the curve auc as our \"utility\" metric.',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 40.0),
                        child: Align(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(50.0, 60.0)),
                            onPressed: () async {
                              Get.to(Results());
                            },
                            child: Text(
                              "Start de-biasing experiment",
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            if (snapshot.connectionState == ConnectionState.none)
              return Center(
                child: Text("Something went wrong!"),
              );
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

List<String> checkBoxes = [
  'Baseline ( B ): classifier trained on all available input variables, including protected attributes.',
  'Remove Protected Attribute ( RPA ): classifier where input variables do not contain protected attributes. This is the naive fairness-aware approach.',
  'Reject-Option Classification ( ROC ): classifier using the reject-option classification method.',
  'Additive Counterfactually Fair Model ( ACF ): classifier using the additive counterfactually fair method.'
];
List<String> tooltips = [
  "ROC works by training an initial classifier on your dataset D, generating predicted probabilities on the test set, and then computing the "
      "proximity of each prediction to the decision boundary learned by the classifier."
      "Within this boundary defined by the critical region threshold  𝜃, where  0.5<𝜃<1,  Xd are assigned a label  y=1 and  Xa are assigned as "
      "𝑦=0 , where Xd are disadvantaged observations and Xa are advantaged observations.",
  "ACF,  within the framework of counterfactual fairness, is the idea that we model the correlations between s and features in X by"
      "training linear models to predict each feature Xj using s as input. Then, we can compute the residuals  𝜖ij between predicted and true feature values for each observation i and feature j. The final"
      "model is then trained on  𝜖𝑖𝑗 as features to predict  𝑦."
];
