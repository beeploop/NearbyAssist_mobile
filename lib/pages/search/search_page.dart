import 'package:flutter/material.dart';
import 'package:nearby_assist/pages/search/search_page_v1.dart';
import 'package:nearby_assist/pages/search/search_page_v2.dart';
import 'package:nearby_assist/providers/system_setting_provider.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SystemSettingProvider>(
      builder: (context, provider, _) {
        if (provider.welcomePage == SearchPageVersion.version2) {
          return const SearchPageV2();
        }

        return const SearchPageV1();
      },
    );
  }
}
