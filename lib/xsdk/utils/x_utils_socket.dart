import 'dart:io';


/*


HTTP server

void main() async {
  final requests = await HttpServer.bind('localhost', 8888);
  await for (final request in requests) {
    processRequest(request);
  }
}

void processRequest(HttpRequest request) {
  print('Got request for ${request.uri.path}');
  final response = request.response;
  if (request.uri.path == '/dart') {
    response
      ..headers.contentType = ContentType(
        'text',
        'plain',
      )
      ..write('Hello from the server');
  } else {
    response.statusCode = HttpStatus.notFound;
  }
  response.close();
}


void main() async {
  final server = await HttpServer.bind('127.0.0.1', 8082);
  await for (final request in server) {
    request.response.write('Hello, world');
    await request.response.close();
  }
}

Future<void> runServer(String basePath) async {
  final server = await HttpServer.bind('127.0.0.1', 8082);
  await for (final request in server) {
    await handleRequest(basePath, request);
  }
}

Future<void> handleRequest(String basePath, HttpRequest request) async {
  final String path = request.uri.toFilePath();
  // PENDING: Do more security checks here.
  final String resultPath = path == '/' ? '/index.html' : path;
  final File file = File('$basePath$resultPath');
  if (await file.exists()) {
    try {
      await request.response.addStream(file.openRead());
    } catch (exception) {
      print('Error happened: $exception');
      await sendInternalError(request.response);
    }
  } else {
    await sendNotFound(request.response);
  }
}

Future<void> sendInternalError(HttpResponse response) async {
  response.statusCode = HttpStatus.internalServerError;
  await response.close();
}

Future<void> sendNotFound(HttpResponse response) async {
  response.statusCode = HttpStatus.notFound;
  await response.close();
}

void main() async {
  // Compute base path for the request based on the location of the
  // script, and then start the server.
  final script = File(Platform.script.toFilePath());
  await runServer(script.parent.path);
}



HTTP client:
void main() async {
  var url = Uri.parse('http://localhost:8888/dart');
  var httpClient = HttpClient();
  var request = await httpClient.getUrl(url);
  var response = await request.close();
  var data = await utf8.decoder.bind(response).toList();
  print('Response ${response.statusCode}: $data');
  httpClient.close();
}


 */

