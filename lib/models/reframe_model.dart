class ReframeModel {
  final String logical;
  final String compassionate;
  final String growth;

  ReframeModel({
    required this.logical,
    required this.compassionate,
    required this.growth,
  });

  factory ReframeModel.fromJson(Map<String, dynamic> json) {
    return ReframeModel(
      logical: json['logical'] ?? '',
      compassionate: json['compassionate'] ?? '',
      growth: json['growth'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logical': logical,
      'compassionate': compassionate,
      'growth': growth,
    };
  }
}