import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Home_view/home_view.dart';
import 'package:frontend/app_bar.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'common_needs.dart';
import 'installation.dart';

class LearnMore extends StatefulWidget {
  @override
  _LearnMoreState createState() => _LearnMoreState();
}

class _LearnMoreState extends State<LearnMore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Container(
          width: Get.width * 0.6,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.0,
                            letterSpacing: 0.9,
                            height: 1.4),
                        children: [
                          TextSpan(
                              text:
                                  "Discrimination is one of the most common contemporary social problems. It can vary broadly, being present everywhere around us and impacting our lives in the most negative ways, despite the many movements taking place to combat it. \n\nIntentionally or not, it can also happen for an AI system to discriminate against different categories of people. This results in unfair decisions taken and adopted in several areas, among which we can mention personnel selection discrimination, racial profiling, discrimination in credit and discrimination in wages distribution.[1] "
                                  "\n\nClassification models make no exception and tend to discriminate either directly or indirectly, because using historical data also brings social preconceptions along with it. These discriminatory rules can be very hard to identify, even disguised within the model, because they might have been introduced accidentally. "
                                  "Discrimination can be split into direct and indirect as follows: direct discrimination takes a dataset with discriminatory items from which potentially discriminatory rules are extracted and checks against them to then infer discriminatory rules, while indirect discrimination happens when there are rules applied to a group of people, but in practice they are unfair to some of them, not explicitly taking into consideration protected attributes. In indirect discrimination, potentially non-discriminatory rules are considered and extracted from a dataset, and deciding the rule’s nature is done based on background knowledge. [1]"
                                  "\n\nThe objective of the application is to provide an insight into fairness of the AI models. The application captures the analysis on some example datasets provided: the Census Income Dataset and the German Credit Scoring Dataset. It provides a visualization of the data, similar to the one in the "),
                          TextSpan(
                              text: "What-If Tool",
                              style: TextStyle(color: Colors.blue)),
                          TextSpan(
                              text: ". [2]"
                                  "The user will be able to read the metrics on these datasets and to see a comparison between the different mitigating methods. \n\nThe base model will be trained on all input variables, including the protected attributes. This will be the baseline model, using LogisticRegression as the classifier. The other 3 conditions will be the "),
                          TextSpan(
                              text:
                                  "Remove Protected Attribute (RPA), Reject-Option Classification (ROC) and the Additive Counterfactually Fair Model (ACF).",
                              style: TextStyle(fontStyle: FontStyle.italic)),
                          TextSpan(
                            text: "They are all implemented in the ",
                          ),
                          TextSpan(
                              text: "Themis-ML",
                              style: TextStyle(color: Colors.blue)),
                          TextSpan(
                              text:
                                  " library, which is imported in the backend built in Python. "
                                  "\n\nAs it is not usually straight-forward which method to pick when trying to mitigate the bias, the user will be introduced to the concepts of these methods and visualize a trade-off between them considering the metrics: in this application mean difference will be used as the metric. This metric encompasses the differences in outcome between groups. It is part of a class of group-level discrimination metrics. "
                                  "Then, the de-biasing experiment will be analysed and explained to the user in an interpreting format, highlighting the benefits and the disadvantages of the difference in fairness-utility. This informs the user about the possible mitigating processes, allowing him to choose the most appropriate one for the model."
                                  "\n\nThe key-feature of the application is that the "),
                          TextSpan(
                              text: "Themis-ML",
                              style: TextStyle(color: Colors.blue)),
                          TextSpan(
                              text:
                                  " library allows the user to introduce his own dataset. This will be introduced in a CSV format, respecting some requirements that will be made clear to the user. The rows should only contain binary or continuous values for the experiment to be possible."
                                  "The project aims to provide practical usability. \n\nCompanies or individuals could add their dataset which contains the predictions and expected values to benefit from an overview of the alternatives to reduce bias. The information extracted and outputted about the dataset could reveal hidden facts that have the purpose to help the user in the de-biasing process."
                                  "\n\nThe application has some limitations and there is room for improvement, some additional features could be covered in the future to improve usefulness and performance of the tool. The design of the software allows for changes to be easily made and additional functionality could be incorporated due to its flexibility."
                                  "Future work, contributions and extensions are highly encouraged.")
                        ]),
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
                            TextSpan(
                              text:
                                  "[1] Pedreshi, D., Ruggieri, S., & Turini, Discrimination-aware data mining, 2008.\n",
                            ),
                            TextSpan(text: "[2] "),
                            TextSpan(
                              style: TextStyle(
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold),
                              text: "https://pair-code.github.io/what-if-tool/",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  await launch(
                                      "https://pair-code.github.io/what-if-tool/");
                                },
                            )
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 0) Get.to(HomeView());
          if (index == 1) Get.to(Installation());
        },
        currentIndex: 2,
        showUnselectedLabels: true,
        fixedColor: Colors.black,
        items: menuOptions.map<BottomNavigationBarItem>((option) {
          return BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            label: option,
            icon: Icon(
              Icons.pages,
            ),
          );
        }).toList(),
      ),
    );
  }
}
