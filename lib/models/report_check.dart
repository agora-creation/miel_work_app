class ReportCheckModel {
  String mail10 = '';
  String mail12 = '';
  String mail18 = '';
  String mail22 = '';
  String warning19State = '';
  String warning19Deal = '';
  String warning23State = '';
  String warning23Deal = '';

  ReportCheckModel.fromMap(Map data) {
    mail10 = data['mail10'] ?? '';
    mail12 = data['mail12'] ?? '';
    mail18 = data['mail18'] ?? '';
    mail22 = data['mail22'] ?? '';
    warning19State = data['warning19State'] ?? '';
    warning19Deal = data['warning19Deal'] ?? '';
    warning23State = data['warning23State'] ?? '';
    warning23Deal = data['warning23Deal'] ?? '';
  }

  ReportCheckModel.addMap(Map data) {
    mail10 = data['mail10'];
    mail12 = data['mail12'];
    mail18 = data['mail18'];
    mail22 = data['mail22'];
    warning19State = data['warning19State'];
    warning19Deal = data['warning19Deal'];
    warning23State = data['warning23State'];
    warning23Deal = data['warning23Deal'];
  }

  Map toMap() => {
    'mail10': mail10,
    'mail12': mail12,
    'mail18': mail18,
    'mail22': mail22,
    'warning19State': warning19State,
    'warning19Deal': warning19Deal,
    'warning23State': warning23State,
    'warning23Deal': warning23Deal,
  };
}