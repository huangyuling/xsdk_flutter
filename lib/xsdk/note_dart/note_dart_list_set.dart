

/*
列表(item的类型可以混合):
var list = ['one', 'two', 1,2,3];
规定item同一类型:
var aListOfInts = <int>[];
final List<String> list1 = <String>['one', 'two', 'three'];

使用any()遍历list判断item是否存在空:
bool hasEmpty = aListOfStrings.any((s) {
  return s.isEmpty;
});
等同于:
bool hasEmpty = aListOfStrings.any((s) => s.isEmpty);


集合(item的类型可以混合):
var aSets = {'one', 'two', 1,2,3};

规定item同一类型:  var aSetOfInts = <int>{};



list和set都属于Iterable
Iterable<int> iterable = [1, 2, 3];
错误取值: int value = iterable[1];
正确取值:int value = iterable.elementAt(1);
print(value);
print('The first element is ${iterable.first}');
print('The last element is ${iterable.last}');

int value1 = iterable.firstWhere((e)=>e>1);
print(value1); // 2


添加item:
final fruits = <String>['apple', 'orange', 'pear'];
fruits.add('peach');
fruits.addAll(['kiwi', 'mango']);
fruits.insert(0, 'peach');
fruits.insertAll(0, ['kiwi', 'mango']);
修改item:
fruits[2] = 'peach';
删除:
fruits.remove('pear');
// Removes the last element from the list.
fruits.removeLast();
// Removes the element at position 1 from the list.
fruits.removeAt(1);
// Removes the elements with positions greater than
// or equal to start (1) and less than end (3) from the list.
fruits.removeRange(1, 3);
// Removes all elements from the list that match the given predicate.
fruits.removeWhere((fruit) => fruit.contains('p'));

判空: fruits.isEmpty

填充: final list1 = List.filled(3, 'a');  // Creates: [ 'a', 'a', 'a' ]
生成: final list1 = List.generate(3, (index) => 'a$index');  // Creates: [ 'a0', 'a1', 'a2' ]




其他:
void main() {
  // 常用属性和方法

  List lists = ["语文", "英语", "数学"];
  print(lists[1]);

  //var list = List(); //List()过期不能使用
  List list = [];
  list.add("语文");
  list.add("英语");
  list.add("数学");
  print(list[0]);

  //List里面的属性

  print(list.length);
  print(list.isEmpty);
  print(list.isNotEmpty);
  print(list.reversed.toList());

  //List里面的方法
  list.add("物理");
  print(list);
  list.addAll(["化学", "地理"]);
  print(list);
  print("----------0");
  //查找不到返回-1，否则返回索引
  print(list.indexOf("化学"));
  print("----------1");
  //删除元素
  list.remove("地理");
  print(list);

  //把英语修改为English
  list.fillRange(1, 2, "English");
  print("----------2");
  print(list);
  print("----------3");
  //插入数据
  list.insert(2, "生物");
  print(list);
  print("----------4");
  //list 转换为字符串
  var str = list.join(",");
  print(str);
  print("----------5");

  //字符串转换为List
  var myList = str.split(",");
  print(myList);
  print("----------6");

  //Set集合：没有顺序且不能重复的集合
  var set = new Set();
  set.add("苹果");
  set.add("橘子");
  set.add("橙子");
  print(set);
  print("----------7");
  print(set.toList());

  print("----------8");

  //利用set去除重复数据
  List list1 = ["苹果", "香蕉", "苹果", "香蕉", "苹果"];
  print(list1);
  var s = new Set();
  s.addAll(list1);
  print(s.toList());
  print("----------9");

  //Map

  var person = {"name": "王五", "age": 30};
  print(person);
  print("----------10");
  var map = new Map();
  map["name"] = "张三";
  map["age"] = 28;
  print(map);

  print("----------11");
  //常用属性
  //获取所有的key
  print(person.keys.toList());
  print("----------12");
  //获取所有的valus
  print(person.values.toList());

  print("----------13");
  print(person.isEmpty);
  print(person.isNotEmpty);
  print("----------14");
  //常用方法
  person.addAll({"sex": "男"});
  print(person);

  print("----------14");
  person.remove("name");
  print(person);
  print("----------15");
  print(person.containsKey("age"));
  print(person.containsValue(30));

  print("----------16");

  // forEach、map、where、any、every  可用于List Map、Set
  List l = ["南京", "北京", "蚌埠", "合肥"];
  //for循环
  for (var i = 0; i < l.length; i++) {
    print(l[i]);
  }

  print("----------17");

  //for in
  for (var item in l) {
    print(item);
  }
  print("----------18");
  //forEach
  l.forEach((item) {
    print(item);
  });

  print("----------19");
  //map
  var list2 = l.map((value) {
    return value + "1";
  });
  print(list2.toList());
  print("----------20");
  //where
  List list3 = [1, 3, 5, 7, 9, 10];
  var list4 = list3.where((value) {
    return value > 5;
  });
  print(list4.toList());

  print("----------21");

  //any 只要集合中有满足条件的返回true
  List list5 = [1, 3, 5, 7, 9, 10];
  var b = list5.any((value) {
    return value > 5; //只要集合中有满足条件的返回true
  });
  print(b);

  print("----------22");
  //every 只要集合中每一个都满足条件的返回true
  List list6 = [1, 3, 5, 7, 9, 10];
  var b1 = list6.every((value) {
    return value > 5; //只要集合中每一个都满足条件的返回true
  });
  print(b1);

  print("----------23");
  //Set
  var sets = new Set();
  sets.addAll(["11", "22", "33"]);
  sets.forEach((value) => print(value));

  print("----------24");
  //Map
  var persons = {"name": "王五", "age": 30};
  persons.forEach((key, value) {
    print("$key:$value");
  });




  const用来修饰常量,不能改变其引用,不能改变其值(不能添加或删除list中的item)
  final用来修饰变量,不能改变其引用,能改变其值(能添加或删除list中的item)

  //不允许,报错
  var list=const [1,2,3];
  list.add(5);
  print(list);
  //不允许,报错
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


}


 */
void main(){

  List<String> ll=[];
  ll.add('value');
  print(ll);

}