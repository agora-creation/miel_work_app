class ReportLockerModel {
  bool use = false;
  bool lost = false;
  String number = '';
  String days = '';
  String price = '';
  String remarks = '';
  String recovery = '';

  ReportLockerModel.fromMap(Map data) {
    use = data['use'] ?? false;
    lost = data['lost'] ?? false;
    number = data['number'] ?? '';
    days = data['days'] ?? '';
    price = data['price'] ?? '';
    remarks = data['remarks'] ?? '';
    recovery = data['recovery'] ?? '';
  }

  ReportLockerModel.addMap(Map data) {
    use = data['use'];
    lost = data['lost'];
    number = data['number'];
    days = data['days'];
    price = data['price'];
    remarks = data['remarks'];
    recovery = data['recovery'];
  }

  Map toMap() => {
        'use': use,
        'lost': lost,
        'number': number,
        'days': days,
        'price': price,
        'remarks': remarks,
        'recovery': recovery,
      };
}
