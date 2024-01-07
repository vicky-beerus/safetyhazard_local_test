class HazardModel{
  String? title;
  String? location;
  String? img;
  String? date;

  String? id;

  HazardModel({this.title,this.id,this.location,this.img,this.date});


  factory HazardModel.fromJson(Map<String,dynamic> json){
    return HazardModel(

        title: json["title"],
        id: json["id"],
        date: json["date"],
        img: json["img"],
        location: json["location"]

    );

  }

}