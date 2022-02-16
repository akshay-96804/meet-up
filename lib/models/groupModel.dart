class GroupModel{
  final String title ; 
  final List<String> emailList ; 

  GroupModel({this.emailList,this.title});

  factory GroupModel.fromJSON(Map<String,dynamic> json){
    
    List<String> myList = [];

     var jsonList = json['emailList'] ;
     jsonList.forEach((element){
       myList.add(element);
     });

    return GroupModel(
      emailList: myList,
      title: json['title'] 
    );
  } 
}

Map<String,dynamic> toJSON(GroupModel groupModel){
  return{
    'title': groupModel.title,
    'emailList': groupModel.emailList
  };
}

