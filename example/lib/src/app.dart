import 'package:cloudflare_example/main.dart';
import 'package:cloudflare_example/src/page/image_api_sample_page.dart';
import 'package:cloudflare_example/src/page/live_input_api_sample_page.dart';
import 'package:cloudflare_example/src/page/stream_api_sample_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  static const pages = [
    {'title': 'Image API Demo', 'page': ImageAPIDemoPage()},
    {'title': 'Stream API Demo', 'page': StreamAPIDemoPage()},
    {'title': 'Live Input API Demo', 'page': LiveInputAPIDemoPage()},
  ];

  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloudflare API Demo',
      theme: ThemeData(
          colorScheme: const ColorScheme.light(
        primary: Color(0xfff58222),
        secondary: Color(0xfffcad41),
      )),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cloudflare API Demo'),
        ),
        body: cloudflareInitMessage != null
            ? Center(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Text(
                      cloudflareInitMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              )
            : ListView.builder(
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  final title = pages[index]['title'].toString();
                  final page = pages[index]['page'] as Widget;
                  return ListTile(
                    onTap: () => Navigator.push(
                        context, MaterialPageRoute(builder: (context) => page)),
                    title: Text(title),
                  );
                },
              ),
      ),
    );
  }
}
