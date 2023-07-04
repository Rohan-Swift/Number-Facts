import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:numberfacts/date.dart';
import 'package:numberfacts/math.dart';
import 'package:numberfacts/year.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController randomTextController = TextEditingController();
  TextEditingController displayTextController = TextEditingController();
  FocusNode focusNode = FocusNode();
  String randomFact = '';
  bool isLoading = false;

  void sendParam() {
    final number = randomTextController.text;
    if (number.isNotEmpty) {
      fetchRandomFact(number);
    }
  }

  Future<String> fetchRandomFact(String number) async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    final response = await http.get(Uri.parse('http://numbersapi.com/$number'));
    if (response.statusCode == 200) {
      setState(() {
        randomFact = response.body;
        isLoading = false;
      });
      return response.body;
    } else {
      setState(() {
        randomFact = 'Error: Unable to fetch the fact.';
        isLoading = false;
      });
      return 'Error: Unable to fetch the fact.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Number Facts'),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 150,
              ),
              const SizedBox(
                width: 350,
                child: Text(
                  'Welcome, please choose from the options below and bring meaning to your metrics and stories to your dates !! ',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const MathScreen(),
                        ),
                      );
                    },
                    child: const Text('Math'),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const YearScreen(),
                        ),
                      );
                    },
                    child: const Text('Year'),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const DateScreen(),
                        ),
                      );
                    },
                    child: const Text('Date'),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
              const SizedBox(
                height: 150,
              ),
              SizedBox(
                width: 50,
                child: TextField(
                  decoration: const InputDecoration(hintText: '42'),
                  keyboardType: TextInputType.number,
                  controller: randomTextController,
                  focusNode: focusNode,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () async {
                  if (randomTextController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Center(
                          child: Text('Enter a number'),
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    setState(() {
                      randomFact = '';
                    });
                  } else {
                    String fact =
                        await fetchRandomFact(randomTextController.text);
                    setState(
                      () {
                        randomFact = fact;
                      },
                    );
                  }
                },
                child: const Text('Get random fact!'),
              ),
              const SizedBox(
                height: 30,
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: 300,
                      child: Text(
                        randomFact,
                        textAlign: TextAlign.center,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
