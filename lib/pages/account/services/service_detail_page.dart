import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/user_model.dart';
//import 'package:nearby_assist/pages/account/services/widget/detail_tab_section.dart';
import 'package:nearby_assist/pages/account/services/widget/image_section.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ServiceDetailPage extends StatefulWidget {
  const ServiceDetailPage({
    super.key,
    required this.serviceId,
  });

  final String serviceId;

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.gear),
            onPressed: () => context.pushNamed(
              'editService',
              queryParameters: {'serviceId': widget.serviceId},
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            Column(
              children: [
                _header(user),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                const ImageSection(),
                const SizedBox(height: 10),
                //const DetailTabSection(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(UserModel user) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.green[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 80,
            width: 80,
            child: Image.network(
              user.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, chunk) {
                if (chunk == null) {
                  return child;
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => context.pushNamed('manage'),
                  child: Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                RatingBar.builder(
                  initialRating: 0,
                  allowHalfRating: true,
                  itemSize: 20,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                  onRatingUpdate: (_) {},
                  ignoreGestures: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
