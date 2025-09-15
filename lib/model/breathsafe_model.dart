class BreathsafeModel {
  double? temp;
  double? humidity;

  BreathsafeModel({this.temp, this.humidity});


  BreathsafeModel.fromJson(Map<String, dynamic> json) {
    temp = json['temp'] as double;
    humidity = json['humidity'] as double;
  }

}