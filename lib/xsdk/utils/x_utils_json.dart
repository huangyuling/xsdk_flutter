import 'dart:convert';

abstract class XJsonUtils{


  /*

   */








  /*
  (不推荐,不能转实体类,map的key可能输错)自带库:dart:convert json转换map/list,注意:并不能直接转为数据结构模型,还需要另外写一个实体类的fromJson()方法,如
  class User {
  final String name;
  final String email;

  User(this.name, this.email);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
      };
}

   */
  static Object json2ListOrMap(String jsonString){
    var listOrMap = jsonDecode(jsonString);
    //List<dynamic>
    // if(listOrMap is List){
    // }

    //Map<String, dynamic>
    // if(listOrMap is Map){
    // }
    return listOrMap;
  }

  //自带库:dart:convert, obj to json
  static String obj2Json(Object obj){
    var json = jsonEncode(obj);
    return json;
  }




}
