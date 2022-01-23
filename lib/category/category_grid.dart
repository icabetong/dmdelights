import 'package:dm_delights/category/category.dart';
import 'package:dm_delights/category/category_page.dart';
import 'package:dm_delights/shared/theme.dart';
import 'package:flutter/material.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({Key? key, required this.categories}) : super(key: key);

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ThemeComponents.defaultPadding,
      child: GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          final category = categories[index];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoryPage(category: category),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                //set border radius more than 50% of height and width to make circle
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Container(
                    decoration: category.imageUrl != null
                        ? BoxDecoration(
                            color: Colors.transparent,
                            image: DecorationImage(
                              image: NetworkImage(category.imageUrl!),
                              fit: BoxFit.cover,
                            ),
                          )
                        : null,
                  ),
                  Container(
                    child: Center(
                      child: Text(
                        category.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          shadows: [
                            Shadow(
                              blurRadius: 8.0,
                              color: Colors.black54,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: const Alignment(1.0, -1),
                        end: const Alignment(-1.0, 1),
                        colors: [
                          Colors.pink.shade400.withOpacity(0.4),
                          Colors.pink.shade600.withOpacity(0.2)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
