// To parse this JSON data, do
//
//     final medicneNameModel = medicneNameModelFromJson(jsonString);

import 'dart:convert';

MedicneNameModel medicneNameModelFromJson(String str) => MedicneNameModel.fromJson(json.decode(str));

String medicneNameModelToJson(MedicneNameModel data) => json.encode(data.toJson());

class MedicneNameModel {
    bool success;
    int count;
    Pagination pagination;
    List<Datum> data;

    MedicneNameModel({
        required this.success,
        required this.count,
        required this.pagination,
        required this.data,
    });

    factory MedicneNameModel.fromJson(Map<String, dynamic> json) => MedicneNameModel(
        success: json["success"],
        count: json["count"],
        pagination: Pagination.fromJson(json["pagination"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "count": count,
        "pagination": pagination.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String id;
    String name;
    String description;
    String category;
    String createdBy;
    int usage;
    String createdAt;
    int v;
    String datumId;

    Datum({
        required this.id,
        required this.name,
        required this.description,
        required this.category,
        required this.createdBy,
        required this.usage,
        required this.createdAt,
        required this.v,
        required this.datumId,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        category: json["category"],
        createdBy: json["createdBy"],
        usage: json["usage"],
        createdAt: json["createdAt"],
        v: json["__v"],
        datumId: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "category": category,
        "createdBy": createdBy,
        "usage": usage,
        "createdAt": createdAt,
        "__v": v,
        "id": datumId,
    };
}

class Pagination {
    int total;
    int page;
    int pages;

    Pagination({
        required this.total,
        required this.page,
        required this.pages,
    });

    factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"],
        page: json["page"],
        pages: json["pages"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "page": page,
        "pages": pages,
    };
}
