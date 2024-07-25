class ReportPamphletModel {
  String _id = '';
  String type = '';
  String title = '';
  String price = '';

  String get id => _id;

  ReportPamphletModel.fromMap(Map data) {
    _id = data['id'] ?? '';
    type = data['type'] ?? '';
    title = data['title'] ?? '';
    price = data['price'] ?? '';
  }

  ReportPamphletModel.addMap(Map data) {
    _id = data['id'];
    type = data['type'];
    title = data['title'];
    price = data['price'];
  }

  Map toMap() => {
        'id': _id,
        'type': type,
        'title': title,
        'price': price,
      };
}
