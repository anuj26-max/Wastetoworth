import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/marketplace_listing.dart';
import '../../models/waste_item.dart';
import '../../providers/marketplace_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/custom_button.dart';

class CreateListingScreen extends StatefulWidget {
  final String? prefilledTitle;
  final WasteCategory? prefilledCategory;
  final double? prefilledPrice;
  final String? prefilledDescription;
  final String? prefilledImageUrl;

  const CreateListingScreen({
    super.key,
    this.prefilledTitle,
    this.prefilledCategory,
    this.prefilledPrice,
    this.prefilledDescription,
    this.prefilledImageUrl,
  });

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _brandController;
  late TextEditingController _conditionController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;

  late WasteCategory _selectedCategory;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.prefilledTitle ?? '');
    _priceController = TextEditingController(
      text: widget.prefilledPrice != null
          ? widget.prefilledPrice!.toStringAsFixed(0)
          : '',
    );
    _brandController = TextEditingController(text: 'Standard Grade Recyclable');
    _conditionController = TextEditingController(text: 'Clean sorted condition');
    _locationController = TextEditingController(text: 'HSR Layout, Bangalore');
    _descriptionController = TextEditingController(
      text: widget.prefilledDescription ??
          'Well-preserved recyclable waste sorted for direct recycling or upcycling reuse.',
    );
    _selectedCategory = widget.prefilledCategory ?? WasteCategory.plastic;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _brandController.dispose();
    _conditionController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitListing() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final user = auth.currentUser;
    final marketplace = Provider.of<MarketplaceProvider>(context, listen: false);

    final newListing = MarketplaceListing(
      id: 'item_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      price: double.tryParse(_priceController.text.trim()) ?? 100.0,
      category: _selectedCategory,
      location: _locationController.text.trim(),
      postedTimeAgo: 'Just now',
      imageUrls: [
        widget.prefilledImageUrl ??
            'https://images.unsplash.com/photo-1558346490-a72e53ae2d4f?w=800',
      ],
      sellerName: user.name,
      sellerAvatar: user.avatarUrl,
      sellerRating: 5.0,
      brandOrType: _brandController.text.trim(),
      conditionOrDefect: _conditionController.text.trim(),
      warrantyOrCertification: 'Verified Recyclable Lot',
      accessoriesOrQuantity: 'Packed in bag / bundle',
      description: _descriptionController.text.trim(),
      weightKg: 2.5,
    );

    await marketplace.addListing(newListing);

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Listing successfully posted to Waste2Worth!'),
          backgroundColor: AppColors.primary,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          'Post Waste / Scrap Item',
          style: AppTypography.titleLarge,
        ),
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Banner
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: widget.prefilledImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          widget.prefilledImageUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_a_photo_outlined,
                            size: 40,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Item Photo Attached',
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Photos increase buyer trust by 80%',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 24),

              // Title
              Text('Item Title', style: AppTypography.titleSmall),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Please enter a title' : null,
                decoration: const InputDecoration(
                  hintText: 'e.g. Clean Sorted Copper Wire (10 kg)',
                ),
              ),

              const SizedBox(height: 16),

              // Category Picker
              Text('Category', style: AppTypography.titleSmall),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<WasteCategory>(
                    isExpanded: true,
                    value: _selectedCategory,
                    items: WasteCategory.values.map((cat) {
                      return DropdownMenuItem(
                        value: cat,
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Color(cat.colorValue),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(cat.label, style: AppTypography.bodyLarge),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Price
              Text('Expected Price (₹)', style: AppTypography.titleSmall),
              const SizedBox(height: 6),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Please enter a price' : null,
                decoration: const InputDecoration(
                  prefixText: '₹ ',
                  hintText: 'e.g. 450',
                ),
              ),

              const SizedBox(height: 16),

              // Brand / Grade
              Text('Brand / Scrap Grade', style: AppTypography.titleSmall),
              const SizedBox(height: 6),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Type-1 PET / Apple / Industrial Scrap',
                ),
              ),

              const SizedBox(height: 16),

              // Condition / Defect
              Text('Condition / Defect Notes', style: AppTypography.titleSmall),
              const SizedBox(height: 6),
              TextFormField(
                controller: _conditionController,
                decoration: const InputDecoration(
                  hintText: 'e.g. Stripped clean, dry, washed',
                ),
              ),

              const SizedBox(height: 16),

              // Location
              Text('Pickup Location', style: AppTypography.titleSmall),
              const SizedBox(height: 6),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.location_on_outlined, size: 20),
                  hintText: 'e.g. HSR Layout, Bangalore',
                ),
              ),

              const SizedBox(height: 16),

              // Description
              Text('Description', style: AppTypography.titleSmall),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Describe scrap quantity, pickup timing, etc.',
                ),
              ),

              const SizedBox(height: 30),

              // Submit Button
              CustomButton(
                text: 'Publish Listing',
                icon: Icons.check_circle_outline_rounded,
                isLoading: _isSubmitting,
                onPressed: _submitListing,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
