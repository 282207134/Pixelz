class Service {
  const Service(
    this.id,
    this.title,
    this.image,
    this.category, {
    this.price = 29.5,
    this.seller = 'Chelsea Cutler',
    this.description = '',
  });
  final String id, title, image, category, seller, description;
  final double price;
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'image': image,
    'category': category,
    'price': price,
    'seller': seller,
    'description': description,
  };
  factory Service.fromJson(Map<String, dynamic> j) => Service(
    j['id'],
    j['title'],
    j['image'],
    j['category'],
    price: (j['price'] as num).toDouble(),
    seller: j['seller'],
    description: j['description'] ?? '',
  );
}

class Order {
  const Order({
    required this.id,
    required this.serviceId,
    required this.total,
    required this.package,
    this.status = 'In Progress',
    this.brief = 'Design a responsive app and website for our creative studio.',
  });
  final String id, serviceId, package, status, brief;
  final double total;
  Order withStatus(String value) => Order(
    id: id,
    serviceId: serviceId,
    total: total,
    package: package,
    status: value,
    brief: brief,
  );
  Map<String, dynamic> toJson() => {
    'id': id,
    'serviceId': serviceId,
    'total': total,
    'package': package,
    'status': status,
    'brief': brief,
  };
  factory Order.fromJson(Map<String, dynamic> j) => Order(
    id: j['id'],
    serviceId: j['serviceId'],
    total: (j['total'] as num).toDouble(),
    package: j['package'],
    status: j['status'],
    brief: j['brief'],
  );
}

class ChatMessage {
  const ChatMessage(this.text, {this.mine = false});
  final String text;
  final bool mine;
  Map<String, dynamic> toJson() => {'text': text, 'mine': mine};
  factory ChatMessage.fromJson(Map<String, dynamic> j) =>
      ChatMessage(j['text'], mine: j['mine']);
}

class ProjectRequest {
  const ProjectRequest(this.title, this.category, this.budget, this.days);
  final String title, category;
  final double budget;
  final int days;
  Map<String, dynamic> toJson() => {
    'title': title,
    'category': category,
    'budget': budget,
    'days': days,
  };
  factory ProjectRequest.fromJson(Map<String, dynamic> j) => ProjectRequest(
    j['title'],
    j['category'],
    (j['budget'] as num).toDouble(),
    j['days'],
  );
}

String money(num value) =>
    '\$${value == value.roundToDouble() ? value.toInt() : value.toStringAsFixed(2)}';
