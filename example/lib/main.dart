import 'dart:io';

import 'package:cache_string/cache_string.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 100.0,
              height: 100.0,
              child: FutureBuilder(
                future: CacheString.getCache(
                    'https://i1.hdslb.com/bfs/archive/51a9ab4bffae89d9bcb0339a3db371cfedf3c047.jpg'),
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.done
                        ? snapshot.hasError || snapshot.data == null
                            ? const Icon(Icons.error)
                            : snapshot.data!.toLowerCase().startsWith('http')
                                ? Image.network(
                                    snapshot.data!,
                                  )
                                : Image.file(
                                    File(snapshot.data!),
                                  )
                        : const CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
