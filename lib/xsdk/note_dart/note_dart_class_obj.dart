

/*
强转as:
Car item= listData[index] as Car;




类:
class Spacecraft {
  String name;
  DateTime? launchDate;

  // Read-only non-final property
  int? get launchYear => launchDate?.year;

  //构造函数
  Spacecraft(this.name, this.launchDate)
  Spacecraft({required this.name, required this.launchDate});
  Spacecraft([this.name = '0', this.launchDate = DateTime(1977, 9, 5)]);
  Spacecraft({this.name = '0', this.launchDate = DateTime(1977, 9, 5)});
  Spacecraft(String name, DateTime launchDate) {
  this.name = name;
  this.launchDate = launchDate;
}


  // Named constructor that forwards to the default one.
  Spacecraft.unlaunched(String name) : this(name, null);

  // Method.
  void describe() {
    print('Spacecraft: $name');
    // Type promotion doesn't work on getters.
    var launchDate = this.launchDate;
    if (launchDate != null) {
      int years = DateTime.now().difference(launchDate).inDays ~/ 365;
      print('Launched: $launchYear ($years years ago)');
    } else {
      print('Unlaunched');
    }
  }
}


使用:
var voyager = Spacecraft('Voyager I', DateTime(1977, 9, 5));
var voyager = Spacecraft(name:'Voyager I', launchDate:DateTime(1977, 9, 5));
voyager.describe();

var voyager3 = Spacecraft.unlaunched('Voyager III');
voyager3.describe();

////////////////////////////////////////////////

继承extends:
class Orbiter extends Spacecraft {
  double altitude;
  Orbiter(super.name, DateTime super.launchDate, this.altitude);
}
由于Dart 没有interface关键字。所有类都隐式定义了一个接口。因此可以实现任何类,
但是使用implements会实现很多其他隐藏的接口方法,不建议使用implements
class MockSpaceship implements Spacecraft {
  // ···
}

抽象abstract:
一个抽象类以由具体类扩展（或实现）。抽象类可以包含抽象方法（带有空主体）。
abstract class Describable {
  void describe();
  void describeWithEmphasis() {
    print('=========');
    describe();
    print('=========');
  }
}


混合mixin:(使用里面的方法,类似接口)
mixin Piloted {
  int astronauts = 1;

  void describeCrew() {
    print('Number of astronauts: $astronauts');
  }
}
混合的使用with:
class PilotedCraft extends Spacecraft with Piloted {
  // ···
}


属性的get,set
class MyClass {
  int _aProperty = 0;
  int get aProperty => _aProperty;
  set aProperty(int value) {
    if (value >= 0) {
      _aProperty = value;
    }
  }
}

只使用get定义隐性变量,使用 var item=MyClass();  print(item.count);
class MyClass {
  final List<int> _values = [];

  void addValue(int value) {
    _values.add(value);
  }

  // A computed property.
  int get count {
    return _values.length;
  }
}




工厂构造方法:
class Square extends Shape {}
class Circle extends Shape {}
class Shape {
  Shape();
  factory Shape.fromTypeName(String typeName) {
    if (typeName == 'square') return Square();
    if (typeName == 'circle') return Circle();
    throw ArgumentError('Unrecognized $typeName');
  }
}


单例:
class ImmutablePoint {
  static const ImmutablePoint origin = ImmutablePoint(0, 0);
  final int x;
  final int y;
  const ImmutablePoint(this.x, this.y);
}




创建实例时,new可省略
var bike = Bicycle(2, 0, 1);




 */



void main(){



}