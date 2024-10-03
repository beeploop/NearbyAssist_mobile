import 'package:flutter/material.dart';
import 'package:nearby_assist/main.dart';
import 'package:nearby_assist/services/complaint_service.dart';
import 'package:nearby_assist/widgets/custom_drawer.dart';

class Complaints extends StatelessWidget {
  const Complaints({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Complaints',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: FutureBuilder(
          future: getIt.get<ComplaintService>().fetchComplaints(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              final err = snapshot.error.toString();
              return Text(err, textAlign: TextAlign.center);
            }

            if (snapshot.hasData) {
              final complaints = snapshot.data;

              if (complaints == null || complaints.isEmpty) {
                return const Text('No complaints');
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await getIt.get<ComplaintService>().fetchComplaints();
                },
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final complaint = complaints[index];

                    return ListTile(
                      title: Text(complaint),
                    );
                  },
                ),
              );
            }

            return const Text('Something went wrong');
          },
        ),
      ),
    );
  }
}
