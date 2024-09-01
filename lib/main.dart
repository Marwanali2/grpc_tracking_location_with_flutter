import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc_with_flutter/hello_service.dart';
import 'package:grpc_with_flutter/services/proto/hello.pb.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  HelloService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ///call sayHello from helloClient service
  var hello = "default";

  Future<void> sayHello() async {
    try {
      HelloRequest helloRequest = HelloRequest();
      helloRequest.name = "Itachi";

      var helloResponse =
          await HelloService.instance.helloClient.sayHello(helloRequest);

      ///do something with your response here
      setState(() {
        hello = helloResponse.message;
      });
      log('Response: ${helloResponse.message}');
    } on GrpcError catch (e) {
      ///handle all grpc errors here
      ///errors such us UNIMPLEMENTED,UNIMPLEMENTED etc...
      log('Caught Grpc Error: $e');
    } catch (e) {
      ///handle all generic errors here
      log('Caught Generic Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              hello,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sayHello,
        tooltip: 'Said Hello',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
