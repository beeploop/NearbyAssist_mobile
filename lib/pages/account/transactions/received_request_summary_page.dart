import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nearby_assist/models/transaction_model.dart';
import 'package:nearby_assist/models/user_model.dart';
import 'package:nearby_assist/pages/booking/widget/row_tile.dart';
import 'package:nearby_assist/providers/transaction_provider.dart';
import 'package:nearby_assist/providers/user_provider.dart';
import 'package:nearby_assist/utils/restricted_account_modal.dart';
import 'package:provider/provider.dart';

class ReceivedRequestSummaryPage extends StatefulWidget {
  const ReceivedRequestSummaryPage({
    super.key,
    required this.transaction,
  });

  final TransactionModel transaction;

  @override
  State<ReceivedRequestSummaryPage> createState() =>
      _ReceivedRequestSummaryPageState();
}

class _ReceivedRequestSummaryPageState
    extends State<ReceivedRequestSummaryPage> {
  final _scheduleController = TextEditingController();
  late UserModel _user;

  @override
  void initState() {
    super.initState();

    _user = Provider.of<UserProvider>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
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
        body: _body(context),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Row(
            children: [
              // Reject button
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: widget.transaction.status == 'cancelled'
                          ? Colors.grey
                          : Colors.red,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: widget.transaction.status != 'cancelled'
                      ? _onTapReject
                      : () {},
                  child: Text(
                    'Reject',
                    style: TextStyle(
                      color: widget.transaction.status == 'cancelled'
                          ? Colors.grey
                          : Colors.red,
                    ),
                  ),
                ),
              ),

              // Gap
              const SizedBox(width: 10),

              // Accept button
              Expanded(
                child: FilledButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      widget.transaction.status == 'cancelled'
                          ? Colors.grey
                          : null,
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: widget.transaction.status != 'cancelled'
                      ? _onTapAccept
                      : () {},
                  child: const Text('Accept'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _body(BuildContext context) {
    return Padding(
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
            AutoSizeText(widget.transaction.service.title),
            const SizedBox(height: 10),
            RowTile(
                label: 'Base Rate:',
                text: '₱ ${widget.transaction.service.rate}'),
            const SizedBox(height: 20),
            const AutoSizeText(
              'Extras:',
              style: TextStyle(
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

            // Bottom padding
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _onTapAccept() {
    if (_user.isRestricted) {
      showAccountRestrictedModal(context);
      return;
    }

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
        title: const Text(
          'Set a schedule for this booking',
          style: TextStyle(fontSize: 20),
        ),
        content: TextField(
          controller: _scheduleController,
          decoration: const InputDecoration(
            labelText: 'Schedule',
            filled: true,
            prefixIcon: Icon(CupertinoIcons.calendar),
          ),
          readOnly: true,
          onTap: _pickDate,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _confirmRequest(
              widget.transaction.id,
              _scheduleController.text,
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _onTapReject() {
    if (_user.isRestricted) {
      showAccountRestrictedModal(context);
      return;
    }

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
            onPressed: () => _rejectRequest(widget.transaction.id),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmRequest(String id, String schedule) async {
    final loader = context.loaderOverlay;

    try {
      loader.show();
      Navigator.pop(context);

      if (schedule.isEmpty) {
        throw 'Invalid schedule';
      }

      final transactionProvider = context.read<TransactionProvider>();
      await transactionProvider.acceptTransactionRequest(id, schedule);

      _onSuccess();
    } on DioException catch (error) {
      _onError(error.response?.data['message']);
    } catch (error) {
      _onError(error.toString());
    } finally {
      loader.hide();
    }
  }

  Future<void> _rejectRequest(String id) async {
    final loader = context.loaderOverlay;

    try {
      loader.show();

      Navigator.pop(context);

      await context.read<TransactionProvider>().rejectTransactionRequest(id);
      _onSuccess();
    } on DioException catch (error) {
      _onError(error.response?.data['error']);
    } catch (error) {
      _onError(error.toString());
    } finally {
      loader.hide();
    }
  }

  Future<void> _pickDate() async {
    DateTime? schedule = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
          const Duration(days: 30)), // restrict schedule to 30 days advance
    );

    if (schedule == null) return;

    setState(() {
      _scheduleController.text = schedule.toString().split(" ")[0];
    });
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
