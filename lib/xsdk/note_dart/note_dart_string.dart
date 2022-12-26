
/*
字符串:${表达式}:
String	 	                  Result
'${3 + 2}'	 	               '5'
'${"word".toUpperCase()}'	 	'WORD'
'$myObject'	                	The value of myObject.toString()


在''内部使用$对变量的引用
var food = 'bread';
var str = 'I eat $food'; // I eat bread
var str = 'I eat ${food}'; // I eat bread


多行字符串:  '''多行''' 或 """多行"""

拼接字符串:
var order = fetchUserOrder();
var str= 'Your order is: $order';


比较字符串(区分大小写) : ==

 */

void main(){

  String a='${1}';
  print(a);


}