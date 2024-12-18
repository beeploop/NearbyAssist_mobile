import 'package:flutter/material.dart';
import 'package:nearby_assist/models/rating_count_model.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/pages/account/services/widget/rating_count_bar.dart';

class DetailTabSection extends StatelessWidget {
  const DetailTabSection({
    super.key,
    required this.service,
    required this.rating,
  });

  final ServiceModel service;
  final RatingCountModel rating;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Column(
          children: [
            TabBar(
              unselectedLabelColor: Colors.grey,
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.all(10),
              indicator: BoxDecoration(
                color: Colors.green[700],
                borderRadius: BorderRadius.circular(20),
              ),
              labelColor: Colors.white,
              tabs: const [
                Tab(child: Text("Description")),
                Tab(child: Text("Reviews")),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: 300,
              child: TabBarView(
                children: [
                  _decriptionSection(),
                  _reviewSection(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _decriptionSection() {
    return Text(
      service.description,
    );
  }

  Widget _reviewSection(BuildContext context) {
    final totalReview =
        rating.one + rating.two + rating.three + rating.four + rating.five;

    return Column(
      children: [
        Text(
          'Total reviews: $totalReview',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 160,
          child: RatingCountBar(rating: rating),
        ),
        TextButton(
          onPressed: () => _showReviews(context),
          child: const Text("see reviews"),
        ),
      ],
    );
  }

  void _showReviews(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.60,
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Text(
                "Reviews",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: const AssetImage('assets/images/avatar.png'),
                  backgroundColor: Colors.green[800],
                ),
                title: const Text(
                  "user 1",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: const Text("review 1"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
