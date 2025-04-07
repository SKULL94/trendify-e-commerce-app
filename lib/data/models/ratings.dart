class Review {
  final int id;
  final int userId;
  final String userName;
  final String userImageUrl;
  final String reviewText;
  final double rating;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImageUrl,
    required this.reviewText,
    required this.rating,
  });
}

final List<Review> reviews = [
  Review(
    id: 1,
    userId: 1,
    userName: 'Emily R.',
    userImageUrl: 'https://randomuser.me/api/portraits/women/1.jpg',
    reviewText:
        'I love this product! It\'s so comfortable and the quality is amazing.',
    rating: 5,
  ),
  Review(
    id: 2,
    userId: 2,
    userName: 'David K.',
    userImageUrl: 'https://randomuser.me/api/portraits/men/2.jpg',
    reviewText:
        'This product is okay, but it\'s not the best I\'ve ever used. The material is a bit cheap.',
    rating: 2,
  ),
  Review(
    id: 3,
    userId: 3,
    userName: 'Sophia L.',
    userImageUrl: 'https://randomuser.me/api/portraits/women/3.jpg',
    reviewText:
        'I\'m so impressed with this product! The design is beautiful and it\'s really easy to use.',
    rating: 5,
  ),
  Review(
    id: 4,
    userId: 4,
    userName: 'Michael T.',
    userImageUrl: 'https://randomuser.me/api/portraits/men/4.jpg',
    reviewText:
        'I\'ve been using this product for a few weeks now and I\'m really happy with it. The quality is great and it\'s really durable.',
    rating: 4,
  ),
  Review(
    id: 5,
    userId: 5,
    userName: 'Olivia W.',
    userImageUrl: 'https://randomuser.me/api/portraits/women/5.jpg',
    reviewText:
        'I was a bit skeptical about this product at first, but it\'s really grown on me. The customer service is also really great.',
    rating: 4,
  ),
];
