import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_request_overtime_web/common/functions.dart';
import 'package:miel_work_request_overtime_web/common/style.dart';
import 'package:miel_work_request_overtime_web/providers/request_overtime.dart';
import 'package:miel_work_request_overtime_web/screens/step3.dart';
import 'package:miel_work_request_overtime_web/widgets/attached_file_list.dart';
import 'package:miel_work_request_overtime_web/widgets/custom_button.dart';
import 'package:miel_work_request_overtime_web/widgets/dotted_divider.dart';
import 'package:miel_work_request_overtime_web/widgets/form_label.dart';
import 'package:miel_work_request_overtime_web/widgets/form_value.dart';
import 'package:miel_work_request_overtime_web/widgets/link_text.dart';
import 'package:miel_work_request_overtime_web/widgets/responsive_box.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

class Step2Screen extends StatefulWidget {
  final String companyName;
  final String companyUserName;
  final String companyUserEmail;
  final String companyUserTel;
  final DateTime useStartedAt;
  final DateTime useEndedAt;
  final bool useAtPending;
  final String useContent;
  final List<PlatformFile> pickedAttachedFiles;

  const Step2Screen({
    required this.companyName,
    required this.companyUserName,
    required this.companyUserEmail,
    required this.companyUserTel,
    required this.useStartedAt,
    required this.useEndedAt,
    required this.useAtPending,
    required this.useContent,
    required this.pickedAttachedFiles,
    super.key,
  });

  @override
  State<Step2Screen> createState() => _Step2ScreenState();
}

class _Step2ScreenState extends State<Step2Screen> {
  @override
  Widget build(BuildContext context) {
    final overtimeProvider = Provider.of<RequestOvertimeProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Text(
                '夜間居残り作業申請フォーム',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 24),
              ResponsiveBox(
                children: [
                  const Text('以下の申請内容で問題ないかご確認ください。'),
                  const SizedBox(height: 16),
                  const DottedDivider(),
                  const SizedBox(height: 16),
                  const Text(
                    '申請者情報',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SourceHanSansJP-Bold',
                    ),
                  ),
                  const SizedBox(height: 8),
                  FormLabel(
                    '店舗名',
                    child: FormValue(widget.companyName),
                  ),
                  const SizedBox(height: 8),
                  FormLabel(
                    '店舗責任者名',
                    child: FormValue(widget.companyUserName),
                  ),
                  const SizedBox(height: 8),
                  FormLabel(
                    '店舗責任者メールアドレス',
                    child: FormValue(widget.companyUserEmail),
                  ),
                  const SizedBox(height: 8),
                  FormLabel(
                    '店舗責任者電話番号',
                    child: FormValue(widget.companyUserTel),
                  ),
                  const SizedBox(height: 16),
                  const DottedDivider(),
                  const SizedBox(height: 16),
                  const Text(
                    '作業情報',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SourceHanSansJP-Bold',
                    ),
                  ),
                  const SizedBox(height: 8),
                  FormLabel(
                    '作業予定日時',
                    child: FormValue(
                      widget.useAtPending
                          ? '未定'
                          : '${dateText('yyyy年MM月dd日 HH:mm', widget.useStartedAt)}〜${dateText('yyyy年MM月dd日 HH:mm', widget.useEndedAt)}',
                    ),
                  ),
                  const SizedBox(height: 8),
                  FormLabel(
                    '作業内容',
                    child: FormValue(widget.useContent),
                  ),
                  const SizedBox(height: 16),
                  const DottedDivider(),
                  const SizedBox(height: 16),
                  FormLabel(
                    '添付ファイル',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: widget.pickedAttachedFiles.map((file) {
                            return AttachedFileList(
                              fileName: p.basename(file.name),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const DottedDivider(),
                  const SizedBox(height: 32),
                  CustomButton(
                    type: ButtonSizeType.lg,
                    label: '上記内容で申請する',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () async {
                      String? error = await overtimeProvider.create(
                        companyName: widget.companyName,
                        companyUserName: widget.companyUserName,
                        companyUserEmail: widget.companyUserEmail,
                        companyUserTel: widget.companyUserTel,
                        useStartedAt: widget.useStartedAt,
                        useEndedAt: widget.useEndedAt,
                        useAtPending: widget.useAtPending,
                        useContent: widget.useContent,
                        pickedAttachedFiles: widget.pickedAttachedFiles,
                      );
                      if (error != null) {
                        if (!mounted) return;
                        showMessage(context, error, false);
                        return;
                      }
                      if (!mounted) return;
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: const Step3Screen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: LinkText(
                      label: '入力に戻る',
                      color: kBlueColor,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
