import 'package:flutter/material.dart';
import 'package:miel_work_request_overtime_web/common/custom_date_time_picker.dart';
import 'package:miel_work_request_overtime_web/common/functions.dart';
import 'package:miel_work_request_overtime_web/common/style.dart';
import 'package:miel_work_request_overtime_web/providers/request_overtime.dart';
import 'package:miel_work_request_overtime_web/screens/step2.dart';
import 'package:miel_work_request_overtime_web/widgets/custom_button.dart';
import 'package:miel_work_request_overtime_web/widgets/custom_text_field.dart';
import 'package:miel_work_request_overtime_web/widgets/datetime_range_form.dart';
import 'package:miel_work_request_overtime_web/widgets/dotted_divider.dart';
import 'package:miel_work_request_overtime_web/widgets/form_label.dart';
import 'package:miel_work_request_overtime_web/widgets/responsive_box.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Step1Screen extends StatefulWidget {
  const Step1Screen({super.key});

  @override
  State<Step1Screen> createState() => _Step1ScreenState();
}

class _Step1ScreenState extends State<Step1Screen> {
  TextEditingController companyName = TextEditingController();
  TextEditingController companyUserName = TextEditingController();
  TextEditingController companyUserEmail = TextEditingController();
  TextEditingController companyUserTel = TextEditingController();
  DateTime useStartedAt = DateTime.now();
  DateTime useEndedAt = DateTime.now();
  bool useAtPending = false;
  TextEditingController useContent = TextEditingController();

  @override
  void initState() {
    useStartedAt = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      10,
      0,
      0,
    );
    useEndedAt = useStartedAt.add(
      const Duration(hours: 2),
    );
    super.initState();
  }

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
                  const Text('以下のフォームにご入力いただき、作業規約を確認して申請を行なってください。'),
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
                    required: true,
                    child: CustomTextField(
                      controller: companyName,
                      textInputType: TextInputType.text,
                      maxLines: 1,
                      hintText: '例）明神水産',
                    ),
                  ),
                  const SizedBox(height: 8),
                  FormLabel(
                    '店舗責任者名',
                    required: true,
                    child: CustomTextField(
                      controller: companyUserName,
                      textInputType: TextInputType.text,
                      maxLines: 1,
                      hintText: '例）田中太郎',
                    ),
                  ),
                  const SizedBox(height: 8),
                  FormLabel(
                    '店舗責任者メールアドレス',
                    required: true,
                    child: CustomTextField(
                      controller: companyUserEmail,
                      textInputType: TextInputType.text,
                      maxLines: 1,
                      hintText: '例）tanaka@hirome.co.jp',
                    ),
                  ),
                  const Text(
                    '※このメールアドレス宛に、返答させていただきます',
                    style: TextStyle(
                      color: kRedColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SourceHanSansJP-Bold',
                    ),
                  ),
                  const SizedBox(height: 8),
                  FormLabel(
                    '店舗責任者電話番号',
                    required: true,
                    child: CustomTextField(
                      controller: companyUserTel,
                      textInputType: TextInputType.text,
                      maxLines: 1,
                      hintText: '例）090-0000-0000',
                    ),
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
                    child: DatetimeRangeForm(
                      startedAt: useStartedAt,
                      startedOnTap: () async =>
                          await CustomDateTimePicker().picker(
                        context: context,
                        init: useStartedAt,
                        title: '作業予定開始日時を選択',
                        onChanged: (value) {
                          setState(() {
                            useStartedAt = value;
                          });
                        },
                      ),
                      endedAt: useEndedAt,
                      endedOnTap: () async =>
                          await CustomDateTimePicker().picker(
                        context: context,
                        init: useEndedAt,
                        title: '作業予定終了日時を選択',
                        onChanged: (value) {
                          setState(() {
                            useEndedAt = value;
                          });
                        },
                      ),
                      pending: useAtPending,
                      pendingOnChanged: (value) {
                        setState(() {
                          useAtPending = value ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  FormLabel(
                    '作業内容',
                    child: CustomTextField(
                      controller: useContent,
                      textInputType: TextInputType.multiline,
                      maxLines: 5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const DottedDivider(),
                  const SizedBox(height: 16),
                  const Text(
                    '作業規約',
                    style: TextStyle(
                      color: kRedColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SourceHanSansJP-Bold',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '※作業は店舗内のみで行い、トイレ以外は館内をむやみに移動しません',
                    style: TextStyle(
                      color: kRedColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SourceHanSansJP-Bold',
                    ),
                  ),
                  const Text(
                    '※火気には十分に注意して作業をします。終了時には火の元を点検して退場します',
                    style: TextStyle(
                      color: kRedColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SourceHanSansJP-Bold',
                    ),
                  ),
                  const Text(
                    '※建物周囲はすべて施錠しているので、内側から開錠して外に出ません',
                    style: TextStyle(
                      color: kRedColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SourceHanSansJP-Bold',
                    ),
                  ),
                  const Text(
                    '※その他夜間の居残りに関して、事故が起きた場合は、緊急連絡先や関係者に連絡します。また、その責任においては、有限会社ひろめカンパニーの指示に従います',
                    style: TextStyle(
                      color: kRedColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SourceHanSansJP-Bold',
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('緊急連絡先：セコム コールセンター（088-885-6060）'),
                        Text('百田 携帯（090-4506-0049）'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const DottedDivider(),
                  const SizedBox(height: 32),
                  CustomButton(
                    type: ButtonSizeType.lg,
                    label: '入力内容を確認',
                    labelColor: kWhiteColor,
                    backgroundColor: kBlueColor,
                    onPressed: () async {
                      String? error = await overtimeProvider.check(
                        companyName: companyName.text,
                        companyUserName: companyUserName.text,
                        companyUserEmail: companyUserEmail.text,
                        companyUserTel: companyUserTel.text,
                      );
                      if (error != null) {
                        if (!mounted) return;
                        showMessage(context, error, false);
                        return;
                      }
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: Step2Screen(
                            companyName: companyName.text,
                            companyUserName: companyUserName.text,
                            companyUserEmail: companyUserEmail.text,
                            companyUserTel: companyUserTel.text,
                            useStartedAt: useStartedAt,
                            useEndedAt: useEndedAt,
                            useAtPending: useAtPending,
                            useContent: useContent.text,
                          ),
                        ),
                      );
                    },
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
