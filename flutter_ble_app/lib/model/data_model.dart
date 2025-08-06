class ReceivedDataModel {
  final int ledStatus;
  final double temperature;
  final double humidity;

  ReceivedDataModel({
    required this.ledStatus,
    required this.temperature,
    required this.humidity,
  });

  factory ReceivedDataModel.fromJson(Map<String, dynamic> json) {
    return ReceivedDataModel(
      ledStatus: json['ledStatus'],
      temperature: json['temperature'],
      humidity: json['humidity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ledStatus': ledStatus,
    };
  }
}

class SendDataModel {
  final String ledStatus;

  SendDataModel({required this.ledStatus});

  Map<String, dynamic> toJson() {
    return {
      'ledStatus': ledStatus,
    };
  }
}
