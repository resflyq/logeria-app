import 'package:flutter/material.dart';
import 'package:logeria/core/domain/properties_provider.dart';
import 'package:logeria/core/domain/property.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:logeria/core/theme/app_colors.dart';
import 'package:logeria/core/theme/app_text_styles.dart';

class PropertiesPage extends StatelessWidget {
  const PropertiesPage({super.key});

  Future<void> _openEditor(
      BuildContext context, {
      Property? property,
    }) async {
      final provider = context.read<PropertiesProvider>();

      final Property? result = await context.push<Property>(
        '/editor',
        extra: property,
      );

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
              style: AppTextStyles.subtitle.copyWith(fontSize: 16.5),
            ),
            Text(
              'My properties', 
              style: AppTextStyles.title.copyWith(fontSize: 16.5),
            ),
          ],
        ),
        backgroundColor: AppColors.background,
        shape: const Border(
          bottom: BorderSide(
            color: AppColors.surface,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildStatsSummary(context, properties),
          Expanded(
            child: properties.isEmpty
                ? _buildEmptyState(context)
                : _buildPropertiesList(context, properties),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add property'),
      ),
    );
  }

  Widget _buildStatsSummary(BuildContext context, List<Property> properties) {
    final double totalProfit = properties.fold(0, (sum, p) => sum + (p.profit != null ? double.parse(p.profit!) : 0));
    final int activeTenants = properties.where((p) => p.tenant.isNotEmpty).length;

    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 8.0),
      child: Row(
        children: [
          _buildStatCard(
            title: 'Profit',
            value: '\$${totalProfit.toStringAsFixed(0)}',
            color: Colors.green.withOpacity(0.1),
            textColor: Colors.green[700]!,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            title: 'Tenants',
            value: '$activeTenants',
            color: AppColors.primary.withOpacity(0.1),
            textColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required Color textColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: textColor.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.body2.copyWith(
                fontSize: 11,
                color: textColor.withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTextStyles.title.copyWith(
                fontSize: 16,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
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
Color _parsePropertyColor(String? colorStr) {
  if (colorStr == null || colorStr.isEmpty) return Colors.grey[900]!;
  try {
    String hex = colorStr.replaceAll('0x', '').replaceAll('#', '').trim();
    if (hex.length == 6) hex = 'FF' + hex;
    return Color(int.parse(hex, radix: 16));
  } catch (_) {
    return Colors.grey[900]!;
  }
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
      final cardColor = _parsePropertyColor(property.color);
      
      return Card(
        color: cardColor,
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
                      Icon(Icons.home_work, color: AppColors.background, size: 40),
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
                      const SizedBox(height: 3),
                      Text(
                        property.tenant,
                        style: AppTextStyles.body.copyWith(color: Colors.white, fontSize: 7),
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
