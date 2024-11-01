import 'package:flutter/material.dart';

class ImageSection extends StatelessWidget {
  const ImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.green[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _initialImages(),
          Center(
            child: TextButton(
              onPressed: () => _showMoreImages(context),
              child: const Text("view more"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _initialImages() {
    return Wrap(
      spacing: 10,
      children: [
        SizedBox(
          height: 40,
          width: 40,
          child: Container(
            decoration: BoxDecoration(color: Colors.grey[300]),
          ),
        ),
        SizedBox(
          height: 40,
          width: 40,
          child: Container(
            decoration: BoxDecoration(color: Colors.grey[300]),
          ),
        ),
        SizedBox(
          height: 40,
          width: 40,
          child: Container(
            decoration: BoxDecoration(color: Colors.grey[300]),
          ),
        ),
      ],
    );
  }

  void _showMoreImages(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.60,
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: const Column(
            children: [
              Text(
                "Service Photos",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
