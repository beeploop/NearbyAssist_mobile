import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/models/expertise_model.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:nearby_assist/pages/account/profile/widget/fillable_image_container.dart';
import 'package:nearby_assist/pages/account/profile/widget/fillable_image_container_controller.dart';
import 'package:nearby_assist/pages/widget/clickable_text.dart';
import 'package:nearby_assist/pages/widget/divider_with_text.dart';
import 'package:nearby_assist/providers/expertise_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/custom_snackbar.dart';
import 'package:nearby_assist/utils/show_generic_error_modal.dart';
import 'package:nearby_assist/utils/show_generic_success_modal.dart';
import 'package:nearby_assist/utils/show_restricted_account_modal.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AddVendorExpertisePage extends StatefulWidget {
  const AddVendorExpertisePage({super.key});

  @override
  State<AddVendorExpertisePage> createState() => _AddVendorExpertisePageState();
}

class _AddVendorExpertisePageState extends State<AddVendorExpertisePage> {
  List<ExpertiseModel> _expertiseList = [];
  ExpertiseModel? _selectedExpertise;
  List<String> _unlockables = [];
  final _supportingDocController = FillableImageContainerController();
  bool _hasAgreedToTAC = false;

  @override
  void initState() {
    super.initState();

    _expertiseList =
        Provider.of<ExpertiseProvider>(context, listen: false).expertise;
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Vendor Application',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Consumer<UserProvider>(
          builder: (context, provider, _) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _tagsDropdown(provider.user.expertise),
                    const SizedBox(height: 20),
                    const Text(
                        'Selected expertise will unlock the following tags:'),
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
                            decoration:
                                BoxDecoration(color: Colors.orange.shade200),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _checkboxTAC(),
                    const SizedBox(height: 10),
                    FilledButton(
                      style: const ButtonStyle(
                        minimumSize:
                            WidgetStatePropertyAll(Size.fromHeight(50)),
                      ),
                      onPressed: () => _handleSubmit(provider.user),
                      child: const Text('Submit'),
                    ),

                    // Bottom padding
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _tagsDropdown(List<ExpertiseModel> expertise) {
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
      items: (filter, props) => _expertiseList
          .where((entry) => !expertise.map((e) => e.id).contains(entry.id))
          .toList(),
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
              if (!mounted) return;
              showCustomSnackBar(
                context,
                'Could not open URL',
                backgroundColor: Colors.red,
                textColor: Colors.white,
                closeIconColor: Colors.white,
                duration: const Duration(seconds: 3),
              );
            }
          },
        ),
      ],
    );
  }

  void _handleSubmit(UserModel user) async {
    final loader = context.loaderOverlay;

    if (user.isRestricted) {
      showAccountRestrictedModal(context);
      return;
    }

    try {
      loader.show();

      if (!_hasAgreedToTAC) {
        throw 'You did not agreed to the terms and conditions';
      }

      if (_selectedExpertise == null) {
        throw 'Please select an expertise';
      }

      if (_supportingDocController.image == null) {
        throw 'Upload required documents';
      }

      await context.read<UserProvider>().addExpertise(
            _selectedExpertise!,
            _supportingDocController.imageBytes!,
          );

      if (!mounted) return;
      showGenericSuccessModal(
        context,
        title: 'Request submitted',
        message:
            'Your request will be processed and reviewed. You will get a notification once done.',
      );
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
