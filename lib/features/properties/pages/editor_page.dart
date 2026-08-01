import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:logeria/core/domain/property.dart';
import 'package:intl/intl.dart';
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
    const Color(0xFF757575), // default color
  ];

  Color _selectedColor = Color(0xFF757575); // default color

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
    String hex = colorStr.replaceAll('0x', '').replaceAll('#', '').trim();
    
    if (hex.length == 6) {
      hex = 'FF' + hex;
    }
    
    final value = int.parse(hex, radix: 16);
    return Color(value);
  } catch (_) {
    return null;
  }
}

Future<void> _selectStartDate(BuildContext context) async {
  final now = DateTime.now();
  final currentStart = _parseDate(_startDateController.text);
  final currentEnd = _parseDate(_endDateController.text);

  final initial = currentStart ?? now;

  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );

  if (picked != null) {
    setState(() {
      _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);

      if (currentEnd != null && picked.isAfter(currentEnd)) {
        _endDateController.clear();
      }
    });
  }
}

Future<void> _selectEndDate(BuildContext context) async {
  final now = DateTime.now();
  final start = _parseDate(_startDateController.text);
  final currentEnd = _parseDate(_endDateController.text);

  final firstAllowedDate = start ?? DateTime(2000);

  DateTime initial = currentEnd ?? now;
  if (initial.isBefore(firstAllowedDate)) {
    initial = firstAllowedDate;
  }

  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: firstAllowedDate,
    lastDate: DateTime(2100),
  );

  if (picked != null) {
    setState(() {
      _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
    });
  }
}

DateTime? _parseDate(String dateStr) {
    if (dateStr.trim().isEmpty) return null;
    try {
      return DateTime.parse(dateStr.trim());
    } catch (_) {
      try {
        return DateFormat('dd.MM.yyyy').parseStrict(dateStr.trim());
      } catch (_) {
        try {
          return DateFormat('dd/MM/yyyy').parseStrict(dateStr.trim());
        } catch (_) {
          return null;
        }
      }
    }
  }

  void _submit() {
    setState(() {
      _errorMessage = null;
    });

    if (_nameController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty ||
        _tenantController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all required fields.';
      });
      return;
    }

    final monthlyPrice = double.tryParse(_priceController.text.replaceAll(',', '.'));
    if (monthlyPrice == null) {
      setState(() {
        _errorMessage = 'Please enter a valid price.';
      });
      return;
    }

    double profit = 0.0;
    final start = _parseDate(_startDateController.text);
    final end = _parseDate(_endDateController.text);

    if (start != null && end != null && end.isAfter(start)) {
      final days = end.difference(start).inDays;
      final dailyRate = monthlyPrice / 30;
      profit = dailyRate * days;
    } else {
      profit = monthlyPrice;
    }

    final String profitFormatted = profit.toStringAsFixed(2);

    GoRouter.of(context).pop(
      Property(
        id: widget.initialProperty?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        address: _addressController.text,
        tenant: _tenantController.text,
        color: '0x${_selectedColor.value.toRadixString(16).toUpperCase()}',
        startDate: _startDateController.text,
        endDate: _endDateController.text,
        price: _priceController.text,
        profit: profitFormatted, 
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
        child: SingleChildScrollView(
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
            const SizedBox(height: 16),
            const Text(
              'Rental start date*',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            //******** RENTAL START DATE FIELD ********
            TextFormField(
              controller: _startDateController,
              readOnly: true,
              style: const TextStyle(color: Colors.black87),
              onTap: () async {
                final currentStart = _parseDate(_startDateController.text);
                final currentEnd = _parseDate(_endDateController.text);

                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: currentStart ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  setState(() {
                    _startDateController.text = DateFormat('dd.MM.yyyy').format(pickedDate);

                    if (currentEnd != null && pickedDate.isAfter(currentEnd)) {
                      _endDateController.clear();
                    }
                  });
                }
              },
              decoration: InputDecoration(
                hintText: 'Enter rental start date',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: AppColors.filled,
                prefixIcon: const Icon(Icons.calendar_today, color: Color.fromARGB(255, 0, 206, 45)),
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
            const Text(
              'Rental end date*',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),

            //******** RENTAL END DATE FIELD ********
            TextFormField(
              controller: _endDateController,
              readOnly: true,
              style: const TextStyle(color: Colors.black87),
              onTap: () async {
                final start = _parseDate(_startDateController.text);
                final currentEnd = _parseDate(_endDateController.text);

                final firstAllowedDate = start ?? DateTime(2000);

                DateTime initial = currentEnd ?? DateTime.now();
                if (initial.isBefore(firstAllowedDate)) {
                  initial = firstAllowedDate;
                }

                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: initial,
                  firstDate: firstAllowedDate,
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  setState(() {
                    _endDateController.text = DateFormat('dd.MM.yyyy').format(pickedDate);
                  });
                }
              },
              decoration: InputDecoration(
                hintText: 'Enter rental end date',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: AppColors.filled,
                prefixIcon: const Icon(Icons.calendar_today, color: Colors.redAccent),
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
              'Price per month*',
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
              child: SingleChildScrollView(
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
            )
          ],
        ),
      ),
      )
      );
  }
}
