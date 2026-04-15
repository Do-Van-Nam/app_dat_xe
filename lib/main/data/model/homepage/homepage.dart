class HomePageModel {
  final Header? header;
  final String? searchPlaceholder;
  final List<ServiceItem>? services;
  final List<dynamic>? savedAddresses; // TODO: type if needed
  final List<BannerItem>? banners;
  final List<NewsPromotion>? newsPromotions;
  final RestaurantSuggestions? restaurantSuggestions;

  HomePageModel({
    this.header,
    this.searchPlaceholder,
    this.services,
    this.savedAddresses,
    this.banners,
    this.newsPromotions,
    this.restaurantSuggestions,
  });

  factory HomePageModel.fromJson(Map<String, dynamic> json) {
    return HomePageModel(
      header: json['header'] != null ? Header.fromJson(json['header']) : null,
      searchPlaceholder: json['search_placeholder'],
      services: json['services'] != null
          ? (json['services'] as List).map((i) => ServiceItem.fromJson(i)).toList()
          : null,
      savedAddresses: json['saved_addresses'],
      banners: json['banners'] != null
          ? (json['banners'] as List).map((i) => BannerItem.fromJson(i)).toList()
          : null,
      newsPromotions: json['news_promotions'] != null
          ? (json['news_promotions'] as List).map((i) => NewsPromotion.fromJson(i)).toList()
          : null,
      restaurantSuggestions: json['restaurant_suggestions'] != null
          ? RestaurantSuggestions.fromJson(json['restaurant_suggestions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'header': header?.toJson(),
      'search_placeholder': searchPlaceholder,
      'services': services?.map((e) => e.toJson()).toList(),
      'saved_addresses': savedAddresses,
      'banners': banners?.map((e) => e.toJson()).toList(),
      'news_promotions': newsPromotions?.map((e) => e.toJson()).toList(),
      'restaurant_suggestions': restaurantSuggestions?.toJson(),
    };
  }
}

class Header {
  final String? greeting;
  final String? avatar;
  final bool? hasNotification;

  Header({this.greeting, this.avatar, this.hasNotification});

  factory Header.fromJson(Map<String, dynamic> json) {
    return Header(
      greeting: json['greeting'],
      avatar: json['avatar'],
      hasNotification: json['has_notification'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'greeting': greeting,
      'avatar': avatar,
      'has_notification': hasNotification,
    };
  }
}

class ServiceItem {
  final String? id;
  final String? name;
  final String? icon;
  final String? type;

  ServiceItem({this.id, this.name, this.icon, this.type});

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: json['id']?.toString(),
      name: json['name'],
      icon: json['icon'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'type': type,
    };
  }
}

class BannerItem {
  final int? id;
  final String? image;
  final String? actionUrl;

  BannerItem({this.id, this.image, this.actionUrl});

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      id: json['id'],
      image: json['image'],
      actionUrl: json['action_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'action_url': actionUrl,
    };
  }
}

class NewsPromotion {
  final int? id;
  final String? title;
  final String? description;
  final String? image;
  final String? tag;

  NewsPromotion({this.id, this.title, this.description, this.image, this.tag});

  factory NewsPromotion.fromJson(Map<String, dynamic> json) {
    return NewsPromotion(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      tag: json['tag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'tag': tag,
    };
  }
}

class RestaurantSuggestions {
  final String? status;
  final String? message;
  final List<dynamic>? items; // TODO: type if needed

  RestaurantSuggestions({this.status, this.message, this.items});

  factory RestaurantSuggestions.fromJson(Map<String, dynamic> json) {
    return RestaurantSuggestions(
      status: json['status'],
      message: json['message'],
      items: json['items'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'items': items,
    };
  }
}
