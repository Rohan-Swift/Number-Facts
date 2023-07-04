import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DateScreen extends StatefulWidget {
  const DateScreen({super.key});

  @override
  State<DateScreen> createState() => _DateScreenState();
}

class _DateScreenState extends State<DateScreen> {
  DateTime? selectedDate;
  String yearFact = '';
  bool isLoading = false;

  Future<String> fetchYearFact(String month, String date) async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    final response =
        await http.get(Uri.parse('http://numbersapi.com/$month/$date/date'));
    if (response.statusCode == 200) {
      setState(() {
        yearFact = response.body;
        isLoading = false;
      });
      return response.body;
    } else {
      setState(() {
        yearFact = 'Error: Unable to fetch the fact.';
        isLoading = false;
      });
      return 'Error: Unable to fetch the fact.';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(0),
      lastDate: DateTime(DateTime.now().year + 100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });

      final date = picked.day.toString();
      final month = picked.month.toString();

      fetchYearFact(month, date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Date facts'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select Date'),
            ),
            const SizedBox(height: 20),
            Text(
              'Selected Date: ${selectedDate?.toString().split(' ')[0] ?? 'N/A'}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                if (selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Center(
                        child: Text('Select a date first'),
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  final year = selectedDate!.year.toString();
                  final month = selectedDate!.month.toString();
                  fetchYearFact(year, month);
                }
              },
              child: const Text('Get fact about date'),
            ),
            const SizedBox(height: 30),
            isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: 300,
                    child: Text(
                      yearFact,
                      textAlign: TextAlign.center,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
