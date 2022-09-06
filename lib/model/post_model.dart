class PostModel {
   String? name;
   String? uId;
   String? image;
   String? dateTime;
   String? text;
   String? postImage;


  PostModel(
     this.name,
     this.uId,
     this.image,
     this.text,
     this.postImage,
      this.dateTime,
  );

  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
    text = json['text'];
    postImage = json['postImage'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'image': image,
      'text' : text,
      'postImage' : postImage,
      'dateTime' : dateTime,
    };
  }
}