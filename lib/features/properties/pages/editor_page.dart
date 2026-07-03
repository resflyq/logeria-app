import 'package:flutter/material.dart';
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
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialProperty?.name ?? '';
    _addressController.text = widget.initialProperty?.address ?? '';
    _tenantController.text = widget.initialProperty?.tenant ?? '';
  }

  void _submit() {
    setState(() {
      _errorMessage = null;
    });

    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _tenantController.text.isEmpty) {
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
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _tenantController.dispose();
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
          ],
        ),
      ),
    );
  }
}
