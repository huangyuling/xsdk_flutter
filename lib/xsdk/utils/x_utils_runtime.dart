import 'dart:io';


/*
 * RunTime
    使得直接调用底层Linux下的可执行程序或脚本成为可能,比如Linux下写个测试工具
 *
 */
abstract class XRunTimeUtils{


  /*
  void main() async {
  final output = File('output.txt').openWrite();
  Process process = await Process.start('ls', ['-l']);

  // Wait for the process to finish; get the exit code.
  final exitCode = (await Future.wait([
    process.stdout.pipe(output), // Send stdout to file.
    process.stderr.drain(), // Discard stderr.
    process.exitCode
  ]))[2];

  print('exit code: $exitCode');
}
   */
  static Future<String> string2int(String command) async{
    //ProcessResult results = await Process.run('ls', ['-l']);
    ProcessResult results = await Process.run(command, ['-l']);
    print(results.stdout);
    return results.stdout.toString();
  }


}
