
//单行注解

/*
第三方包:  https://pub.dev/   https://pub.flutter-io.cn
dart文档: https://dart.dev/

https://codelabs.flutter-io.cn/#codelabs
https://flutter.cn/docs/development/ui/widgets
https://flutter-io.cn/

命名规范:
变量名使用下横线命名方式,如: a_b_c,同python,也可同java的驼峰命名
变量名(包括常量)都是小写开头, 类名大写开头



dynamic 任何类型
泛型:T  T?等同dynamic


var变量:

1.字符串可以使用单引号或双引号
var name = 'Voyager I';
2.数字类型
var year = 1977;
var antennaDiameter = 3.7;
3.数组内的类型可以混合
var arr=[1,2,'adc']
var flybyObjects = ['Jupiter', 'Saturn', 'Uranus', 'Neptune'];
4.字典
var image = {
  'tags': ['saturn'],
  'url': '//path/to/saturn.jpg'
};

具体类型变量:
int a=0;
String b=''
double c=0.1;

注意:
1.如果定义具体变量类型,如果int String,则需要初始化变量值,否则编译错误,如: int a=0; String b='';
2.使用var变量类型,则可不初始化其值,默认为null
3.
var name;
name = 'bob';
name = 5; // 允许,因为初始化化时没有赋值,是动态类型
// 初始化赋值,确认为String类型,则不是动态了
var name = 'bob';
name = 5; // 不允许,


late 关键字修饰属性，是懒加载方式。时告诉程序该属性暂时是null，在属性使用时再实例化，请求允许编译通过。
const用来修饰常量,不能改变其引用,不能改变其值(不能添加或删除list中的item)
final用来修饰变量,不能改变其引用,能改变其值(能添加或删除list中的item)

//不允许报错
var list=const [1,2,3];
list.add(5);
print(list);
//不允许报错
const ll= [1,2,3];
ll.add(5);
print(ll);

//允许
final ll= [1,2,3];
ll.add(5);
print(ll);

//不允许
final ll= [1,2,3];
ll= [5,6];
print(ll);


可空变量(Dart 2.12 引入了可靠的 null 安全性):
错误无效: int a = null ;
可空有效: int? a = null ; 等同 int? a;

myObject?.someProperty 等同于 (myObject != null) ? myObject.someProperty : null
也支持多层?:  myObject?.someProperty?.someMethod()



枚举:   enum PlanetType { terrestrial, gas, ice }


语法:

正常:
var button = querySelector('#confirm');
button?.text = 'Confirm';
button?.classes.add('important');
button?.onClick.listen((e) => window.alert('Confirmed!'));
button?.scrollIntoView();

等同: 串联使用..指向对象:
querySelector('#confirm')
  ?..text = 'Confirm'
  ..classes.add('important')
  ..onClick.listen((e) => window.alert('Confirmed!'))
  ..scrollIntoView();


var animal = Animal()
  ..name = "Bob"
  ..age = 5
  ..feed()
  ..walk();
print(animal.name); // "Bob"
print(animal.age); // 5



三元表达式: final visibility = isPublic ? 'public' : 'private';

运算符:
判空: ??
判空赋值: ??=


语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整）;
比如i为：0, 1, 2, 3, 4, 5时，结果为0,0, 1, 1, 2, 2，


私有: 命名前添加_下横线即可

 */



void main(){

}