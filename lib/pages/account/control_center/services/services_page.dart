import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/pages/account/control_center/services/widget/service_item.dart';
import 'package:nearby_assist/pages/account/services/publish_service/publish_service_page.dart';
import 'package:nearby_assist/providers/control_center_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/show_restricted_account_modal.dart';
import 'package:provider/provider.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  bool _showDisabled = false;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Services',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(CupertinoIcons.ellipsis_vertical),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () {
                  setState(() => _showDisabled = !_showDisabled);
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        CupertinoIcons.checkmark_circle,
                        size: 18,
                        color: _showDisabled ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      const Text('show disabled'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<ControlCenterProvider>(
        builder: (context, provider, _) {
          return RefreshIndicator(
            onRefresh: () => provider.fetchServices(user.id),
            child: provider.services.isEmpty
                ? _emptyState()
                : _buildBody(provider.services),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: !user.isVendor ? Colors.grey : null,
        onPressed: () {
          if (!user.isVendor) return;
          if (user.isRestricted) {
            showAccountRestrictedModal(context);
            return;
          }

          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => const PublishServicePage(),
            ),
          );
        },
        child: const Icon(CupertinoIcons.plus),
      ),
    );
  }

  Widget _buildBody(List<ServiceModel> services) {
    final displayable = services.where((service) {
      if (_showDisabled) return true;
      return !service.disabled;
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: displayable.length,
        itemBuilder: (context, index) =>
            ServiceItem(service: displayable[index]),
      ),
    );
  }

  Widget _emptyState() {
    return ListView(
      children: [
        Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.tray, color: Colors.grey),
              SizedBox(height: 10),
              Text(
                'No services',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
