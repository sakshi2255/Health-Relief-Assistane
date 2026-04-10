import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/location_service.dart';
import '../widgets/tr_text.dart'; // ✅ Added for translations

class NearbyScreen extends StatefulWidget {
  const NearbyScreen({super.key});

  @override
  State<NearbyScreen> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  String selectedTab = "hospitals";
  List<MedicalLocation> locations = [];
  bool isLoading = true;
  final LocationService _service = LocationService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    final results = await _service.fetchNearby(selectedTab);
    if (!mounted) return;
    setState(() {
      locations = results;
      isLoading = false;
    });
  }

  void _openDirections(String name, String address) async {
    // ✅ FIXED: Corrected the maps deep link format to prevent crashes
    final query = Uri.encodeComponent('$name, $address');
    final googleMapsUrl = Uri.parse("google.navigation:q=$query");
    final webUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint("Could not launch map: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Requirement 1: Responsive width detection
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        // ✅ Requirement 2: Translated AppBar
        title: const TrText("Nearby Medical Support", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: const Color(0xFF00796B),
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF00796B)))
            : ListView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth > 600 ? 40 : 20, vertical: 20),
          children: [
            // Tab Buttons (Responsive Row)
            Row(
              children: [
                _tabButton("hospitals", LucideIcons.building2, "Hospitals"),
                const SizedBox(width: 8),
                _tabButton("physio", LucideIcons.accessibility, "Physio"),
                const SizedBox(width: 8),
                _tabButton("stores", LucideIcons.pill, "Stores"),
              ],
            ),
            const SizedBox(height: 20),

            if (locations.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Column(
                    children: [
                      const Icon(LucideIcons.searchX, size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      // ✅ Requirement 2: Translated Empty State
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const TrText("No", style: TextStyle(color: Colors.grey)),
                          const SizedBox(width: 4),
                          TrText(selectedTab, style: const TextStyle(color: Colors.grey)),
                          const SizedBox(width: 4),
                          const TrText("found nearby", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            else
              ...locations.map((item) => _buildMedicalCard(item)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(String key, IconData icon, String label) {
    bool isActive = selectedTab == key;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() => selectedTab = key);
          _loadData();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
              color: isActive ? const Color(0xFF00796B) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [if(!isActive) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: isActive ? Colors.white : Colors.black87),
              const SizedBox(width: 6),
              // ✅ Requirement 2: Translated Tab Label
              Flexible(child: TrText(label, style: TextStyle(color: isActive ? Colors.white : Colors.black87, fontSize: 10, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicalCard(MedicalLocation item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))]
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
                    Text(item.address, style: const TextStyle(color: Colors.grey, fontSize: 11), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if(item.rating > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      const Icon(LucideIcons.star, color: Colors.amber, size: 10),
                      const SizedBox(width: 4),
                      Text(item.rating.toString(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => _openDirections(item.name, item.address),
              icon: const Icon(LucideIcons.mapPin, size: 14),
              // ✅ Requirement 2: Translated Button
              label: const TrText("Get Directions"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00796B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          )
        ],
      ),
    );
  }
}