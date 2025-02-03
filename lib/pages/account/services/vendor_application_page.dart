import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/expertise_model.dart';
import 'package:nearby_assist/pages/account/profile/widget/fillable_image_container.dart';
import 'package:nearby_assist/pages/account/profile/widget/fillable_image_container_controller.dart';
import 'package:nearby_assist/pages/widget/clickable_text.dart';
import 'package:nearby_assist/pages/widget/divider_with_text.dart';
import 'package:nearby_assist/providers/expertise_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/services/vendor_application_service.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class VendorApplicationPage extends StatefulWidget {
  const VendorApplicationPage({super.key});

  @override
  State<VendorApplicationPage> createState() => _VendorApplicationPageState();
}

class _VendorApplicationPageState extends State<VendorApplicationPage> {
  bool _isLoading = false;
  List<ExpertiseModel> _expertiseList = [];
  ExpertiseModel? _selectedExpertise;
  List<String> _unlockables = [];
  final _supportingDocController = FillableImageContainerController();
  final _policeClearanceController = FillableImageContainerController();
  bool _hasAgreedToTAC = false;

  @override
  void initState() {
    super.initState();

    _expertiseList =
        Provider.of<ExpertiseProvider>(context, listen: false).expertise;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Vendor Application',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: buildBody(),
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

  Widget buildBody() {
    final isVerified = context.read<UserProvider>().user.isVerified;

    if (isVerified == false) {
      return Center(
        child: AlertDialog(
          icon: const Icon(CupertinoIcons.exclamationmark_triangle),
          title: const Text('Account not verified'),
          content:
              const Text('Please verify your account to unlock more features'),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => context.pushNamed('verifyAccount'),
              child: const Text('Verify'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _tagsDropdown(),
            const SizedBox(height: 20),
            const Text('Selected expertise will unlock the following tags:'),
            Text(
              _unlockables.join(', '),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const DividerWithText(text: 'Supporting Document'),
            const SizedBox(height: 10),
            const Text(
              'Document that prove you are capable of offering satisfactory service for this role. Example documents are license and certifications',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                FillableImageContainer(
                  controller: _supportingDocController,
                  icon: CupertinoIcons.doc_on_clipboard,
                  labelText: 'Supporting Document',
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.orange[200]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const DividerWithText(text: 'Police Clearance'),
            const SizedBox(height: 10),
            Row(
              children: [
                FillableImageContainer(
                  controller: _policeClearanceController,
                  icon: CupertinoIcons.doc_on_clipboard,
                  labelText: 'Police Clearance',
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.orange[200]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _checkboxTAC(),
            const SizedBox(height: 10),
            FilledButton(
              style: const ButtonStyle(
                minimumSize: WidgetStatePropertyAll(Size.fromHeight(50)),
              ),
              onPressed: _handleSubmit,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tagsDropdown() {
    return DropdownSearch<ExpertiseModel>(
      decoratorProps: const DropDownDecoratorProps(
        decoration: InputDecoration(
          hintText: 'Select expertise',
          border: OutlineInputBorder(),
        ),
      ),
      popupProps: PopupPropsMultiSelection.modalBottomSheet(
        containerBuilder: (context, child) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: child,
          );
        },
        modalBottomSheetProps: const ModalBottomSheetProps(
          showDragHandle: true,
        ),
        showSearchBox: true,
        showSelectedItems: true,
        searchFieldProps: const TextFieldProps(
          decoration: InputDecoration(
            hintText: 'filter list',
          ),
        ),
        searchDelay: const Duration(milliseconds: 500),
      ),
      autoValidateMode: AutovalidateMode.always,
      items: (filter, props) => _expertiseList,
      itemAsString: (expertise) => expertise.title,
      compareFn: (expertise, selected) => expertise.id == selected.id,
      selectedItem: _selectedExpertise,
      onChanged: (item) => setState(() {
        _selectedExpertise = item;
        final unlocks =
            context.read<ExpertiseProvider>().getTagsOfExpertise(item?.id);

        setState(() {
          _unlockables = unlocks.map((e) => e.title).toList();
        });
      }),
    );
  }

  Widget _checkboxTAC() {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Checkbox(
          value: _hasAgreedToTAC,
          onChanged: (bool? value) => setState(() => _hasAgreedToTAC = value!),
        ),
        ClickableText(
          text: "I agreed to the ",
          clickableText: "terms and conditions.",
          onClick: () async {
            final url = Uri.parse(endpoint.termsAndConditions);
            if (!await launchUrl(url)) {
              _showErrorModal('Could not launch $url');
            }
          },
        ),
      ],
    );
  }

  void _showLoader() {
    setState(() {
      _isLoading = true;
    });
  }

  void _hideLoader() {
    setState(() {
      _isLoading = false;
    });
  }

  void _handleSubmit() async {
    if (!_hasAgreedToTAC) {
      _showErrorModal('You did not agreed to the terms and conditions');
      return;
    }

    if (_selectedExpertise == null) {
      _showErrorModal('Please select a tag');
      return;
    }

    if (_supportingDocController.image == null ||
        _policeClearanceController.image == null) {
      _showErrorModal('Please upload all required documents');
      return;
    }

    _showLoader();

    try {
      final service = VendorApplicationService();
      await service.apply(
        expertise: _selectedExpertise!,
        supportingDoc: _supportingDocController.imageBytes!,
        policeClearance: _supportingDocController.imageBytes!,
      );

      _showSuccessModal();
    } catch (error) {
      _showErrorModal(error.toString());
    } finally {
      _hideLoader();
    }
  }

  void _showSuccessModal() {
    showCustomSnackBar(
      context,
      'Request submitted. We are reviewing your request and will get back to you',
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.green,
      textColor: Colors.white,
      closeIconColor: Colors.white,
    );

    context.pop();
  }

  void _showErrorModal(String error) {
    showCustomSnackBar(
      context,
      error,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.red,
      textColor: Colors.white,
      closeIconColor: Colors.white,
    );
  }
}
