import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/history_service.dart';

class History extends StatelessWidget {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: getIt.get<HistoryService>().fetchHistory(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              final err = snapshot.error.toString();
              return Text(
                'Error occurred: $err',
                textAlign: TextAlign.center,
              );
            }

            if (snapshot.hasData && snapshot.data != null) {
              final history = snapshot.data;

              if (history == null || history.isEmpty) {
                return const Text('No history!');
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await getIt.get<HistoryService>().fetchHistory();
                },
                child: ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final event = history[index];

                    return ListTile(
                      title: Text(event),
                    );
                  },
                ),
              );
            }

            return const Text('Something went wrong!');
          },
        ),
      ),
    );
  }
}
