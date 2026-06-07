import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme.dart';

class BuyerSearchScreen extends StatefulWidget {
  const BuyerSearchScreen({Key? key}) : super(key: key);

  @override
  State<BuyerSearchScreen> createState() => _BuyerSearchScreenState();
}

class _BuyerSearchScreenState extends State<BuyerSearchScreen> {
  final _searchController = TextEditingController();
  String _selectedCrop = '';
  String _selectedRegion = '';
  bool _isFiltering = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Search Produce'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search & Filter
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search crops...',
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.borderColor),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {
                        setState(() => _isFiltering = !_isFiltering);
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Filter Panel
            if (_isFiltering)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Crop Type', style: AppTheme.labelMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['Maize', 'Rice', 'Tomatoes', 'Beans', 'Potatoes']
                          .map((crop) {
                        return FilterChip(
                          label: Text(crop),
                          selected: _selectedCrop == crop,
                          onSelected: (selected) {
                            setState(() => _selectedCrop = selected ? crop : '');
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Text('Region', style: AppTheme.labelMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: ['Dar es Salaam', 'Morogoro', 'Iringa', 'Mbeya']
                          .map((region) {
                        return FilterChip(
                          label: Text(region),
                          selected: _selectedRegion == region,
                          onSelected: (selected) {
                            setState(() => _selectedRegion = selected ? region : '');
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            
            // Results
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return _SearchResultCard(
                    cropName: ['Maize', 'Rice', 'Tomatoes', 'Beans', 'Maize', 'Potatoes', 'Rice', 'Tomatoes'][index],
                    quantity: '${100 + (index * 25)} kg',
                    price: '${800 + (index * 50)} TSH/kg',
                    location: ['Morogoro', 'Dar es Salaam', 'Iringa', 'Mbeya', 'Morogoro', 'Dodoma', 'Dar es Salaam', 'Iringa'][index],
                    farmerName: ['John Farm', 'Mary Seeds', 'Peter Green', 'Jane Foods', 'John Farm', 'Moses Agri', 'Mary Seeds', 'Peter Green'][index],
                    rating: 4.5 + (index * 0.1),
                    reviews: 12 + (index * 2),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final String cropName;
  final String quantity;
  final String price;
  final String location;
  final String farmerName;
  final double rating;
  final int reviews;

  const _SearchResultCard({
    required this.cropName,
    required this.quantity,
    required this.price,
    required this.location,
    required this.farmerName,
    required this.rating,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to detail
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cropName, style: AppTheme.labelLarge),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textSecondary),
                          const SizedBox(width: 4),
                          Text(location, style: AppTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                  Icon(Icons.favorite_outline, color: AppTheme.textSecondary),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Qty: $quantity', style: AppTheme.bodyMedium),
                      Text('Price: $price', style: AppTheme.labelLarge),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text('$rating ($reviews)', style: AppTheme.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(farmerName, style: AppTheme.labelMedium),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.phone, size: 16),
                      label: const Text('Call'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.chat, size: 16),
                      label: const Text('Message'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
