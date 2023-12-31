import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MathScreen extends StatefulWidget {
  const MathScreen({super.key});

  @override
  State<MathScreen> createState() => _MathScreenState();
}

class _MathScreenState extends State<MathScreen> {
  TextEditingController mathTextController = TextEditingController();
  TextEditingController displayTextController = TextEditingController();
  FocusNode focusNode = FocusNode();
  String mathFact = '';
  bool isLoading = false;

  void sendParam() {
    final number = mathTextController.text;
    if (number.isNotEmpty) {
      fetchMathFact(number);
    }
  }

  Future<String> fetchMathFact(String number) async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    final response =
        await http.get(Uri.parse('http://numbersapi.com/$number/math'));
    if (response.statusCode == 200) {
      setState(() {
        mathFact = response.body;
        isLoading = false;
      });
      return response.body;
    } else {
      setState(() {
        mathFact = 'Error: Unable to fetch the fact.';
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
          title: const Text('Math facts'),
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
                    decoration: const InputDecoration(hintText: '37'),
                    keyboardType: TextInputType.number,
                    controller: mathTextController,
                    focusNode: focusNode,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: () async {
                    if (mathTextController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Center(
                            child: Text('Enter a number'),
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      setState(() {
                        mathFact = '';
                      });
                    } else {
                      String fact =
                          await fetchMathFact(mathTextController.text);
                      setState(
                        () {
                          mathFact = fact;
                        },
                      );
                    }
                  },
                  child: const Text('Get math fact!'),
                ),
                const SizedBox(
                  height: 30,
                ),
                isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: 300,
                        child: Text(
                          mathFact,
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
