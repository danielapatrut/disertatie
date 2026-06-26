import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

// ignore: missing_return
Future<List<Map<String, dynamic>>> fetchGermanData() async {
  try {
    Response response = await Dio().get("http://127.0.0.1:5000/");
    return decodeData(response.data);
  } on DioError catch (e) {
    print(e);
    return []; // Returnează o listă goală în caz de eroare
  } on Error catch (e) {
    print(e);
    return []; // Returnează o listă goală și pentru alte erori
  }
}

Future<dynamic> fetchGermanCSV() async {
  try {
    Response response = await Dio().get<List<int>>(
        "http://127.0.0.1:5000/german_csv",
        options: Options(responseType: ResponseType.bytes));
    return response.data;
  } on DioError catch (e) {
    print(e);
  } on Error catch (e) {
    print(e);
  }
}

Future<List<int>> fetchCensusCSV() async {
  try {
    Response response = await Dio().get<List<int>>(
        "http://127.0.0.1:5000/census_csv",
        options: Options(responseType: ResponseType.bytes));
    return response.data!;
  } on DioError catch (e) {
    print(e);
    return []; // Returnează o listă goală
  } on Error catch (e) {
    print(e);
    return []; // Returnează o listă goală
  }
}


// ignore: missing_return
Future<List<Map<String, dynamic>>> fetchCensusData() async {
  try {
    Response response = await Dio().get("http://127.0.0.1:5000/census_income");
    print(response.data);
    //return response.data;
    return decodeData(response.data);
  } on DioError catch (e) {
    print("DioError: $e");
    return []; // Returnează o listă goală în caz de eroare
  } on Error catch (e) {
    print("Error: $e");
    return []; // Returnează o listă goală pentru alte erori
  }
}

List<Map<String, dynamic>> decodeData(dynamic data) {
  Map<String, dynamic> map = jsonDecode(data) as Map<String, dynamic>;
  Map<String, dynamic> map2 = map;
  Map<String, Map<String, dynamic>> finalMap =
      new Map<String, Map<String, dynamic>>();
  List<String> keys = [];
  
  map.keys.forEach((key) {
    finalMap[key] = jsonDecode(jsonEncode(map2[key])) as Map<String, dynamic>;
    keys.add(key);
  });

  // Lista bullets
  List<Map<String, dynamic>> bullets = <Map<String, dynamic>>[];
  keys.forEach((key) {
    int iterator = 0;

    // Verificăm dacă `finalMap[key]` nu este null
    final mapEntry = finalMap[key];
    if (mapEntry != null) {
      mapEntry.values.forEach((value) {
        if (bullets.asMap().containsKey(iterator)) {
          bullets[iterator][key] = value;
        } else {
          bullets.insert(iterator, {key: value});
        }
        iterator++;
      });
    }
  });
  return bullets;
}


Future<dynamic> germanDataInfo() async {
  try {
    Response response = await Dio().get("http://127.0.0.1:5000/germaninfo");
    Response<List<int>> subplot;
    Response<List<int>> correlation;
    subplot = await Dio().get<List<int>>("http://127.0.0.1:5000/subplot.png",
        options: Options(responseType: ResponseType.bytes));
    correlation = await Dio().get<List<int>>(
        "http://127.0.0.1:5000/correlation.png",
        options: Options(responseType: ResponseType.bytes));
    return {
      'data': response.data,
      'subplot': subplot.data,
      'correlation': correlation.data
    };
  } on DioError catch (e) {
    print(e);
  } on Error catch (e) {
    print(e);
  }
}

Future<dynamic> censusDataInfo() async {
  try {
    Response response = await Dio().get("http://127.0.0.1:5000/censusinfo");
    Response<List<int>> subplot;
    Response<List<int>> correlation;
    subplot = await Dio().get<List<int>>("http://127.0.0.1:5000/subplot2.png",
        options: Options(responseType: ResponseType.bytes));
    correlation = await Dio().get<List<int>>(
        "http://127.0.0.1:5000/correlation_ci.png",
        options: Options(responseType: ResponseType.bytes));
    return {
      'data': response.data,
      'subplot': subplot.data,
      'correlation': correlation.data
    };
  } on DioError catch (e) {
    print(e);
  } on Error catch (e) {
    print(e);
  }
}

