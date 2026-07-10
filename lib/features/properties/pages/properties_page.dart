import 'package:flutter/material.dart';
import 'package:logeria/core/domain/properties_provider.dart';
import 'package:logeria/core/domain/property.dart';
import 'package:provider/provider.dart'; // Добавили импорт провайдера
import 'package:go_router/go_router.dart'; // Добавили импорт GoRouter
import 'package:logeria/core/theme/app_colors.dart';
import 'package:logeria/core/theme/app_text_styles.dart';

class PropertiesPage extends StatelessWidget {
  const PropertiesPage({super.key});

  Future<void> _openEditor(
    BuildContext context, {
    Property? property,
  }) async {
    final provider = context.read<PropertiesProvider>();

    final Property? result = await context.push<Property>('/editor');

    if (result == null) return;

    if (property == null) {
      provider.addProperty(result);
    } else {
      provider.updateProperty(property.id, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final properties = context.watch<PropertiesProvider>().properties;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Have a good day!', 
              style: AppTextStyles.subtitle.copyWith(
                fontSize: 16.5,

              )),
            Text(
              'My properties', 
              style: AppTextStyles.title.copyWith(
                fontSize: 16.5,

              )),
          ],
        ),
        backgroundColor: AppColors.background,
        shape: Border(
          bottom: BorderSide(
            color: AppColors.surface,
          ),
        ),
      ),
      body: properties.isEmpty
          ? _buildEmptyState(context)
          : _buildPropertiesList(context, properties),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add property'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.05),
                ),
                child: const Icon(
                  Icons.apartment,
                  color: AppColors.primary,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'No properties yet',
                    style: AppTextStyles.body1.copyWith(fontSize: 18),
                  ),
                  Text(
                    'Tap the + button to add your first rental property.',
                    style: AppTextStyles.body2.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

Widget _buildPropertiesList(BuildContext context, List<Property> items) {
  return GridView.builder(
    padding: const EdgeInsets.all(16),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.0,
    ),
    itemCount: items.length,
    itemBuilder: (context, index) {
      final property = items[index];
      
      return Card(
        color: Colors.grey[900],
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _openEditor(context, property: property),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Stack( 
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.home_work, color: AppColors.primary, size: 40),
                      const SizedBox(height: 12),
                      Text(
                        property.name,
                        style: AppTextStyles.body.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        property.address,
                        style: AppTextStyles.body.copyWith(color: Colors.white, fontSize: 10),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -10,
                  right: -8,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.close, color: Colors.white, size: 40),
                    onPressed: () {
                      context.read<PropertiesProvider>().deleteProperty(property.id);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
}
