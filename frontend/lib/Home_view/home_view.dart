import 'dart:convert';
import 'dart:html' as html;
import 'package:dio/dio.dart' as dio;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Census_data/census_data_chart_view.dart';
import 'package:frontend/Census_data/census_data_info_view.dart';
import 'package:frontend/German_data/german_data_chart_view.dart';
import 'package:frontend/German_data/german_data_info_view.dart';
import 'package:frontend/Your_csv/your_csv_view.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:frontend/dataFetching.dart';

import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import '../app_bar.dart';
import '../common_needs.dart';
import '../installation.dart';
import '../learn_more.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  DataSets? dataSet = DataSets.GermanCreditScoring;
  PlatformFile? pickedFile;
  var pickedFileName = "No file chosen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(),
      body: Padding(
        padding:
            EdgeInsets.only(top: Get.height * 0.05, left: Get.width * 0.05),
        child: ListView(
          children: [
            Text(
              "1. Select from our existing data sets:",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.apply(color: Colors.black),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: Get.height * 0.01, right: Get.width * 0.2),
              child: Text(
                " At a high level, themis-ml defines discrimination as something that occurs when an action is based on biases that systematically benefits one group of people over another based on certain social attributes (legally known as protected classes such as race, gender, and religion). In the machine learning context, this means that an ML model is discriminatory if it generates predictions that systematically benefits one social group over another.  Here are three sample datasets that you can explore to analyse fairness and de-bias models.",
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: Get.height * 0.01),
              child: ListTile(
                title: Text(
                  "German credit scoring",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.apply(color: Colors.black),
                ),
                leading: Radio<DataSets>(
                    value: DataSets.GermanCreditScoring,
                    groupValue: dataSet,
                    onChanged: (DataSets? value) {
                      setState(() {
                        dataSet = value; // Acum `dataSet` poate fi `null`
                      });
                    }),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: Get.width * 0.05),
              child: RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: "Visualize and explore data",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.to(GermanDataChartView());
                      },
                    style: TextStyle(
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline)),
                TextSpan(
                    text: "\nSee data set",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final bytes = await fetchGermanCSV();
                        final content = base64Encode(bytes);
                        final anchor = html.AnchorElement(
                            href:
                                "data:application/octet-stream;charset=utf-16le;base64,$content")
                          ..setAttribute("download", "german_csv.html")
                          ..click();
                      },
                    style: TextStyle(
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline)),
                TextSpan(
                    text:
                        "\n\nMeasure potential discrimination with respect to the target variable credit risk"),
                TextSpan(text: "\nProtected Attributes:"),
                TextSpan(
                    text: "\n- Sex",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ", privileged:"),
                TextSpan(
                    text: " Male",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ", unprivileged:"),
                TextSpan(
                    text: " Female",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: "\n- Immigration status",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                  text: ", privileged: ",
                ),
                TextSpan(
                    text: "Citizen",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                  text: ", unprivileged: ",
                ),
                TextSpan(
                    text: "Foreign",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ])),
            ),
            ListTile(
              title: RichText(
                text: TextSpan(
                    text: 'Adult census income',
                    style: Theme.of(context).textTheme.titleLarge,
                    children: <TextSpan>[
                      TextSpan(text: ""),
                    ]),
              ),
              leading: Radio<DataSets>(
                  value: DataSets.AdultCensusIncome,
                  groupValue: dataSet,
                  onChanged: (DataSets? value) {
                    setState(() {
                      dataSet = value;
                    });
                  }),
            ),
            Padding(
              padding: EdgeInsets.only(left: Get.width * 0.05),
              child: RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: "Visualize and explore data",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.to(CensusDataChartView());
                      },
                    style: TextStyle(
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline)),
                TextSpan(
                    text: "\nSee data set",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final bytes = await fetchCensusCSV();
                        final content = base64Encode(bytes);
                        final anchor = html.AnchorElement(
                            href:
                                "data:application/octet-stream;charset=utf-16le;base64,$content")
                          ..setAttribute("download", "census_csv.html")
                          ..click();
                      },
                    style: TextStyle(
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline)),
                TextSpan(
                    text:
                        "\n\nMeasure potential discrimination considering the target variable that indicates whether income exceeds \$50K/yr based on census data"),
                TextSpan(text: "\nProtected Attributes:"),
                TextSpan(
                    text: "\n- Sex",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ", privileged:"),
                TextSpan(
                    text: " Male",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ", unprivileged:"),
                TextSpan(
                    text: " Female",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ])),
            ),
            Padding(
              padding: EdgeInsets.only(top: Get.height * 0.04),
              child: Align(
                child: Container(
                  height: 40.0,
                  width: 120.0,
                  child: ElevatedButton(
                    onPressed: () {
                      if (dataSet == DataSets.GermanCreditScoring)
                        Get.to(GermanDataInfoView());
                      else
                        Get.to(CensusDataInfoView());
                    },
                    child: Text("Next"),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 1,
                    width: Get.width * 0.4,
                    color: Colors.grey,
                  ),
                  Text(
                    "OR",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.apply(color: Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: Get.width * 0.05),
                    child: Container(
                      height: 1,
                      width: Get.width * 0.4,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text(
                "2. Upload your model outputs in CSV format to evaluate fairness",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.apply(color: Colors.black),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text(
                "Format specification:",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.apply(color: Colors.black),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      width: 500,
                      height: 500,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/FutureTable.png'),
                              fit: BoxFit.fill,
                              alignment: Alignment.center))),
                  //UPLOAD FILE
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            border: Border.all(color: Colors.black)),
                        height: 45.0,
                        width: 400.0,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  // `pickFiles` poate returna `null`, așa că trebuie să folosim un tip nullable.
                                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['csv'], // Permite doar fișierele CSV
                                  );

                                  if (result != null) {
                                    // `result.files.first.name` este nullable, deci trebuie verificat.
                                    final fileName = result.files.first.name;
                                    setState(() {
                                      if (fileName != null && fileName.split('.').last == 'csv') {
                                        pickedFileName = fileName; // Fără erori de tip aici
                                        pickedFile = result.files.first; // Obiectul selectat
                                      } else {
                                        pickedFileName = "Only .csv files allowed"; // Afișează un mesaj de eroare
                                      }
                                    });
                                  } else {
                                    // Gestionare opțională dacă utilizatorul anulează selecția fișierului
                                    setState(() {
                                      pickedFileName = "No file selected";
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[100],
                                  side: BorderSide(color: Colors.black),
                                ),
                                child: Text(
                                  "Choose file",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                pickedFileName,
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    color: pickedFileName ==
                                            "Only .csv files allowed"
                                        ? Colors.red[900]
                                        : Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //UPLOAD FILE BUTTON
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Align(
                          child: ElevatedButton(
                            onPressed: pickedFileName == "No file chosen" ||
                                    pickedFileName == "Only .csv files allowed"
                                ? null
                                : () async {
                                    if (pickedFile?.bytes != null) {
                                      var formData = dio.FormData.fromMap({
                                        'file': dio.MultipartFile.fromBytes(
                                          pickedFile!.bytes!, // Accesăm proprietatea cu `!` după verificare
                                          filename: pickedFileName,
                                        ),
                                      });

                                      try {
                                        dio.Response response = await dio.Dio().post(
                                          "http://127.0.0.1:5000/your_csv",
                                          data: formData,
                                        );

                                        Get.to(
                                          YourCsvView(
                                            filename: pickedFileName,
                                            yourCsvData: response.data,
                                            pickedFile: pickedFile!,
                                          ),
                                        );
                                      } catch (e) {
                                        // Gestionarea erorilor HTTP
                                        print("Error uploading file: $e");
                                      }
                                    } else {
                                      print("No file selected or file is invalid");
                                    }
                                  },
                            child: Text("Upload data"),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Text(
                            'The uploaded file should follow this format, containing the following attribute names, with binary and continous values:',
                            style: Theme.of(context).textTheme.bodyLarge ,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                        child: Table(
                            defaultColumnWidth: FixedColumnWidth(250),
                            children: tableData.map<TableRow>((entry) {
                              return TableRow(children: [
                                Center(
                                  child: Text(
                                    entry,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )
                              ]);
                            }).toList()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 1) Get.to(Installation());
          if (index == 2) Get.to(LearnMore());
        },
        currentIndex: 0,
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

List<String> tableData = [
  'feature 1',
  'feature 2',
  '...',
  'feature n',
  'gender (protected attribute)',
  'race (protected attribute)',
  'prediction',
  'expected\n'
];

enum DataSets { GermanCreditScoring, AdultCensusIncome }
