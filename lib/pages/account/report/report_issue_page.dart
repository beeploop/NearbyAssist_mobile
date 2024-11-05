import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/account/report/widget/input_field.dart';

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({super.key});

  @override
  State<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final _titleController = TextEditingController();
  final _detailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Report Issue',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            InputField(
              controller: _titleController,
              labelText: 'Title',
              hintText: 'title of the issue',
            ),
            const SizedBox(height: 10),
            InputField(
              controller: _detailController,
              hintText: 'Describe the issue in more detail',
              minLines: 4,
              maxLines: 8,
            ),
            const SizedBox(height: 10),
            FilledButton(
              style: const ButtonStyle(
                minimumSize: WidgetStatePropertyAll(Size.fromHeight(50)),
              ),
              onPressed: () {},
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
