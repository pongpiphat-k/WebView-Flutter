import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyWebView());
}

class MyWebView extends StatelessWidget {
  const MyWebView({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter WebView'),
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
  late WebViewController _controller1;
  late WebViewController _controller2;
  late WebViewController _controller3;

  bool _isLoading = false;

// create 3 controllers for webview
  @override
  void initState() {
    super.initState();
    

    _controller1 = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            _isLoading = true;
          });
          print("Page started loading: $url");
        },
        onPageFinished: (url) {
          setState(() {
            _isLoading = false;
          });
          print("Page finished loading: $url");
        },
        onNavigationRequest: (request) {
          if (request.url.startsWith("https://flutter.dev") || 
              request.url.startsWith("https://docs.flutter.dev")) {
            return NavigationDecision.navigate;
          }
          print("Blocking navigation to ${request.url}");
          return NavigationDecision.prevent;
        },

      ),
    )
    ..loadRequest(Uri.parse("https://flutter.dev"));

    _controller2 = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadFlutterAsset('assets/index.html');

    _controller3 = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString('''
        <html>
        <head>
          <title>HTML String</title>
        </head>
        <body>
          <h1>This is loaded from a HTML string!</h1>
          <p>Hello, WebView Kong</p>
        </body>
        </html>
      ''');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("WebView Navigation & Events"),
        actions: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            if (await _controller1.canGoBack()) {
              _controller1.goBack();
            }
          }, ),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () async {
            if (await _controller1.canGoForward()) {
              _controller1.goForward();
            }
          }, ),
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () => _controller1.reload(), ),
        ],
      ),
      body: Stack(
        children: [
            Column(
        children: [
          Expanded(
            child: WebViewWidget(controller: _controller1),
          ),
        ],
      ),
      if (_isLoading)
        const LinearProgressIndicator(),
    ],
  ),
    
  );
  }
}
