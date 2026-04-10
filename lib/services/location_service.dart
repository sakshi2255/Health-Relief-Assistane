import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart'; // ✅ Needed for debugPrint

class MedicalLocation {
  final String name;
  final String address;
  final double rating;
  final String distance;
  final String hours;

  MedicalLocation({
    required this.name,
    required this.address,
    required this.rating,
    required this.distance,
    required this.hours
  });
}

class LocationService {
  // ✅ FIXED: Removed static final _apiKey to prevent NotInitializedError on startup.

  Future<List<MedicalLocation>> fetchNearby(String selectedTab) async {
    try {
      // ✅ FIXED: Fetch key inside the method safely.
      final String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? "";

      if (apiKey.isEmpty) {
        debugPrint("❌ API Key is missing from .env!");
        return [];
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return [];
      }
      Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      List<String> includedTypes = [];
      if (selectedTab == "hospitals") {
        includedTypes = ["hospital", "medical_center"];
      } else if (selectedTab == "physio") {
        // ✅ FIXED: Removed unsupported types
        includedTypes = ["physiotherapist", "medical_clinic"];
      } else {
        // ✅ FIXED: Removed 'medical store' (Google only allows 'pharmacy' or 'drugstore')
        includedTypes = ["pharmacy", "drugstore"];
      }

      final Uri url = Uri.parse("https://places.googleapis.com/v1/places:searchNearby");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "X-Goog-Api-Key": apiKey, // ✅ FIXED: use local apiKey variable
          "X-Goog-FieldMask": "places.displayName,places.formattedAddress,places.rating,places.location,places.regularOpeningHours"
        },
        body: jsonEncode({
          "includedTypes": includedTypes,
          "maxResultCount": 20,
          "locationRestriction": {
            "circle": {
              "center": {"latitude": pos.latitude, "longitude": pos.longitude},
              "radius": 10000.0 // 10km
            }
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['places'] ?? [];

        return results.map((item) {
          double dist = Geolocator.distanceBetween(
              pos.latitude, pos.longitude,
              item['location']['latitude'], item['location']['longitude']
          );

          return MedicalLocation(
            name: item['displayName']['text'] ?? "Medical Center",
            address: item['formattedAddress'] ?? "No address",
            rating: (item['rating'] ?? 0.0).toDouble(),
            distance: "${(dist / 1000).toStringAsFixed(1)} km",
            hours: item['regularOpeningHours'] != null ? "Open" : "N/A",
          );
        }).toList();
      }
      debugPrint("API Error: ${response.body}");
      return [];
    } catch (e) {
      debugPrint("Flutter Error: $e");
      return [];
    }
  }
}