import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_request_overtime_web/services/fm.dart';
import 'package:miel_work_request_overtime_web/services/request_overtime.dart';
import 'package:miel_work_request_overtime_web/services/user.dart';

class RequestOvertimeProvider with ChangeNotifier {
  final RequestOvertimeService _overtimeService = RequestOvertimeService();
  final UserService _userService = UserService();
  final FmService _fmService = FmService();

  Future<String?> create({
    required String shopName,
    required String shopUserName,
    required String shopUserEmail,
    required String shopUserTel,
    required String workPeriod,
    required String workContent,
    required String remarks,
  }) async {
    String? error;
    if (shopName == '') return '店舗名は必須入力です';
    if (shopUserName == '') return '店舗責任者名は必須入力です';
    if (shopUserEmail == '') return '店舗責任者メールアドレスは必須入力です';
    if (shopUserTel == '') return '店舗責任者電話番号は必須入力です';
    try {
      await FirebaseAuth.instance.signInAnonymously().then((value) {
        String id = _overtimeService.id();
        _overtimeService.create({
          'id': id,
          'shopName': shopName,
          'shopUserName': shopUserName,
          'shopUserEmail': shopUserEmail,
          'shopUserTel': shopUserTel,
          'workPeriod': workPeriod,
          'workContent': workContent,
          'remarks': remarks,
          'approval': 0,
          'approvedAt': DateTime.now(),
          'approvalUsers': [],
          'createdAt': DateTime.now(),
        });
      });
      //通知
      // List<UserModel> sendUsers = [];
      // sendUsers = await _userService.selectList();
      // if (sendUsers.isNotEmpty) {
      //   for (UserModel user in sendUsers) {
      //     _fmService.send(
      //       token: user.token,
      //       title: '社外申請',
      //       body: '夜間居残り作業の申請がありました',
      //     );
      //   }
      // }
    } catch (e) {
      error = '申請に失敗しました';
    }
    return error;
  }
}
