import 'package:get/get.dart';

class CensusViewsProvider extends GetxController {
  var pointInfo = {}.obs;
  var meanDifferenceSex = ': '.obs;
  var meanDifferenceForeign = ': '.obs;
  var correlation = false.obs;
  var trainingScore = ': '.obs;
  var accuracy = ': '.obs;
  var classificationReport = ''.obs;
}
