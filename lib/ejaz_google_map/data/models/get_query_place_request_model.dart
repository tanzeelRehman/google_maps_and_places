class GetQueryPlaceRequestModel {
  GetQueryPlaceRequestModel({
    required this.query,
  });
  late final String query;

  GetQueryPlaceRequestModel.fromJson(Map<String, dynamic> json) {
    query = json['query'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['query'] = query;
    return _data;
  }
}
