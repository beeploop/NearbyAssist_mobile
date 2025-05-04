import 'package:flutter/material.dart';

class ServicePublish extends StatefulWidget {
  const ServicePublish({super.key});

  @override
  State<ServicePublish> createState() => _ServicePublishState();
}

class _ServicePublishState extends State<ServicePublish> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Final Steps
        const Text(
          'Final Step:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
            'Make sure all the information you provided is correct and accurately reflects the service you are offering. You can go back to make any changes if needed.'),

        // Important Notes
        const SizedBox(height: 20),
        const Text(
          'Important Notes:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ..._importantNote(
          'Visibility',
          'Once published, your service will be visible to users searching for services with your selected search tags and location. Ensure your search tags are clear and attractive to potential clients.',
        ),
        const SizedBox(height: 10),
        ..._importantNote(
          'Communication',
          'Interested users may contact you through the platform’s chat feature to discuss details or ask questions. Be prompt and professional in your responses.',
        ),
        const SizedBox(height: 10),
        ..._importantNote(
          'Reputation',
          'Your rating and reviews will play a significant role in attracting clients. Provide excellent service to ensure positive feedback.',
        ),
        const SizedBox(height: 10),
        ..._importantNote(
          'Updates',
          'You can edit your service details, price, or availability at any time from your management dashboard.',
        ),
        const SizedBox(height: 10),
        ..._importantNote(
          'Compliance',
          'Ensure your service complies with the platform’s terms of service, and any necessary certifications or licenses are uploaded if required.',
        ),
        const SizedBox(height: 10),

        // What's Next
        const SizedBox(height: 20),
        const Text(
          'What Happens Next?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Once you click Publish, your service will be live and available for users to view and book. You will receive notifications for inquiries and bookings. Manage your services through your dashboard for an efficient experience.',
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  List<Text> _importantNote(String title, String content) {
    return [
      Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(content),
    ];
  }
}
