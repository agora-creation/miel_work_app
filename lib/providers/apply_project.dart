import 'package:flutter/material.dart';
import 'package:miel_work_app/services/apply_project.dart';
import 'package:miel_work_app/services/fm.dart';
import 'package:miel_work_app/services/user.dart';

class ApplyProjectProvider with ChangeNotifier {
  final ApplyProjectService _projectService = ApplyProjectService();
  final UserService _userService = UserService();
  final FmService _fmService = FmService();
}
