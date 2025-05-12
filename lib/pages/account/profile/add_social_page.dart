import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/models/social_model.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
import 'package:nearby_assist/utils/show_generic_success_modal.dart';
import 'package:nearby_assist/utils/social_type_icon.dart';
import 'package:provider/provider.dart';

class AddSocialPage extends StatefulWidget {
  const AddSocialPage({super.key});

  @override
  State<AddSocialPage> createState() => _AddSocialPageState();
}

class _AddSocialPageState extends State<AddSocialPage> {
  bool _submittable = false;
  SocialType _selectedSocialType = SocialType.other;
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_inputListener);
    _urlController.addListener(_inputListener);
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.removeListener(_inputListener);
    _urlController.removeListener(_inputListener);
  }

  void _inputListener() {
    if (_titleController.text.trim().isNotEmpty &&
        _urlController.text.trim().isNotEmpty) {
      setState(() {
        _submittable = true;
      });
    } else {
      setState(() {
        _submittable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Social type
              DropdownButtonFormField<SocialType>(
                isExpanded: true,
                value: _selectedSocialType,
                items: SocialType.values
                    .map((social) => DropdownMenuItem(
                          value: social,
                          child: Row(
                            children: [
                              Text(social.name),
                              const Spacer(),
                              FaIcon(siteIcon(social), size: 18),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (type) {
                  _selectedSocialType = type ?? SocialType.other;
                },
                decoration: const InputDecoration(
                  labelText: 'Social',
                  border: OutlineInputBorder(),
                  hintText: 'Social Media',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              TextFormField(
                controller: _titleController,
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  hintText: 'Name',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),

              // URL
              TextFormField(
                controller: _urlController,
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                decoration: const InputDecoration(
                  labelText: 'URL',
                  border: OutlineInputBorder(),
                  hintText: 'URL',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: FilledButton(
            onPressed: _submittable ? _handleAdd : () {},
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              backgroundColor: WidgetStatePropertyAll(
                !_submittable ? Colors.grey : null,
              ),
              minimumSize: const WidgetStatePropertyAll(
                Size.fromHeight(50),
              ),
            ),
            child: const Text('Submit'),
          ),
        ),
      ),
    );
  }

  Future<void> _handleAdd() async {
    final loader = context.loaderOverlay;
    try {
      loader.show();

      if (_titleController.text.isEmpty || _urlController.text.isEmpty) {
        throw "Don't leave empty fields";
      }

      final data = NewSocial(
        site: _selectedSocialType,
        title: _titleController.text,
        url: _urlController.text,
      );

      await context.read<UserProvider>().addSocial(data);

      if (!mounted) return;
      showGenericSuccessModal(context, message: 'Link to social account added');
    } on DioException catch (error) {
      if (!mounted) return;
      showGenericErrorModal(context, message: error.response?.data['message']);
    } catch (error) {
      if (!mounted) return;
      showGenericErrorModal(context, message: error.toString());
    } finally {
      loader.hide();
    }
  }
}
