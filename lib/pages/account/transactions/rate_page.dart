import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/models/review_model.dart';
import 'package:nearby_assist/pages/account/widget/input_field.dart';
import 'package:nearby_assist/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class RatePage extends StatefulWidget {
  const RatePage({super.key, required this.transaction});

  final BookingModel transaction;

  @override
  State<RatePage> createState() => _RatePageState();
}

class _RatePageState extends State<RatePage> {
  final double _minimumRating = 1;
  double _rating = 1;
  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Rate Service',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: buildBody(),
      ),
    );
  }

  SingleChildScrollView buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Title
            Text(
              widget.transaction.service.title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Divider(),
            const SizedBox(height: 20),

            // Rating
            const Text('Rate Service'),
            const SizedBox(height: 10),
            RatingBar.builder(
              initialRating: _rating,
              allowHalfRating: false,
              itemBuilder: (context, _) => const Icon(
                CupertinoIcons.star_fill,
                color: Colors.amber,
              ),
              glow: true,
              glowColor: Colors.amber.shade300,
              itemPadding: const EdgeInsets.all(4),
              onRatingUpdate: (rating) {
                setState(() {
                  if (rating < _minimumRating) {
                    _rating = _minimumRating;
                  } else {
                    _rating = rating;
                  }
                });
              },
            ),
            const SizedBox(height: 20),

            // Review
            const Text('Write your thoughts'),
            const SizedBox(height: 10),
            InputField(
              hintText:
                  'Share your thoughts on this service to help other users.',
              controller: _reviewController,
              maxLines: 6,
              minLines: 4,
            ),
            const SizedBox(height: 20),

            // Submit Button
            FilledButton(
              onPressed: _handleSubmit,
              style: const ButtonStyle(
                minimumSize: WidgetStatePropertyAll(Size.fromHeight(50)),
              ),
              child: const Text('Submit'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final loader = context.loaderOverlay;

    try {
      loader.show();

      if (_reviewController.text.isEmpty) {
        throw 'Please leave a message';
      }

      final review = ReviewModel(
        transactionId: widget.transaction.id,
        serviceId: widget.transaction.service.id,
        rating: _rating.toInt(),
        text: _reviewController.text,
      );

      await context.read<TransactionProvider>().postReview(review);

      _onSuccess();
    } catch (error) {
      _onError(error.toString());
    } finally {
      loader.hide();
    }
  }

  void _onSuccess() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            CupertinoIcons.check_mark_circled_solid,
            color: Colors.green,
            size: 40,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Successful'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _onError(String error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: const Icon(
            CupertinoIcons.xmark_circle_fill,
            color: Colors.red,
            size: 40,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text('Failed'),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
