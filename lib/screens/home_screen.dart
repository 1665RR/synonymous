import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _synonymController = TextEditingController();

  Map<String, List<String>> synonyms = {
    'happy': ['joyful', 'content', 'cheerful'],
    'sad': ['unhappy', 'depressed', 'downcast'],
    'fast': ['quick', 'swift', 'speedy'],
  };

  String _searchResult = '';
  String _addSynonymResult = '';
  List<String> _suggestions = [];

  // create suggestion from search input
  void _searchSuggestions(String input) {
    setState(() {
      _suggestions = synonyms.keys
          .where((synonym) =>
              synonym.toLowerCase().startsWith(input.toLowerCase()))
          .toList();
    });
  }

  // search through synonyms
  void _searchSynonym(String word) {
    setState(() {
      if (word.isEmpty) {
        _searchResult = '';
      } else if (synonyms.containsKey(word.toLowerCase())) {
        _searchResult =
            'Synonyms for "$word": ${synonyms[word.toLowerCase()]?.join(', ')}';
      } else {
        _searchResult = 'No synonyms found for "$word"';
      }
    });
  }

  // add new synonym
  void _addSynonym() {
    String input = _inputController.text.trim().toLowerCase();
    String synonym = _synonymController.text.trim().toLowerCase();

    if (input.isNotEmpty && synonym.isNotEmpty) {
      setState(() {
        if (synonyms.containsKey(input)) {
          synonyms[input]?.add(synonym);
        } else {
          synonyms[input] = [synonym];
        }
        _addSynonymResult = 'Synonym "$synonym" added for "$input"!';
      });
    } else {
      setState(() {
        _addSynonymResult = 'Please provide both word and synonym.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Enter word to search for synonyms',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (text) {
              _searchSynonym(text); // Trigger search as user types
              _searchSuggestions(text); // Update suggestions as user types
            },
          ),
        ),
        SizedBox(height: 10),
        if (_suggestions.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _suggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_suggestions[index]),
                onTap: () {
                  _searchController.text = _suggestions[index];
                  _searchSynonym(_suggestions[index]);
                  setState(() {
                    _suggestions.clear();
                  });
                },
              );
            },
          ),
        if (_searchResult.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              _searchResult,
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Synonymous',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        SizedBox(height: 20),
        TextField(
          controller: _inputController,
          decoration: InputDecoration(
            labelText: 'Enter word to add a synonym',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _synonymController,
          decoration: InputDecoration(
            labelText: 'Enter synonym to add',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _addSynonym,
          child: Text('Add Synonym'),
        ),
        SizedBox(height: 10),
        Text(
          _addSynonymResult,
          style: TextStyle(fontSize: 16, color: Colors.green),
        ),
      ]),
    );
  }
}
