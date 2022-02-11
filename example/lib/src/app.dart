import 'package:cloudflare_example/src/page/image_api_sample_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  static const pages = [
    {'title': 'Image API Demo', 'page': ImageAPIDemoPage()},
  ];

  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloudflare API Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xfff58222),
          secondary: Color(0xfffcad41),
        )
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cloudflare API Demo'),
        ),
        body: ListView.builder(
          itemCount: pages.length,
          itemBuilder: (context, index) {
            final title = pages[0]['title'].toString();
            final page = pages[0]['page'] as Widget;
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
