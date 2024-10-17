import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_request_overtime_web/common/functions.dart';
import 'package:miel_work_request_overtime_web/models/user.dart';
import 'package:miel_work_request_overtime_web/services/fm.dart';
import 'package:miel_work_request_overtime_web/services/mail.dart';
import 'package:miel_work_request_overtime_web/services/request_overtime.dart';
import 'package:miel_work_request_overtime_web/services/user.dart';

class RequestOvertimeProvider with ChangeNotifier {
  final RequestOvertimeService _overtimeService = RequestOvertimeService();
  final UserService _userService = UserService();
  final MailService _mailService = MailService();
  final FmService _fmService = FmService();

  Future<String?> check({
    required String companyName,
    required String companyUserName,
    required String companyUserEmail,
    required String companyUserTel,
  }) async {
    String? error;
    if (companyName == '') return '店舗名は必須入力です';
    if (companyUserName == '') return '店舗責任者名は必須入力です';
    if (companyUserEmail == '') return '店舗責任者メールアドレスは必須入力です';
    if (companyUserTel == '') return '店舗責任者電話番号は必須入力です';
    return error;
  }

  Future<String?> create({
    required String companyName,
    required String companyUserName,
    required String companyUserEmail,
    required String companyUserTel,
    required DateTime useStartedAt,
    required DateTime useEndedAt,
    required bool useAtPending,
    required String useContent,
  }) async {
    String? error;
    if (companyName == '') return '店舗名は必須入力です';
    if (companyUserName == '') return '店舗責任者名は必須入力です';
    if (companyUserEmail == '') return '店舗責任者メールアドレスは必須入力です';
    if (companyUserTel == '') return '店舗責任者電話番号は必須入力です';
    try {
      await FirebaseAuth.instance.signInAnonymously().then((value) {
        String id = _overtimeService.id();
        _overtimeService.create({
          'id': id,
          'companyName': companyName,
          'companyUserName': companyUserName,
          'companyUserEmail': companyUserEmail,
          'companyUserTel': companyUserTel,
          'useStartedAt': useStartedAt,
          'useEndedAt': useEndedAt,
          'useAtPending': useAtPending,
          'approval': 0,
          'approvedAt': DateTime.now(),
          'approvalUsers': [],
          'createdAt': DateTime.now(),
        });
      });
      String useAtText = '';
      if (useAtPending) {
        useAtText = '未定';
      } else {
        useAtText =
            '${dateText('yyyy/MM/dd HH:mm', useStartedAt)}〜${dateText('yyyy/MM/dd HH:mm', useEndedAt)}';
      }
      String message = '''
★★★このメールは自動返信メールです★★★

夜間居残り作業申請が完了いたしました。
以下申請内容を確認し、ご返信させていただきますので今暫くお待ちください。
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
■申請者情報
【店舗名】$companyName
【店舗責任者名】$companyUserName
【店舗責任者メールアドレス】$companyUserEmail
【店舗責任者電話番号】$companyUserTel

■作業情報
【作業予定日時】$useAtText
【作業内容】
$useContent

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
      ''';
      _mailService.create({
        'id': _mailService.id(),
        'to': companyUserEmail,
        'subject': '【自動送信】夜間居残り作業申請完了のお知らせ',
        'message': message,
        'createdAt': DateTime.now(),
        'expirationAt': DateTime.now().add(const Duration(hours: 1)),
      });
      //通知
      List<UserModel> sendUsers = [];
      sendUsers = await _userService.selectList();
      if (sendUsers.isNotEmpty) {
        for (UserModel user in sendUsers) {
          _fmService.send(
            token: user.token,
            title: '社外申請',
            body: '夜間居残り作業の申請がありました',
          );
        }
      }
    } catch (e) {
      error = '申請に失敗しました';
    }
    return error;
  }
}
