import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nearby_assist/models/service_model.dart';
import 'package:nearby_assist/pages/account/services/detail/edit_page.dart';
import 'package:nearby_assist/utils/money_formatter.dart';

class Overview extends StatefulWidget {
  const Overview({super.key, required this.service});

  final ServiceModel service;

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Edit Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.penToSquare),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => EditPage(service: widget.service),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Title
            _label('Title'),
            Text(widget.service.title),
            const SizedBox(height: 20),

            // Description
            _label('Description'),
            Text(widget.service.description),
            const SizedBox(height: 20),

            // Rate
            _label('Rate'),
            Text(
              formatCurrency(widget.service.rate),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Tags
            _label('Tags'),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                ...widget.service.tags.map((tag) => _chip(tag.title)),
              ],
            ),

            // Bottom padding
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _label(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _chip(String label) {
    return Chip(
      label: Text(label),
      labelStyle: const TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: Colors.green.shade600,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.all(2),
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    );
  }
}
