import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/lost.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/lost.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/file_link.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/form_value.dart';
import 'package:provider/provider.dart';

class LostModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final LostModel lost;

  const LostModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.lost,
    super.key,
  });

  @override
  State<LostModScreen> createState() => _LostModScreenState();
}

class _LostModScreenState extends State<LostModScreen> {
  DateTime discoveryAt = DateTime.now();
  TextEditingController discoveryPlaceController = TextEditingController();
  TextEditingController discoveryUserController = TextEditingController();
  TextEditingController itemNumberController = TextEditingController();
  TextEditingController itemNameController = TextEditingController();
  XFile? itemImageXFile;
  TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    discoveryAt = widget.lost.discoveryAt;
    discoveryPlaceController.text = widget.lost.discoveryPlace;
    discoveryUserController.text = widget.lost.discoveryUser;
    itemNumberController.text = widget.lost.itemNumber;
    itemNameController.text = widget.lost.itemName;
    remarksController.text = widget.lost.remarks;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lostProvider = Provider.of<LostProvider>(context);
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.chevronLeft,
            color: kBlackColor,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          '落とし物情報の編集',
          style: TextStyle(color: kBlackColor),
        ),
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  FormLabel(
                    '発見日',
                    child: FormValue(
                      dateText('yyyy/MM/dd HH:mm', discoveryAt),
                      onTap: () async {
                        picker.DatePicker.showDateTimePicker(
                          context,
                          showTitleActions: true,
                          minTime: kFirstDate,
                          maxTime: kLastDate,
                          theme: kDatePickerTheme,
                          onConfirm: (value) {
                            setState(() {
                              discoveryAt = value;
                            });
                          },
                          currentTime: discoveryAt,
                          locale: picker.LocaleType.jp,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  FormLabel(
                    '発見場所',
                    child: CustomTextField(
                      controller: discoveryPlaceController,
                      textInputType: TextInputType.text,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FormLabel(
                    '発見者',
                    child: CustomTextField(
                      controller: discoveryUserController,
                      textInputType: TextInputType.text,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FormLabel(
                    '落とし物No',
                    child: CustomTextField(
                      controller: itemNumberController,
                      textInputType: TextInputType.text,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FormLabel(
                    '品名',
                    child: CustomTextField(
                      controller: itemNameController,
                      textInputType: TextInputType.text,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FormLabel(
                    '添付写真',
                    child: GestureDetector(
                      onTap: () async {
                        final result = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        setState(() {
                          itemImageXFile = result;
                        });
                      },
                      child: itemImageXFile != null
                          ? Image.file(
                              File(itemImageXFile!.path),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : widget.lost.itemImage != ''
                              ? FileLink(file: widget.lost.itemImage)
                              : Container(
                                  color: kGreyColor.withOpacity(0.3),
                                  width: double.infinity,
                                  height: 100,
                                  child: const Center(
                                    child: Text('写真が選択されていません'),
                                  ),
                                ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FormLabel(
                    '備考',
                    child: CustomTextField(
                      controller: remarksController,
                      textInputType: TextInputType.text,
                      maxLines: 10,
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          String? error = await lostProvider.update(
            organization: widget.loginProvider.organization,
            lost: widget.lost,
            discoveryAt: discoveryAt,
            discoveryPlace: discoveryPlaceController.text,
            discoveryUser: discoveryUserController.text,
            itemNumber: itemNumberController.text,
            itemName: itemNameController.text,
            itemImageXFile: itemImageXFile,
            remarks: remarksController.text,
            loginUser: widget.loginProvider.user,
          );
          if (error != null) {
            if (!mounted) return;
            showMessage(context, error, false);
            return;
          }
          if (!mounted) return;
          showMessage(context, '落とし物情報が変更されました', true);
          Navigator.pop(context);
        },
        icon: const FaIcon(
          FontAwesomeIcons.floppyDisk,
          color: kWhiteColor,
        ),
        label: const Text(
          '保存する',
          style: TextStyle(color: kWhiteColor),
        ),
      ),
      bottomNavigationBar: CustomFooter(
        loginProvider: widget.loginProvider,
        homeProvider: widget.homeProvider,
      ),
    );
  }
}
