
abstract class XDartUtils{

  //当前时间(毫秒)
  static String getObjectType(dynamic obj){

    String typeName=obj.runtimeType.toString();
    if(typeName.contains('<')){
      int index=typeName.indexOf('<');
      typeName=typeName.substring(0,index);
    }
    if(typeName.toLowerCase().contains('list')){
      return 'List';
    }else if(typeName.toLowerCase().contains('map')){
      return 'Map';
    }else if(typeName.toLowerCase().contains('set')){
      return 'Set';
    }

    //String,Null,int,double
    return typeName;
  }
}
