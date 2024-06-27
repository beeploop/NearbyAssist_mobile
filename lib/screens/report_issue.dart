import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/custom_file_picker.dart';
import 'package:nearby_assist/services/system_complaint_service.dart';
import 'package:nearby_assist/widgets/custom_drawer.dart';
import 'package:nearby_assist/widgets/input_box.dart';
import 'package:nearby_assist/widgets/listenable_loading_button.dart';
import 'package:nearby_assist/widgets/text_heading.dart';

class ReportIssue extends StatefulWidget {
  const ReportIssue({super.key});

  @override
  State<ReportIssue> createState() => _ReportIssue();
}

class _ReportIssue extends State<ReportIssue> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: const CustomDrawer(),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const TextHeading(title: 'Report System Issue'),
            const Divider(),
            InputBox(controller: _titleController, hintText: 'Report title'),
            ListenableBuilder(
              listenable: getIt.get<SystemComplaintService>(),
              builder: (context, _) {
                final images = getIt
                    .get<SystemComplaintService>()
                    .getSystemComplaintImages();

                if (images.isEmpty) {
                  return const SizedBox(
                    height: 50,
                    child: Center(
                      child: Text('No images selected'),
                    ),
                  );
                }

                return Row(
                  children: [
                    for (var image in images)
                      Image.memory(
                        image.readAsBytesSync(),
                        width: 100,
                        height: 100,
                      )
                  ],
                );
              },
            ),
            ElevatedButton(
              onPressed: () => _pickFiles(),
              child: const Text('Select Image'),
            ),
            InputBox(
              controller: _commentController,
              hintText: 'Describe the issue in more detail',
              lines: 10,
            ),
            ListenableLoadingButton(
              listenable: getIt.get<SystemComplaintService>(),
              isLoadingFunction: () =>
                  getIt.get<SystemComplaintService>().isUploading(),
              onPressed: () async {
                final isLoading =
                    getIt.get<SystemComplaintService>().isUploading();
                if (isLoading) {
                  return;
                }

                final result = await _handleSubmit();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result.message),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _pickFiles() async {
    final filePicker = CustomFilePicker();
    final files = await filePicker.pickFiles();
    getIt.get<SystemComplaintService>().setSystemComplaintImages(files);
  }

  Future<SystemComplaintResult> _handleSubmit() async {
    if (_titleController.text.isEmpty || _commentController.text.isEmpty) {
      return SystemComplaintResult(
          message: 'Please fill in all fields', success: false);
    }

    if (getIt
        .get<SystemComplaintService>()
        .getSystemComplaintImages()
        .isEmpty) {
      return SystemComplaintResult(
          message: 'Provide image/s of the issue', success: false);
    }

    final complaint = SystemComplaintModel(
      title: _titleController.text,
      detail: _commentController.text,
    );

    final result = await getIt
        .get<SystemComplaintService>()
        .fileSystemComplaint(complaint);

    _titleController.clear();
    _commentController.clear();

    return result;
  }

  @override
  void dispose() {
    getIt.get<SystemComplaintService>().clearSystemComplaintImages();
    super.dispose();
  }
}
