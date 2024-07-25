class ReportLockerModel {
  bool use = false;
  bool lost = false;
  String recovery = '';

  ReportLockerModel.fromMap(Map data) {
    use = data['use'] ?? false;
    lost = data['lost'] ?? false;
    recovery = data['recovery'] ?? '';
  }

  ReportLockerModel.addMap(Map data) {
    use = data['use'];
    lost = data['lost'];
    recovery = data['recovery'];
  }

  Map toMap() => {
        'use': use,
        'lost': lost,
        'recovery': recovery,
      };
}
