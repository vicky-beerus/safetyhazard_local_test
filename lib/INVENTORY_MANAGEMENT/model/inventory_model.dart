class InventoryModel {
  String? id;
  String? name;
  String? image;
  String? date;
  String? quantity;
  String? admin;
  String? status;
  String? unit;

  InventoryModel(
      {this.id,
        this.name,
        this.image,
        this.date,
        this.quantity,
        this.admin,
        this.unit,
        this.status});

  InventoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    image = json['image'].toString();
    date = json['date'].toString();
    quantity = json['quantity'].toString();
    admin = json['admin'].toString();
    status = json['status'].toString();
    unit = json["unit"].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['date'] = this.date;
    data['quantity'] = this.quantity;
    data['admin'] = this.admin;
    data['status'] = this.status;
    data["unit"] = this.unit;
    return data;
  }
}
