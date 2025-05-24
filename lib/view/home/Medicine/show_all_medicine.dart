import 'package:flutter/material.dart';
import 'package:healthmvp/ViewModel/show_medicine_authmodel.dart';
import 'package:healthmvp/models/userMedicineModel/usermedicinemodel.dart';
import 'package:healthmvp/widgets/customdropdown.dart';
import 'package:provider/provider.dart';

class MedicineListScreen extends StatefulWidget {
  const MedicineListScreen({Key? key}) : super(key: key);

  @override
  _MedicineListScreenState createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  ShowMedicineAuthmodel? showmedicinemodell;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  List<String> _categories = ['All'];

  @override
  void initState() {
    super.initState();
    showmedicinemodell = Provider.of<ShowMedicineAuthmodel>(
      context,
      listen: false,
    );
    fetchMedicines();
  }

  Future<void> fetchMedicines() async {
    await showmedicinemodell?.getallmedicineusers(context);
    final medicines = showmedicinemodell?.getusermedicines?.data ?? [];

    final uniqueCategories =
        medicines
            .map((m) => m.category ?? '')
            .where((category) => category.isNotEmpty)
            .toSet()
            .toList();

    if (!uniqueCategories.contains('All')) {
      uniqueCategories.insert(0, 'All');
    }

    setState(() {
      _categories = uniqueCategories;
    });
  }

  List<Datum> get _filteredMedicines {
    final medicines = showmedicinemodell?.getusermedicines?.data ?? [];
    return medicines.where((medicine) {
      final nameMatch = (medicine.name ?? '').toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final categoryMatch =
          _selectedCategory == 'All' ||
          (medicine.category ?? '') == _selectedCategory;
      return nameMatch && categoryMatch;
    }).toList();
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Tablet':
        return const Color(0xFF2563EB);
      case 'Syrup':
        return const Color(0xFF8B5CF6);
      case 'Injection':
        return const Color(0xFFDC2626);
      case 'Cream / Ointment / Gel':
        return const Color(0xFF10B981);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseUrl = showmedicinemodell?.getusermedicines?.baseUrl ?? "";

    final emojiMap = {
      'tablet': '⚪',
      'injection': '💉',
      'liquid': '💧',
      'capsule': '💊',
    };

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "My Medicines",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search for medicines...",
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:
                          _categories.map((category) {
                            final isSelected = _selectedCategory == category;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCategory = category;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? const Color(0xFF2563EB)
                                            : Colors.white,
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Medicine Count
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${_filteredMedicines.length} Medicines",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),

          // Medicine List
          Expanded(
            child:
                _filteredMedicines.isEmpty
                    ? const Center(
                      child: Text(
                        "No medicines found",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredMedicines.length,
                      itemBuilder: (context, index) {
                        final medicine = _filteredMedicines[index];
                        final category = medicine.category;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              // Navigate to medicine detail page
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  // Medicine Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      "$baseUrl$category",
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFDBEAFE),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            emojiMap[category?.toLowerCase() ??
                                                    ''] ??
                                                '💊',
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // Medicine Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              medicine.name ?? '',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF1F2937),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _showEditDialog(medicine);
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Edit",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 3,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: _getCategoryColor(
                                                  category!,
                                                ).withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                category,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: _getCategoryColor(
                                                    category,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 3,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                "Dosage: ${medicine.dosage}",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF6B7280),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Datum medicine) {
  final nameController = TextEditingController(text: medicine.name ?? '');
  final dosageController = TextEditingController(text: medicine.dosage ?? '');

  final availableCategories = [
    'Tablet',
    'Capsule',
    'Syrup',
    'Injection',
    'Cream / Ointment / Gel',
    'Liquid',
    'Ointment',
  ];

  // Normalize and match category
  String categoryNormalized = (medicine.category ?? '').toLowerCase();
  String matchedCategory = availableCategories.firstWhere(
    (cat) => cat.toLowerCase() == categoryNormalized,
    orElse: () => availableCategories.first,
  );

  String selectedCategory = matchedCategory;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Edit Medicine"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: dosageController,
                decoration: const InputDecoration(labelText: 'Dosage'),
              ),
              const SizedBox(height: 10),
              CustomDropdown(
                data: availableCategories,
                selectedValue: selectedCategory,
                onChanged: (value) {
                  if (value != null) {
                    selectedCategory = value;
                  }
                },
                hintText: 'Select Category',
                title: const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final updatedName = nameController.text.trim();
              final updatedDosage = dosageController.text.trim();
              final updatedCategory = selectedCategory;

              if (updatedName.isEmpty || updatedDosage.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill all fields")),
                );
                return;
              }

              // Call the API
              await Provider.of<ShowMedicineAuthmodel>(context, listen: false)
                  .editmedicinee(
                    context,
                    medicine.id ?? '', // Make sure `id` is not null
                    updatedDosage,
                    updatedCategory,
                    updatedName,
                  );

              // Refresh medicine list after editing
              await fetchMedicines();

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}

}
