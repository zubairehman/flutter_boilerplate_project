import 'package:boilerplate/data/network/dto/post_dto.dart';
import 'package:boilerplate/domain/entity/post/post.dart';

extension PostDtoMapper on PostDto {
  Post toDomain() => Post(userId: userId, id: id, title: title, body: body);
}

extension PostDomainMapper on Post {
  PostDto toDto() => PostDto(userId: userId, id: id, title: title, body: body);
}