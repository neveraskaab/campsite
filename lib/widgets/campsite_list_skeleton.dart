import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CampsiteListSkeleton extends StatelessWidget {
  final int itemCount;
  const CampsiteListSkeleton({this.itemCount = 5, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey.shade300;
    final highlightColor = Colors.grey.shade100;

    Widget shimmerBox({required double width, required double height, BorderRadius? borderRadius}) {
      return Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: borderRadius ?? BorderRadius.circular(4),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: itemCount,
      itemBuilder: (_, __) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: shimmerBox(
                  width: double.infinity,
                  height: 150,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmerBox(width: 150, height: 20),
                        const SizedBox(height: 8),
                        shimmerBox(width: 100, height: 16),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  shimmerBox(width: 50, height: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
