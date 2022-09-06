class CommentModel{
  String? name;
  String? image;
  String? dateTime;
  String? comment;


  CommentModel
  ({
    this.image,
    this.name,
    this.dateTime,
    this.comment,
});

  CommentModel.fromJson(Map<String, dynamic> json){
    name = json['name'];
    image = json['image'];
    dateTime = json['dateTime'];
    comment = json['comment'];
  }

  Map<String, dynamic> toMap(){
    return {
      'name' : name,
      'image' : image,
       'dateTime' : dateTime,
       'comment' : comment,
    };
  }
}