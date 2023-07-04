import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class YearScreen extends StatefulWidget {
  const YearScreen({super.key});

  @override
  State<YearScreen> createState() => _YearScreenState();
}

class _YearScreenState extends State<YearScreen> {
  TextEditingController yearTextController = TextEditingController();
  TextEditingController displayTextController = TextEditingController();
  FocusNode focusNode = FocusNode();
  String yearFact = '';
  bool isLoading = false;

  void sendParam() {
    final number = yearTextController.text;
    if (number.isNotEmpty) {
      fetchyearFact(number);
    }
  }

  Future<String> fetchyearFact(String number) async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    final response =
        await http.get(Uri.parse('http://numbersapi.com/$number/year'));
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => focusNode.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Year fact'),
        ),
        body: GestureDetector(
          onTap: () {
            focusNode.unfocus();
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  child: TextField(
                    decoration: const InputDecoration(hintText: ''),
                    keyboardType: TextInputType.number,
                    controller: yearTextController,
                    focusNode: focusNode,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () async {
                    if (yearTextController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Center(
                            child: Text('Enter any year'),
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      setState(() {
                        yearFact = '';
                      });
                    } else {
                      String fact =
                          await fetchyearFact(yearTextController.text);
                      setState(
                        () {
                          yearFact = fact;
                        },
                      );
                    }
                  },
                  child: const Text('Get fact about year'),
                ),
                const SizedBox(
                  height: 30,
                ),
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
        ),
      ),
    );
  }
}
