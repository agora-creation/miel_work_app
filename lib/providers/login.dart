import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/models/organization.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/services/fm.dart';
import 'package:miel_work_app/services/organization.dart';
import 'package:miel_work_app/services/organization_group.dart';
import 'package:miel_work_app/services/user.dart';

enum AuthStatus {
  authenticated,
  uninitialized,
  authenticating,
  unauthenticated,
}

class LoginProvider with ChangeNotifier {
  AuthStatus _status = AuthStatus.uninitialized;
  AuthStatus get status => _status;
  final FirebaseAuth? _auth;
  User? _authUser;
  User? get authUser => _authUser;

  final FmService _fmService = FmService();
  final UserService _userService = UserService();
  final OrganizationService _organizationService = OrganizationService();
  final OrganizationGroupService _groupService = OrganizationGroupService();
  UserModel? _user;
  UserModel? get user => _user;
  OrganizationModel? _organization;
  OrganizationModel? get organization => _organization;
  OrganizationGroupModel? _group;
  OrganizationGroupModel? get group => _group;

  bool isAdmin() {
    List<String> orgAdminUserIds = _organization?.adminUserIds ?? [];
    String userId = _user?.id ?? '';
    return orgAdminUserIds.contains(userId);
  }

  LoginProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth?.authStateChanges().listen(_onStateChanged);
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    String? error;
    if (email == '') return 'メールアドレスを入力してください';
    if (password == '') return 'パスワードを入力してください';
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      final result = await _auth?.signInAnonymously();
      _authUser = result?.user;
      UserModel? tmpUser = await _userService.selectData(
        email: email,
        password: password,
      );
      if (tmpUser != null) {
        OrganizationModel? tmpOrganization =
            await _organizationService.selectData(
          userId: tmpUser.id,
        );
        if (tmpOrganization != null) {
          if (tmpUser.uid == '') {
            _user = tmpUser;
            _organization = tmpOrganization;
            OrganizationGroupModel? tmpGroup = await _groupService.selectData(
              organizationId: tmpOrganization.id,
              userId: tmpUser.id,
            );
            if (tmpGroup != null) {
              _group = tmpGroup;
            }
            String uid = result?.user?.uid ?? '';
            String token = await _fmService.getToken() ?? '';
            _userService.update({
              'id': _user?.id,
              'uid': uid,
              'token': token,
            });
            await setPrefsString('email', email);
            await setPrefsString('password', password);
          } else {
            await _auth?.signOut();
            _status = AuthStatus.unauthenticated;
            notifyListeners();
            error = '既に他の端末でログインしてます';
          }
        } else {
          await _auth?.signOut();
          _status = AuthStatus.unauthenticated;
          notifyListeners();
          error = '団体が見つかりません';
        }
      } else {
        await _auth?.signOut();
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        error = 'メールアドレスまたはパスワードが間違ってます';
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      error = 'ログインに失敗しました';
    }
    return error;
  }

  Future<String?> updateName({
    required String name,
  }) async {
    String? error;
    if (name == '') return '名前を入力してください';
    try {
      _userService.update({
        'id': _user?.id,
        'name': name,
      });
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> updateEmail({
    required String email,
  }) async {
    String? error;
    if (email == '') return 'メールアドレスを入力してください';
    try {
      _userService.update({
        'id': _user?.id,
        'email': email,
      });
      await setPrefsString('email', email);
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> updatePassword({
    required String password,
  }) async {
    String? error;
    if (password == '') return 'パスワードを入力してください';
    try {
      _userService.update({
        'id': _user?.id,
        'password': password,
      });
      await setPrefsString('password', password);
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> updateAdminUserIds({
    required List<UserModel> selectedUsers,
  }) async {
    String? error;
    if (selectedUsers.isEmpty) return 'スタッフを一人以上選択してください';
    if (_organization == null) return '管理者の選択に失敗しました';
    try {
      List<String> adminUserIds = [];
      for (UserModel user in selectedUsers) {
        adminUserIds.add(user.id);
      }
      _organizationService.update({
        'id': _organization?.id,
        'adminUserIds': adminUserIds,
      });
    } catch (e) {
      notifyListeners();
      error = '管理者の選択に失敗しました';
    }
    return error;
  }

  Future logout() async {
    await _auth?.signOut();
    _status = AuthStatus.unauthenticated;
    await allRemovePrefs();
    _userService.update({
      'id': _user?.id,
      'uid': '',
      'token': '',
    });
    _user = null;
    _organization = null;
    _group = null;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future reload() async {
    String? email = await getPrefsString('email');
    String? password = await getPrefsString('password');
    if (email != null && password != null) {
      UserModel? tmpUser = await _userService.selectData(
        email: email,
        password: password,
      );
      if (tmpUser != null) {
        OrganizationModel? tmpOrganization =
            await _organizationService.selectData(
          userId: tmpUser.id,
        );
        if (tmpOrganization != null) {
          _user = tmpUser;
          _organization = tmpOrganization;
          OrganizationGroupModel? tmpGroup = await _groupService.selectData(
            organizationId: tmpOrganization.id,
            userId: tmpUser.id,
          );
          if (tmpGroup != null) {
            _group = tmpGroup;
          }
        }
      }
    }
    notifyListeners();
  }

  Future _onStateChanged(User? authUser) async {
    if (authUser == null) {
      _status = AuthStatus.unauthenticated;
    } else {
      _authUser = authUser;
      _status = AuthStatus.authenticated;
      String? email = await getPrefsString('email');
      String? password = await getPrefsString('password');
      if (email != null && password != null) {
        UserModel? tmpUser = await _userService.selectData(
          email: email,
          password: password,
        );
        if (tmpUser != null) {
          OrganizationModel? tmpOrganization =
              await _organizationService.selectData(
            userId: tmpUser.id,
          );
          if (tmpOrganization != null) {
            _user = tmpUser;
            _organization = tmpOrganization;
            OrganizationGroupModel? tmpGroup = await _groupService.selectData(
              organizationId: tmpOrganization.id,
              userId: tmpUser.id,
            );
            if (tmpGroup != null) {
              _group = tmpGroup;
            }
          } else {
            _authUser = null;
            _status = AuthStatus.unauthenticated;
          }
        } else {
          _authUser = null;
          _status = AuthStatus.unauthenticated;
        }
      } else {
        _authUser = null;
        _status = AuthStatus.unauthenticated;
      }
    }
    notifyListeners();
  }
}