Future<dynamic> getConfusionMatrix() async {
  try {
    Response<List<int>> confusionMatrix = await Dio().get<List<int>>(
        "http://127.0.0.1:5000/confusion_matrix.png",
        options: Options(responseType: ResponseType.bytes));
    return confusionMatrix.data;
  } on DioError catch (e) {
    print(e);
  } on Error catch (e) {
    print(e);
  }
}

Future<dynamic> getCensusConfusionMatrix() async {
  try {
    Response<List<int>> confusionMatrix = await Dio().get<List<int>>(
        "http://127.0.0.1:5000/confusion_matrix2.png",
        options: Options(responseType: ResponseType.bytes));
    return confusionMatrix.data;
  } on DioError catch (e) {
    print(e);
  } on Error catch (e) {
    print(e);
  }
}

Future<dynamic> yourCSVconfusionMatrix(PlatformFile file) async {
  if (file.bytes == null) {
    throw ArgumentError("File bytes cannot be null");
  }

  var formData = FormData.fromMap({
    'file': MultipartFile.fromBytes(
      file.bytes!, // Folosim `!` deoarece am verificat pentru null
      filename: file.name,
    ),
  });

  Response response = await Dio().post<List<int>>(
    "http://127.0.0.1:5000/your_csv_matrix.png",
    options: Options(responseType: ResponseType.bytes),
    data: formData,
  );
  return response.data;
}


// Future<dynamic> yourCSVconfusionMatrix(PlatformFile file) async {
//   var formData = FormData.fromMap(
//       {'file': MultipartFile.fromBytes(file.bytes, filename: file.name)});
//   Response response = await Dio().post<List<int>>(
//       "http://127.0.0.1:5000/your_csv_matrix.png",
//       options: Options(responseType: ResponseType.bytes),
//       data: formData);
//   return response.data;
// }

Future<dynamic> mitigatingModelsGerman() async {
  try {
    Response response =
        await Dio().get("http://127.0.0.1:5000/mitigating_models_german");
    return response.data;
  } on DioError catch (e) {
    print(e);
  } on Error catch (e) {
    print(e);
  }
}

Future<dynamic> mitigatingModelsCensus() async {
  try {
    Response response = await Dio().get("http://127.0.0.1:5000/census_scores");
    return response.data;
  } on DioError catch (e) {
    print(e);
  } on Error catch (e) {
    print(e);
  }
}

Future<dynamic> yourCsvPlot(PlatformFile pickedFile) async {
  try {
    // Verificăm dacă bytes nu este null
    if (pickedFile.bytes == null) {
      throw Exception("File bytes are null");
    }

    Response<List<int>> subplot;
    Response<List<int>> heatmap;

    var formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        pickedFile.bytes!, // Folosim `!` pentru că am verificat anterior
        filename: pickedFile.name,
      ),
    });

    var formData2 = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        pickedFile.bytes!, // Folosim `!` din nou, pentru siguranță
        filename: pickedFile.name,
      ),
    });

    subplot = await Dio().post<List<int>>(
      "http://127.0.0.1:5000/your_csv_plot.png",
      options: Options(responseType: ResponseType.bytes),
      data: formData,
    );

    heatmap = await Dio().post<List<int>>(
      "http://127.0.0.1:5000/your_csv_heatmap.png",
      options: Options(responseType: ResponseType.bytes),
      data: formData2,
    );

    return {'subplot': subplot.data, 'heatmap': heatmap.data};
  } on DioError catch (e) {
    print("DioError: $e");
  } catch (e) {
    print("Error: $e");
  }
}


Future<dynamic> censusCsv() async {
  try {
    Response response = await Dio().get("http://127.0.0.1:5000/census_csv");
    return response.data;
  } on DioError catch (e) {
    print(e);
  } on Error catch (e) {
    print(e);
  }
}
