import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';

class AddSocialPage extends StatefulWidget {
  const AddSocialPage({super.key});

  @override
  State<AddSocialPage> createState() => _AddSocialPageState();
}

class _AddSocialPageState extends State<AddSocialPage> {
  bool _isLoading = false;
  final _socialUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Add Social'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _socialUrlController,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    decoration: const InputDecoration(
                      labelText: 'Social URL',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Submit button
                  FilledButton(
                    onPressed: _handleSubmit,
                    style: ButtonStyle(
                      minimumSize: const WidgetStatePropertyAll(
                        Size.fromHeight(50),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    child: const Text('Submit'),
                  ),

                  // Bottom padding
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),

        // Show loading overlay
        if (_isLoading)
          const Opacity(
            opacity: 0.8,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  void _toggleLoader(bool state) {
    setState(() {
      _isLoading = state;
    });
  }

  Future<void> _handleSubmit() async {
    try {
      _toggleLoader(true);

      if (_socialUrlController.text.isEmpty) return;

      final provider = context.read<UserProvider>();

      await provider.addSocial(_socialUrlController.text);
      _onSuccess();
    } on DioException catch (error) {
      _onError(error.response?.data['message']);
    } catch (error) {
      _onError(error.toString());
    } finally {
      _toggleLoader(false);
    }
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onError(String error) {
    showCustomSnackBar(
      context,
      error,
      backgroundColor: Colors.red,
      closeIconColor: Colors.white,
      textColor: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}
