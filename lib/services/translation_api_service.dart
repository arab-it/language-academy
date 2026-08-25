import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiLanguage {
  final String code;
  final String name;

  const ApiLanguage({required this.code, required this.name});
}

class TranslationApiService {
  static const List<String> servers = [
    'https://translate.cutie.dating',
    'https://translate.fedilab.app',
  ];

  static Future<List<ApiLanguage>> getLanguages() async {
    for (final server in servers) {
      try {
        final response = await http
            .get(
              Uri.parse('$server/languages'),
              headers: {'Accept': 'application/json'},
            )
            .timeout(const Duration(seconds: 8));

        if (response.statusCode != 200) {
          continue;
        }

        final data = jsonDecode(response.body) as List<dynamic>;

        return data
            .map(
              (item) => ApiLanguage(
                code: item['code'].toString(),
                name: item['name'].toString(),
              ),
            )
            .toList();
      } catch (_) {
        continue;
      }
    }

    return [];
  }
}

