class ReportVisitorModel {
  int floor1_12 = 0;
  int floor1_20 = 0;
  int floor1_22 = 0;
  int floor2_12 = 0;
  int floor2_20 = 0;
  int floor2_22 = 0;
  int floor3_12 = 0;
  int floor3_20 = 0;
  int floor3_22 = 0;
  int floor4_12 = 0;
  int floor4_20 = 0;
  int floor4_22 = 0;

  ReportVisitorModel.fromMap(Map data) {
    floor1_12 = data['floor1_12'] ?? 0;
    floor1_20 = data['floor1_20'] ?? 0;
    floor1_22 = data['floor1_22'] ?? 0;
    floor2_12 = data['floor2_12'] ?? 0;
    floor2_20 = data['floor2_20'] ?? 0;
    floor2_22 = data['floor2_22'] ?? 0;
    floor3_12 = data['floor3_12'] ?? 0;
    floor3_20 = data['floor3_20'] ?? 0;
    floor3_22 = data['floor3_22'] ?? 0;
    floor4_12 = data['floor4_12'] ?? 0;
    floor4_20 = data['floor4_20'] ?? 0;
    floor4_22 = data['floor4_22'] ?? 0;
  }

  ReportVisitorModel.addMap(Map data) {
    floor1_12 = data['floor1_12'];
    floor1_20 = data['floor1_20'];
    floor1_22 = data['floor1_22'];
    floor2_12 = data['floor2_12'];
    floor2_20 = data['floor2_20'];
    floor2_22 = data['floor2_22'];
    floor3_12 = data['floor3_12'];
    floor3_20 = data['floor3_20'];
    floor3_22 = data['floor3_22'];
    floor4_12 = data['floor4_12'];
    floor4_20 = data['floor4_20'];
    floor4_22 = data['floor4_22'];
  }

  Map toMap() => {
        'floor1_12': floor1_12,
        'floor1_20': floor1_20,
        'floor1_22': floor1_22,
        'floor2_12': floor2_12,
        'floor2_20': floor2_20,
        'floor2_22': floor2_22,
        'floor3_12': floor3_12,
        'floor3_20': floor3_20,
        'floor3_22': floor3_22,
        'floor4_12': floor4_12,
        'floor4_20': floor4_20,
        'floor4_22': floor4_22,
      };
}
