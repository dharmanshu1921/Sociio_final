import 'package:flutter/material.dart';

class SearchPostPage extends StatefulWidget {
  const SearchPostPage({super.key});

  @override
  _SearchPostPageState createState() => _SearchPostPageState();
}

class _SearchPostPageState extends State<SearchPostPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        title: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.calendar_today,
                color: Colors.red, 
              ),
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                }
              },
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                  });
                },
              ),
          ],
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: SearchPostPage(),
  ));
}
