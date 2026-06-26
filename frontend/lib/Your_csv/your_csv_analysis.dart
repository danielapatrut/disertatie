import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class YourCsvAnalysis extends StatefulWidget {
  YourCsvAnalysis({@required this.fileName, this.data});
  final fileName;
  final data;

  @override
  _YourCsvAnalysisState createState() => _YourCsvAnalysisState();
}

class _YourCsvAnalysisState extends State<YourCsvAnalysis> {
  @override
  Widget build(BuildContext context) {
    final fairness_analysis = widget.data["fairness_analysis"];

    return Scaffold(
      appBar: AppBar(),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: Get.width * 0.8,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  "Fairness analysis",
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.apply(color: Colors.black),
                ),
              ),
              Text(
                "Determine how fair your algorithm is with respect to protected groups.",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.apply(color: Colors.black),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Result for ${widget.fileName.split('.')[0]}",
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.apply(color: Colors.black),
                ),
              ),
              Text(
                  "Calculated disparate impact for gender: ${fairness_analysis['disparate_impact_g'][1]}, is discriminatory: ${fairness_analysis['disparate_impact_g'][0]} \n"
                  "Calculated disparate impact for race: ${fairness_analysis['disparate_impact_r'][1]}, is discriminatory: ${fairness_analysis['disparate_impact_r'][0]} \n"),
              Text(
                "Demographic Parity",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.apply(color: Colors.black),
              ),
              Container(
                width: Get.width,
                height: 50,
                child: Card(
                  color: Colors.grey[300],
                  elevation: 10.0,
                  shadowColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Demographic parity measures the acceptance rate between the protected and the unprotected groups"),
                  ),
                ),
              ),
              Text(
                  "Race  ${100 * fairness_analysis["fairness_based_on_race"]}% discriminatory",
                  style: Theme.of(context).textTheme.titleLarge?.apply(
                        color: Colors.black,
                      )),
              Row(
                children: [
                  SizedBox(
                    width: 150.0,
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 35,
                        color:
                            fairness_analysis["fairness_based_on_race"] >= 0.80
                                ? Colors.red
                                : fairness_analysis["fairness_based_on_race"] >=
                                            0.10 &&
                                        fairness_analysis[
                                                "fairness_based_on_race"] <
                                            0.80
                                    ? Colors.yellow
                                    : Colors.green,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText(
                              fairness_analysis["fairness_based_on_race"] >=
                                      0.80
                                  ? 'Safety check at risk'
                                  : fairness_analysis[
                                                  "fairness_based_on_race"] >=
                                              0.10 &&
                                          fairness_analysis[
                                                  "fairness_based_on_race"] <
                                              0.80
                                      ? 'Safety check caution'
                                      : 'Safety check passed',
                              speed: Duration(milliseconds: 400))
                        ],
                        onTap: () {},
                      ),
                    ),
                  ),
                  Text(fairness_analysis["fairness_based_on_race"] < 0.10
                      ? "Satisfied demographic parity for race"
                      : "Unsatisfied demographic parity for race")
                ],
              ),
              Text(
                  "${fairness_analysis["advantaged_counts_race"]} in advantaged category, ${fairness_analysis["advantaged_race_counts_one"]} with favourable outcome"),
              Text(
                  "${fairness_analysis["disadvantaged_counts_race"]} in disadvantaged category, ${fairness_analysis["disadvantaged_race_counts_one"]} with disadvantageous outcome"),
              Text(
                "Sex ${100 * fairness_analysis["fairness_based_on_sex"]}% discriminatory",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.apply(color: Colors.black),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 150.0,
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 35,
                        color: fairness_analysis["fairness_based_on_sex"] >=
                                0.80
                            ? Colors.red
                            : fairness_analysis["fairness_based_on_sex"] >=
                                        0.10 &&
                                    fairness_analysis["fairness_based_on_sex"] <
                                        0.80
                                ? Colors.yellow
                                : Colors.green,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText(
                              fairness_analysis["fairness_based_on_sex"] >= 0.80
                                  ? 'Safety check at risk'
                                  : fairness_analysis[
                                                  "fairness_based_on_sex"] >=
                                              0.10 &&
                                          fairness_analysis[
                                                  "fairness_based_on_sex"] <
                                              0.80
                                      ? 'Safety check caution'
                                      : 'Safety check passed',
                              speed: Duration(milliseconds: 400))
                        ],
                        onTap: () {},
                      ),
                    ),
                  ),
                  Text(fairness_analysis["fairness_based_on_sex"] < 0.10
                      ? "Satisfied demographic parity for sex"
                      : "Unsatisfied demographic parity for sex"),
                ],
              ),
              Text(
                  "${fairness_analysis["advantaged_sex_counts"]} in advantaged category, ${fairness_analysis["advantaged_sex_counts_one"]} with favourable outcome"),
              Text(
                  "${fairness_analysis["disadvantaged_sex_counts"]} in disadvantaged category, ${fairness_analysis["disadvantaged_sex_counts_one"]} with disadvantageous outcome"),
              Text("Error Measurement",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.apply(color: Colors.black)),
              Container(
                width: Get.width,
                height: 50,
                child: Card(
                  color: Colors.grey[300],
                  elevation: 10.0,
                  shadowColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Shows whether errors are condensed in sensitive attributes."),
                  ),
                ),
              ),
              Text(
                  "Race  ${100 * fairness_analysis["error_measure_race"]}% discriminatory",
                  style: Theme.of(context).textTheme.titleLarge?.apply(
                        color: Colors.black,
                      )),
              Row(
                children: [
                  SizedBox(
                    width: 150.0,
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 35,
                        color: fairness_analysis["error_measure_race"] >= 0.80
                            ? Colors.red
                            : fairness_analysis["error_measure_race"] >= 0.10 &&
                                    fairness_analysis["error_measure_race"] <
                                        0.80
                                ? Colors.yellow
                                : Colors.green,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText(
                              fairness_analysis["error_measure_race"] >= 0.80
                                  ? 'Safety check at risk'
                                  : fairness_analysis["error_measure_race"] >=
                                              0.10 &&
                                          fairness_analysis[
                                                  "error_measure_race"] <
                                              0.80
                                      ? 'Safety check caution'
                                      : 'Safety check passed',
                              speed: Duration(milliseconds: 400))
                        ],
                        onTap: () {},
                      ),
                    ),
                  ),
                  Text(fairness_analysis["error_measure_race"] < 0.10
                      ? "Satisfied demographic parity for errors in race"
                      : "Unsatisfied demographic parity for errors in race"),
                ],
              ),
              Text(
                  "${fairness_analysis["error_measure_race_one"] * 100}% in advantaged category are incorrect"),
              Text(
                  "${fairness_analysis["error_measure_race_zero"] * 100}% in disadvantaged category are incorrect"),
              Text(
                "Gender ${100 * fairness_analysis["error_measure_sex"]}% discriminatory",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.apply(color: Colors.black),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 150.0,
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 35,
                        color: fairness_analysis["error_measure_sex"] >= 0.80
                            ? Colors.red
                            : fairness_analysis["error_measure_sex"] >= 0.10 &&
                                    fairness_analysis["error_measure_sex"] <
                                        0.80
                                ? Colors.yellow
                                : Colors.green,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText(
                              fairness_analysis["error_measure_sex"] >= 0.80
                                  ? 'Safety check at risk'
                                  : fairness_analysis["error_measure_sex"] >=
                                              0.10 &&
                                          fairness_analysis[
                                                  "error_measure_sex"] <
                                              0.80
                                      ? 'Safety check caution'
                                      : 'Safety check passed',
                              speed: Duration(milliseconds: 400))
                        ],
                        onTap: () {},
                      ),
                    ),
                  ),
                  Text(fairness_analysis["error_measure_sex"] < 0.10
                      ? "Satisfied demographic parity for errors in sex"
                      : "Unsatisfied demographic parity for errors in sex"),
                ],
              ),
              Text(
                  "${fairness_analysis["error_measure_sex_one"] * 100}% in advantaged category are incorrect"),
              Text(
                  "${fairness_analysis["error_measure_sex_zero"] * 100}% in disadvantaged category are incorrect"),
            ],
          ),
        ),
      ),
    );
  }
}
