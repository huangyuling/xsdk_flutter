
abstract class XNumberUtils{


  //字符串转整数(默认10进制),可返回null,   var a=XNumberUtils.string2int('10',radix:8);
  static int? string2int(String num,{int? radix}){
      return int.tryParse(num,radix:radix);
  }

  /*
  字符串转小数
  var value = double.tryParse('3.14'); // 3.14
  value = double.tryParse('  3.14 \xA0'); // 3.14
  value = double.tryParse('0.'); // 0.0
  value = double.tryParse('.0'); // 0.0
  value = double.tryParse('-1.e3'); // -1000.0
  value = double.tryParse('1234E+7'); // 12340000000.0
  value = double.tryParse('+.12e-9'); // 1.2e-10
  value = double.tryParse('-NaN'); // NaN
  value = double.tryParse('0xFF'); // null
  value = double.tryParse(double.infinity.toString()); // Infinity
   */
  static double? string2double(String num){
      return double.tryParse(num);
  }

}
