import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:logeria/core/domain/property.dart';
import 'package:logeria/core/theme/app_colors.dart';
import 'package:logeria/core/theme/app_text_styles.dart';

class PropertyEditor extends StatefulWidget {
  final Property? initialProperty;

  const PropertyEditor({super.key, this.initialProperty});

  @override
  State<PropertyEditor> createState() => _PropertyEditorState();
}

class _PropertyEditorState extends State<PropertyEditor> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _tenantController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _priceController = TextEditingController();
  String? _errorMessage;

  // Палитра доступных цветов
  final List<Color> _availableColors = [
    const Color(0xFF00A5F8), // primary color
    const Color(0xFFE53935), // Red
    const Color(0xFFFFB300), // Amber
    const Color(0xFF4CAF50), // Green
    const Color(0xFF00ACC1), // Cyan
    const Color(0xFF1E88E5), // Blue
    const Color(0xFF3F51B5), // Indigo
    const Color(0xFF8E24AA), // Purple
    const Color(0xFFE91E63), // Pink
    const Color(0xFF757575),
  ];

  Color _selectedColor = const Color.fromARGB(255, 129, 129, 129); // default color

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialProperty?.name ?? '';
    _addressController.text = widget.initialProperty?.address ?? '';
    _tenantController.text = widget.initialProperty?.tenant ?? '';
    _startDateController.text = widget.initialProperty?.startDate ?? '';
    _endDateController.text = widget.initialProperty?.endDate ?? '';
    _priceController.text = widget.initialProperty?.price ?? '';

    final savedColor = _parseColor(widget.initialProperty?.color);
    if (savedColor != null) {
      _selectedColor = savedColor;
  }
  }

  // hex parser
  Color? _parseColor(String? colorStr) {
    if (colorStr == null || colorStr.isEmpty) return null;
    try {
      final value = int.parse(colorStr.replaceFirst('#', '').replaceFirst('0x', ''), radix: 16);
      return Color(value < 0xFF000000 ? value + 0xFF000000 : value);
    } catch (_) {
      return null;
    }
  }

  void _submit() {
    setState(() {
      _errorMessage = null;
    });

    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _tenantController.text.isEmpty || 
        _priceController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all required fields.';
      });
    return;
    }

    GoRouter.of(context).pop(
      Property(
        id: widget.initialProperty?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        address: _addressController.text,
        tenant: _tenantController.text,
        // Сохраняем цвет как HEX-строку
        color: '0x${_selectedColor.value.toRadixString(16).toUpperCase()}',
        startDate: _startDateController.text,
        endDate: _endDateController.text,
        price: _priceController.text,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _tenantController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _priceController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.primary),
        title: Text(
          'Property Editor',
          style: AppTextStyles.subtitle.copyWith(
            fontSize: 20.5,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check,
              color: AppColors.success,
              size: 28,
            ),
            onPressed: _submit,
          ),
        ],
        shape: Border(
          bottom: BorderSide(
            color: AppColors.surface.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            //******** PROPERTY NAME FIELD ********
            const Text(
              'Property name*',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'e.g. two bedroom apartment',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: AppColors.filled,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: const BorderSide(
                    color: AppColors.inputBorder,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            //******** ADDRESS FIELD ********
            const Text(
              'Address*',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _addressController,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'e.g. 123 Main St',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: AppColors.filled,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: const BorderSide(
                    color: AppColors.inputBorder,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            //******** TENANT FIELD ********
            const Text(
              'Tenant*',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _tenantController,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'Full name',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: AppColors.filled,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: const BorderSide(
                    color: AppColors.inputBorder,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            //******** PRICE FIELD ********
            const SizedBox(height: 16),
            const Text(
              'Price*',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            //******** PRICE FIELD ********
            TextFormField(
              controller: _priceController,
              style: const TextStyle(color: Colors.black87),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: InputDecoration(
                hintText: 'Enter price',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: AppColors.filled,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: const BorderSide(
                    color: AppColors.inputBorder,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            //******** COLOR FIELD ********
            const Text(
              'Color',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _selectedColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: _selectedColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black26),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Selected color',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 48,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _availableColors.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final color = _availableColors[index];
                        final isSelected = _selectedColor == color;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColor = color;
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? Colors.black : Colors.transparent,
                                width: 1.5,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      );
  }
}
