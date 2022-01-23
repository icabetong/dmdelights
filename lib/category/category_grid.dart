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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Image.network(
                      category.imageUrl ?? '',
                      height: 128,
                      fit: BoxFit.scaleDown,
                    ),
                    SizedBox(
                      height: ThemeComponents.defaultSpacing,
                    ),
                    Text(category.name)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
