import 'package:flutter/material.dart';

import '../models/gem.dart';
import '../models/user_service.dart';
import 'gem_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final List<Gem> _gems = [
    const Gem(
      name: 'Diamond - Yellow',
      price: 500,
      imagePath: 'assets/images/diamond_yellow.png',
      description: 'Yellow diamonds are known for their warm, radiant golden tones. Their color is caused by the presence of nitrogen during formation. They represent joy, optimism, and prosperity.',
    ),
    const Gem(
      name: 'Diamond - Blue',
      price: 700,
      imagePath: 'assets/images/diamond_blue.png',
      description: 'A blue diamond is one of the rarest and most valuable colored diamonds in the world. Its stunning blue color comes from trace amounts of boron within the crystal structure. Blue diamonds symbolize strength, royalty, and mystery.',
    ),
    const Gem(
      name: 'Diamond - Pink',
      price: 1000,
      imagePath: 'assets/images/diamond_pink.png',
      description: 'Pink diamonds are extremely rare and highly prized for their delicate to vivid pink hues. Unlike other colored diamonds, their color is believed to result from intense pressure during formation. They symbolize romance, elegance, and uniqueness.',
    ),
    const Gem(
      name: 'Ruby',
      price: 750,
      imagePath: 'assets/images/ruby.png',
      description: 'Ruby is a brilliant red gemstone known for its intense color and durability. Its red hue comes from the presence of chromium. Rubies represent passion, courage, and love.',
    ),
    const Gem(
      name: 'Sapphire',
      price: 400,
      imagePath: 'assets/images/sapphire.png',
      description: 'Sapphire is best known for its rich blue color, though it can appear in other shades as well. It is a durable gemstone often linked with wisdom and loyalty. Sapphires have been treasured by royalty for centuries.',
    ),
    const Gem(
      name: 'Emerald',
      price: 350,
      imagePath: 'assets/images/emerald.png',
      description: 'Emerald is a vibrant green gemstone belonging to the beryl family. Its lush color comes from trace amounts of chromium and vanadium. It symbolizes growth, renewal, and prosperity.',
    ),
    const Gem(
      name: 'Amethyst',
      price: 200,
      imagePath: 'assets/images/amethyst.png',
      description: 'Amethyst is a purple variety of quartz admired for its calming beauty. Its color ranges from soft lavender to deep violet. It is often associated with peace, clarity, and spiritual protection.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final userService = UserService();
    return ListenableBuilder(
      listenable: userService,
      builder: (context, _) {
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _gems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final gem = _gems[index];
            final isLiked = userService.isGemLiked(gem.name);
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => GemDetailScreen(gem: gem),
                ));
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.orange, width: 2),
                ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: gem.imagePath.isNotEmpty
                              ? Image.asset(
                                  gem.imagePath,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )
                              : const SizedBox.shrink(),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              gem.name,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => userService.toggleLikeGem(gem.name),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
