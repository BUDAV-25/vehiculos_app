import 'forum_topic_model.dart';

class ForumListResponse {
  final List<ForumTopicModel> items;
  final int page;
  final int limit;
  final int total;

  ForumListResponse({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  factory ForumListResponse.fromJson(Map<String, dynamic> json) {
    return ForumListResponse(
      items: (json['data'] as List)
          .map((e) => ForumTopicModel.fromJson(e))
          .toList(),
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
    );
  }
}