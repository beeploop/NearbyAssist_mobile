import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nearby_assist/models/booking_model.dart';
import 'package:nearby_assist/pages/booking/widget/row_tile.dart';
import 'package:nearby_assist/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class ReceivedRequestSummaryPage extends StatefulWidget {
  const ReceivedRequestSummaryPage({
    super.key,
    required this.transaction,
  });

  final BookingModel transaction;

  @override
  State<ReceivedRequestSummaryPage> createState() =>
      _ReceivedRequestSummaryPageState();
}

class _ReceivedRequestSummaryPageState
    extends State<ReceivedRequestSummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Received',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pushNamed(
                'chat',
                queryParameters: {
                  'recipientId': widget.transaction.clientId,
                  'recipient': widget.transaction.client,
                },
              );
            },
            icon: const Icon(CupertinoIcons.ellipses_bubble),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status
              Row(
                children: [
                  Text('Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      )),
                  const Spacer(),
                  _chip(widget.transaction.status),
                ],
              ),
              const Divider(),

              // Vendor information
              const SizedBox(height: 20),
              const Text('Vendor Information', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              RowTile(label: 'Vendor Name:', text: widget.transaction.vendor),
              const Divider(),

              // Client information
              const SizedBox(height: 20),
              const Text('Client Information', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              RowTile(label: 'Client Name:', text: widget.transaction.client),
              const Divider(),

              // Service Price
              const SizedBox(height: 20),
              const Text('Service Information', style: TextStyle(fontSize: 16)),

              // Extras
              const SizedBox(height: 20),
              Text(
                widget.transaction.service.title,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              RowTile(
                  label: 'Base Rate:',
                  text: '₱ ${widget.transaction.service.rate}'),
              const SizedBox(height: 20),
              const Text(
                'Extras:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...widget.transaction.extras.map((extra) {
                return RowTile(
                  label: extra.title,
                  text: '₱ ${extra.price}',
                  withLeftPad: true,
                );
              }),
              const SizedBox(height: 20),
              const Divider(),

              // Estimated cost
              const SizedBox(height: 20),
              RowTile(label: 'Total Cost:', text: '₱ ${_calculateTotalCost()}'),
              const SizedBox(height: 20),

              // Confirm Button
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      icon: const Icon(
                        CupertinoIcons.question_circle,
                        color: Colors.green,
                        size: 40,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: const Text('Accept this request?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () =>
                              _confirmRequest(widget.transaction.id),
                          child: const Text('Continue'),
                        ),
                      ],
                    ),
                  );
                },
                style: ButtonStyle(
                  minimumSize:
                      const WidgetStatePropertyAll(Size.fromHeight(50)),
                  backgroundColor: WidgetStatePropertyAll(
                    Colors.green.shade800,
                  ),
                ),
                child: const Text('Confirm'),
              ),

              // Cancel Button
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      icon: const Icon(
                        CupertinoIcons.question_circle,
                        color: Colors.red,
                        size: 40,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: const Text('Reject this request?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () =>
                              _rejectRequest(widget.transaction.id),
                          child: const Text('Continue'),
                        ),
                      ],
                    ),
                  );
                },
                style: const ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(Size.fromHeight(50)),
                  backgroundColor: WidgetStatePropertyAll(Colors.red),
                ),
                child: const Text('Reject'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmRequest(String id) async {
    try {
      final transactionProvider = context.read<TransactionProvider>();
      await transactionProvider.acceptTransactionRequest(id);

      _onSuccess();
    } catch (error) {
      _onError(error.toString());
    }
  }

  Future<void> _rejectRequest(String id) async {
    try {
      await context.read<TransactionProvider>().rejectTransactionRequest(id);
      _onSuccess();
    } catch (error) {
      _onError(error.toString());
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

  Widget _chip(String label) {
    Color color;
    switch (label.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'confirmed':
        color = Colors.teal;
        break;
      case 'done':
        color = Colors.green;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(label),
      labelStyle: const TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.all(2),
      backgroundColor: color,
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    );
  }

  double _calculateTotalCost() {
    double total = widget.transaction.service.rate;
    for (final extra in widget.transaction.extras) {
      total += extra.price;
    }
    return total;
  }
}
