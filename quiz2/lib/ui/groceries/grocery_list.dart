import 'package:flutter/material.dart';

import '../../data/mock_grocery_repository.dart';
import '../../models/grocery.dart';
import 'grocery_form.dart';

enum GroceryTabs { grocery, search }

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  GroceryTabs _selectedTab = GroceryTabs.grocery;
  final TextEditingController _inputController = TextEditingController();

  Future<void> onCreate() async {
    final Grocery? newGrocery = await Navigator.push<Grocery>(
      context,
      MaterialPageRoute(builder: (context) => const GroceryForm()),
    );

    if (newGrocery != null) {
      setState(() {
        dummyGroceryItems.add(newGrocery);
      });
    }
  }

  List<Grocery> get _filteredGroceries {
    final query = _inputController.text.toLowerCase();
    if (query.isEmpty) return dummyGroceryItems;
    return dummyGroceryItems
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Widget _buildGroceryList() {
    if (dummyGroceryItems.isEmpty) {
      return const Center(child: Text('No items added yet.'));
    }

    return ListView.builder(
      itemCount: dummyGroceryItems.length,
      itemBuilder: (context, index) =>
          GroceryTile(grocery: dummyGroceryItems[index]),
    );
  }

  Widget _buildSearch() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _inputController,
            decoration: const InputDecoration(
              labelText: 'Enter to search',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        Expanded(
          child: _filteredGroceries.isEmpty
              ? const Center(child: Text('No results found'))
              : ListView.builder(
                  itemCount: _filteredGroceries.length,
                  itemBuilder: (context, index) =>
                      GroceryTile(grocery: _filteredGroceries[index]),
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            onPressed: onCreate,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _selectedTab == GroceryTabs.grocery
          ? _buildGroceryList()
          : _buildSearch(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab.index,
        selectedItemColor: Colors.red,
        onTap: (index) {
          setState(() {
            _selectedTab = GroceryTabs.values[index];
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store),
            label: 'Groceries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
    );
  }
}

class GroceryTile extends StatelessWidget {
  const GroceryTile({super.key, required this.grocery});

  final Grocery grocery;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
          color: grocery.category.color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      title: Text(grocery.name),
      trailing: Text(grocery.quantity.toString()),
    );
  }
}