class ReportEquipmentModel {
  String _id = '';
  String type = '';
  String name = '';
  String vendor = '';
  String deliveryDate = '';
  String deliveryNum = '';
  String client = '';

  String get id => _id;

  ReportEquipmentModel.fromMap(Map data) {
    _id = data['id'] ?? '';
    type = data['type'] ?? '';
    name = data['name'] ?? '';
    vendor = data['vendor'] ?? '';
    deliveryDate = data['deliveryDate'] ?? '';
    deliveryNum = data['deliveryNum'] ?? '';
    client = data['client'] ?? '';
  }

  ReportEquipmentModel.addMap(Map data) {
    _id = data['id'];
    type = data['type'];
    name = data['name'];
    vendor = data['vendor'];
    deliveryDate = data['deliveryDate'];
    deliveryNum = data['deliveryNum'];
    client = data['client'];
  }

  Map toMap() => {
        'id': _id,
        'type': type,
        'name': name,
        'vendor': vendor,
        'deliveryDate': deliveryDate,
        'deliveryNum': deliveryNum,
        'client': client,
      };
}
