import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Home_view/home_view.dart';
import 'package:frontend/app_bar.dart';
import 'package:get/get.dart';
import 'common_needs.dart';
import 'learn_more.dart';
import 'package:url_launcher/url_launcher.dart';

class Installation extends StatefulWidget {
  @override
  _InstallationState createState() => _InstallationState();
}

class _InstallationState extends State<Installation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(
        child: Container(
            width: Get.width * 0.9,
            child: Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                          style: TextStyle(
                              color: Colors.black, fontSize: 20.0, height: 2),
                          children: [
                            TextSpan(
                                text:
                                    " For the development of this application, the Themis-ML library was used to calculate metrics and to analyse fairness."
                                    " This library is available on GitHub at "),
                            TextSpan(
                              text: "https://github.com/cosmicBboy/themis-ml.",
                              style: TextStyle(
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  await launch(
                                      "https://github.com/cosmicBboy/themis-ml");
                                },
                            ),
                            TextSpan(
                                text:
                                    "\nThe implementation was adapted to fit to any CSV file uploaded by the user."
                                    "\nInstallation kit for development, including Themis-ML requirements and other libraries: "),
                          ]),
                    ),
                    Table(
                      children: pipCommands
                          .map<TableRow>((command) => TableRow(children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 30.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          border: Border.all(
                                              width: 0.7, color: Colors.black)),
                                      // width: 400.0,
                                      height: 50.0,
                                      child: Center(
                                        child: Text(command,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      )),
                                )
                              ]))
                          .toList(),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                              color: Colors.black, fontSize: 20.0, height: 2),
                          children: [
                            TextSpan(
                                text:
                                    "The official documentation for the package is avaialble here: "),
                            TextSpan(
                              text:
                                  "http://themis-ml.readthedocs.io/en/latest/.",
                              style: TextStyle(
                                color: Colors.blue[900],
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  await launch(
                                      "http://themis-ml.readthedocs.io/en/latest/");
                                },
                            ),
                            TextSpan(
                                text:
                                    "\nThis application encourages contributions and further development.")
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
            // child: Text(
            //     " For the development of this application, the Themis-ML library was used to calculate metrics and to analyse fairness."
            //     "This library is available on GitHub at https://github.com/cosmicBboy/themis-ml."
            //     "The implementation was adapted to fit to any CSV file uploaded by the user."
            //     "Installation kit for development, including Themis-ML requirements and other libraries: "
            //     "pip install themis-ml"
            //     "pip install pandas"
            //     "pip install numpy"
            //     "pip install scikit-learn"
            //     "pip install matplotlib"
            //     "pip install seaborn"
            //     "The official documentation for the package is avaialble here: http://themis-ml.readthedocs.io/en/latest/."
            //     "This application encourages contributions and further development."),
            ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 0) Get.to(HomeView());
          if (index == 2) Get.to(LearnMore());
        },
        currentIndex: 1,
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

List<String> pipCommands = [
  "pip install themis-ml",
  "pip install pandas",
  "pip install numpy",
  "pip install scikit-learn",
  "pip install matplotlib",
  "pip install seaborn"
];
