import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:net_app/core/theme/app_theme.dart';

class AdSliderWidget extends StatefulWidget {
  final List<String> adImagePaths;

  const AdSliderWidget({super.key, required this.adImagePaths});

  @override
  State<AdSliderWidget> createState() => _AdSliderWidgetState();
}

class _AdSliderWidgetState extends State<AdSliderWidget> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    if (widget.adImagePaths.isEmpty) {
      return const SizedBox.shrink(); // Don't show if no ads
    }
    final theme = Theme.of(context); // Get theme for potential background

    return Column(
      children: [
        CarouselSlider(
          items:
              widget.adImagePaths.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.cardRadius,
                        ),
                        // Optional: Add a background color if images with transparency
                        // and BoxFit.contain look odd, or to fill letterbox areas.
                        // color: theme.cardColor.withOpacity(0.5), // Example
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.cardRadius,
                        ),
                        child: Image.asset(
                          item,
                          fit: BoxFit.contain, // Changed from BoxFit.cover
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
          carouselController: _controller,
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9, // Changed from 2.0 to a standard 16:9
            viewportFraction: 0.9,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              widget.adImagePaths.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Theme.of(context).primaryColor)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
