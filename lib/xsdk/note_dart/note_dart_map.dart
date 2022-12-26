

/*
字典:
var maps={
  'one': 1,
  'two': 2,
  'three': 3,
};

规定item同一类型:
var aMap = <String, double>{};
var aMap = <int, double>{};

final gifts = {
 'first': 'partridge',
 'second': 'turtle doves',
 'fifth': 'golden rings'
};

final nobleGases = {
 2: 'helium',
 10: 'neon',
 18: 'argon',
};

final gift = gifts['first'];
final helium = nobleGases[2];


是否存在key:  gifts.containsKey('fifth')

添加/更改:  gifts['abc'] = 'hello';
gifts.addAll({
 'second': 'turtle doves',
 'fifth': 'golden rings',
});
gifts.addEntries([
 MapEntry('second', 'turtle doves'),
 MapEntry('fifth', 'golden rings'),
]);

删除:
gifts.remove('first');
gifts.removeWhere((key, value) => value == 'partridge');

判空:  gifts.isEmpty


使用...:
var list1 = [1, 2, 3];
var list2 = [0, ...list1];　// [0, 1, 2, 3]
// When the list being inserted could be null:
list1 = null;
var list2 = [0, ...?list1]; // [0]

// Spread operator with maps
var map1 = {'foo': 'bar', 'key': 'value'};
var map2 = {'foo': 'baz', ...map1}; // {foo: bar, key: value}
// Spread operator with sets
var set1 = {'foo', 'bar'};
var set2 = {'foo', 'baz', ...set1}; // {foo, baz, bar}

 */

void main(){

  final nobleGases = {
    2: 'helium',
    10: 'neon',
    18: 'argon',
  };

  print(nobleGases[2]);


}