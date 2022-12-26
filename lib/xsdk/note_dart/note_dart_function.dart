


/*


注意: Dart没有可变入参, 可使用list替代:
void do(String a, list b){}


方法:
int fibonacci(int n) {
  if (n == 0 || n == 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

var result = fibonacci(20);


int sumUp(int a, int b, int c) {
  return a + b + c;
}
int total = sumUp(1, 2, 3);

可变长度方法:
int sumUpToFive(int a, [int? b, int? c, int? d, int? e]) {
  int sum = a;
  if (b != null) sum += b;
  if (c != null) sum += c;
  if (d != null) sum += d;
  if (e != null) sum += e;
  return sum;
}
// ···
int total = sumUpToFive(1, 2);
int otherTotal = sumUpToFive(1, 2, 3, 4, 5);

可变长度(有默认值)
int sumUpToFive(int a, [int b = 2, int c = 3, int d = 4, int e = 5]) {
}
// ···
int newTotal = sumUpToFive(1);
print(newTotal); // <-- prints 15



void printName(String firstName, String lastName, {String? middleName}) {
  print('$firstName ${middleName ?? ''} $lastName');
}
// ···
printName('Dash', 'Dartisan');
printName('John', 'Smith', middleName: 'Who');
// 填写带参数名称的值则可以在任意位置传参
printName('John', middleName: 'Who', 'Smith');


void printName(String firstName, String lastName, {String middleName = ''}) {
  print('$firstName $middleName $lastName');
}

 */