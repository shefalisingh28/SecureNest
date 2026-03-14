import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ==========================================
// 1. DYNAMIC SECURENEST DRAWER
// ==========================================
class SecureNestDrawer extends StatelessWidget {
  final String? userName;
  final String? userEmail;
  final bool isLandlord;
  final bool isDarkMode;
  final VoidCallback onLogout;
  final VoidCallback toggleTheme;
  final Function(String) onNavigate;

  const SecureNestDrawer({
    super.key, this.userName, this.userEmail, required this.isLandlord,
    required this.isDarkMode, required this.onLogout, required this.toggleTheme, required this.onNavigate
  });

  @override
  Widget build(BuildContext context) {
    Color textColor = isDarkMode ? Colors.white : Colors.black87;
    return Drawer(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 20, left: 24),
            color: isLandlord ? Colors.black : Colors.teal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(radius: 35, backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.grey, size: 40)),
                const SizedBox(height: 15),
                Text(userName ?? (isLandlord ? "Aman Kumar" : "Rahul Sharma"), style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text(userEmail ?? "+91 9876543210\nDelhi NCR, India", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(Icons.person_outline, "My Profile", textColor, () => onNavigate("My Profile")),
                _drawerItem(Icons.verified_user, "KYC Verification", Colors.green, () => onNavigate("KYC Verification")),
                const Divider(),
                
                if (!isLandlord) ...[
                  _drawerItem(Icons.payment, "Pay Rent", textColor, () => onNavigate("Pay Rent")),
                  _drawerItem(Icons.electric_bolt, "Pay Electricity", textColor, () => onNavigate("Pay Electricity")),
                  _drawerItem(Icons.water_drop, "Pay Water", textColor, () => onNavigate("Pay Water")),
                  _drawerItem(Icons.report_problem_outlined, "Report Issue", Colors.orange, () => onNavigate("Report Issue")),
                  _drawerItem(Icons.star_rate, "Rate House", textColor, () => onNavigate("Rate House")),
                ] else ...[
                  _drawerItem(Icons.account_balance_wallet, "Check Rent", textColor, () => onNavigate("Check Rent")),
                  _drawerItem(Icons.electric_bolt, "Check Electricity", textColor, () => onNavigate("Check Electricity")),
                  _drawerItem(Icons.water_drop, "Check Water", textColor, () => onNavigate("Check Water")),
                  _drawerItem(Icons.analytics, "Occupancy Rate", textColor, () => onNavigate("Occupancy Rate")),
                  _drawerItem(Icons.apartment, "My Properties", textColor, () => onNavigate("My Properties")),
                  _drawerItem(Icons.gavel, "Complain Damage", Colors.redAccent, () => onNavigate("Complain Damage")),
                ],
                const Divider(),
                
                _drawerItem(Icons.history, "History", textColor, () => onNavigate("History")),
                _drawerItem(Icons.settings_outlined, "Settings", textColor, () => onNavigate("Settings")),
                _drawerItem(Icons.language, "Language", textColor, () => onNavigate("Language")),
                
                ListTile(
                  leading: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode, color: textColor),
                  title: Text("Dark Mode", style: GoogleFonts.poppins(color: textColor, fontWeight: FontWeight.w500)),
                  trailing: Switch(value: isDarkMode, onChanged: (v) => toggleTheme(), activeColor: Colors.teal),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(leading: const Icon(Icons.logout, color: Colors.redAccent), title: Text("Logout", style: GoogleFonts.poppins(color: Colors.redAccent, fontWeight: FontWeight.bold)), onTap: onLogout),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  Widget _drawerItem(IconData icon, String title, Color color, VoidCallback onTap) {
    return ListTile(leading: Icon(icon, color: color), title: Text(title, style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.w500)), onTap: onTap);
  }
}

// ==========================================
// 2. SEARCH DELEGATE (Interactive Search Bar)
// ==========================================
class DummySearchDelegate extends SearchDelegate<String> {
  final List<String> dummyData = ["Opulence Apt", "Sunny Villa", "Delhi NCR Rentals", "Green Villa Noida", "Studio Apartments"];
  @override
  List<Widget> buildActions(BuildContext context) => [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = "")];
  @override
  Widget buildLeading(BuildContext context) => IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, ""));
  @override
  Widget buildResults(BuildContext context) => Center(child: Text("Showing results for '$query'", style: GoogleFonts.poppins(fontSize: 18)));
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = dummyData.where((element) => element.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) => ListTile(
        leading: const Icon(Icons.search, color: Colors.teal),
        title: Text(suggestions[index], style: GoogleFonts.poppins()),
        onTap: () { query = suggestions[index]; showResults(context); },
      ),
    );
  }
}

// ==========================================
// 3. PROPERTY DETAIL SCREEN (This was missing!)
// ==========================================
class PropertyDetailScreen extends StatelessWidget {
  final String title;
  final String price;
  final String location;
  final String imagePath;
  
  const PropertyDetailScreen({super.key, required this.title, required this.price, required this.location, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.white)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imagePath, height: 300, width: double.infinity, fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(height: 300, color: Colors.grey)),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold)),
                    Text(price, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(children: [const Icon(Icons.location_on, color: Colors.grey, size: 20), const SizedBox(width: 5), Text(location, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16))]),
                const SizedBox(height: 20),
                Text("Description", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text("A beautiful, well-maintained property in the heart of the city. Includes 24/7 security, power backup, and dedicated parking.", style: GoogleFonts.poppins(color: Colors.grey[700])),
                const SizedBox(height: 30),
                
                ListTile(
                  tileColor: Colors.teal.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  leading: const Icon(Icons.map, color: Colors.teal),
                  title: Text("View on Google Maps", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Opening Maps..."))),
                ),
                const SizedBox(height: 10),
                ListTile(
                  tileColor: Colors.blue.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  leading: const Icon(Icons.chat, color: Colors.blue),
                  title: Text("Chat with Landlord", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Opening Chat..."))),
                ),
                const SizedBox(height: 10),
                ListTile(
                  tileColor: Colors.orange.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  leading: const Icon(Icons.bookmark_add, color: Colors.orange),
                  title: Text("Add to Bookmarks", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saved to Bookmarks!"))),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ==========================================
// 4. FULLY POPULATED DUMMY SCREENS
// ==========================================

// --- BILLS & PAYMENTS ---
class PaymentScreen extends StatelessWidget {
  final String title;
  final bool isLandlord;
  const PaymentScreen({super.key, required this.title, required this.isLandlord});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title, style: const TextStyle(color: Colors.black)), backgroundColor: Colors.white, iconTheme: const IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long, size: 80, color: Colors.teal), const SizedBox(height: 20),
            Text(isLandlord ? "Tenant Payment Status" : "Amount Due", style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey)),
            Text("₹15,000", style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 10),
            Text("Due Date: 5th March 2026", style: GoogleFonts.poppins(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            if (!isLandlord)
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.teal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Processing Payment..."))),
                child: Text("Pay Now via UPI / Card", style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              )
            else
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reminder Sent to Tenant!"))),
                child: Text("Send Payment Reminder", style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }
}

// --- REPORT ISSUE / COMPLAIN DAMAGE ---
class ReportIssueScreen extends StatefulWidget {
  final String title;
  const ReportIssueScreen({super.key, required this.title});
  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}
class _ReportIssueScreenState extends State<ReportIssueScreen> {
  String _selectedIssue = "Plumbing";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title, style: const TextStyle(color: Colors.black)), backgroundColor: Colors.white, iconTheme: const IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Category", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedIssue,
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
              items: ["Plumbing", "Electrical", "Structural Damage", "Pest Control", "Other"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _selectedIssue = v!),
            ),
            const SizedBox(height: 20),
            Text("Upload Evidence (Image)", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Opening Camera/Gallery..."))),
              child: Container(
                height: 150, width: double.infinity,
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid)),
                child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.camera_alt, size: 40, color: Colors.grey), SizedBox(height: 10), Text("Tap to Upload Image", style: TextStyle(color: Colors.grey))]),
              ),
            ),
            const SizedBox(height: 20),
            Text("Description", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(maxLines: 4, decoration: InputDecoration(hintText: "Describe the issue in detail...", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Report Submitted Successfully!"))); Navigator.pop(context); },
              child: Text("Submit Report", style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}

// --- ANALYTICS / OCCUPANCY PAGE ---
class AnalyticsDummyScreen extends StatelessWidget {
  final String title;
  const AnalyticsDummyScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title, style: const TextStyle(color: Colors.black)), backgroundColor: Colors.white, iconTheme: const IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Overview (Last 6 Months)", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _barChart("Oct", 60), _barChart("Nov", 80), _barChart("Dec", 50), _barChart("Jan", 100), _barChart("Feb", 120), _barChart("Mar", 90),
              ],
            ),
            const SizedBox(height: 40),
            ListTile(tileColor: Colors.grey[100], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), leading: const Icon(Icons.trending_up, color: Colors.green), title: const Text("Revenue Growth"), trailing: const Text("+14%", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
            const SizedBox(height: 10),
            ListTile(tileColor: Colors.grey[100], shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), leading: const Icon(Icons.check_circle, color: Colors.teal), title: const Text("Occupancy Rate"), trailing: const Text("92%", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
  Widget _barChart(String month, double height) {
    return Column(children: [Container(height: height, width: 30, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5))), const SizedBox(height: 5), Text(month, style: const TextStyle(color: Colors.grey, fontSize: 12))]);
  }
}

// --- RATE HOUSE ---
class RateHouseScreen extends StatefulWidget {
  const RateHouseScreen({super.key});
  @override
  State<RateHouseScreen> createState() => _RateHouseScreenState();
}
class _RateHouseScreenState extends State<RateHouseScreen> {
  int rating = 4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rate Property", style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, iconTheme: const IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Icon(Icons.apartment, size: 80, color: Colors.teal), const SizedBox(height: 20),
            Text("How is your experience at Opulence Apt?", textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (index) => IconButton(icon: Icon(index < rating ? Icons.star : Icons.star_border, color: Colors.amber, size: 40), onPressed: () => setState(() => rating = index + 1)))),
            const SizedBox(height: 20),
            TextField(maxLines: 3, decoration: InputDecoration(hintText: "Leave a review (optional)", border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
            const SizedBox(height: 30),
            ElevatedButton(style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.teal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), onPressed: () { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Thank you for your rating!"))); Navigator.pop(context); }, child: Text("Submit Rating", style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)))
          ],
        ),
      ),
    );
  }
}

// --- SAVED PROPERTIES & MY PROPERTIES ---
class PropertiesListScreen extends StatelessWidget {
  final String title;
  const PropertiesListScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title, style: const TextStyle(color: Colors.black)), backgroundColor: Colors.white, iconTheme: const IconThemeData(color: Colors.black)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _miniPropCard("Green Villa", "₹25,000", "Noida, Sector 62", "assets/images/house2.png"),
          _miniPropCard("Bananza Palace", "₹85,000", "Downtown Delhi", "assets/images/house3.png"),
        ],
      ),
    );
  }
  Widget _miniPropCard(String title, String price, String loc, String img) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.asset(img, width: 60, height: 60, fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(width: 60, height: 60, color: Colors.grey))),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(loc), trailing: Text(price, style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }
}

// --- BASIC SCREENS ---
class KYCScreen extends StatelessWidget {
  const KYCScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("KYC Status", style: GoogleFonts.poppins(color: Colors.black)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)), body: Center(child: Padding(padding: const EdgeInsets.all(24.0), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.verified, size: 100, color: Colors.green), const SizedBox(height: 20), Text("KYC Verified Successfully!", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)), const SizedBox(height: 20), Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade300)), child: Column(children: [_infoRow("Document Type:", "Aadhar Card"), const Divider(), _infoRow("Document No:", "XXXX-XXXX-9821"), const Divider(), _infoRow("Verified On:", "12 Oct 2025")]))]))));
  }
  Widget _infoRow(String label, String value) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: GoogleFonts.poppins(color: Colors.grey)), Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.bold))]);
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Payment History", style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, iconTheme: const IconThemeData(color: Colors.black)), body: ListView(padding: const EdgeInsets.all(20), children: [_historyCard("Rent - March 2026", "₹15,000", "Paid on 5 Mar", Colors.green), _historyCard("Electricity Bill", "₹1,250", "Paid on 2 Mar", Colors.green), _historyCard("Water Bill", "₹300", "Pending", Colors.orange), _historyCard("Rent - Feb 2026", "₹15,000", "Paid on 4 Feb", Colors.green)]));
  }
  Widget _historyCard(String title, String amt, String status, Color c) => Card(margin: const EdgeInsets.only(bottom: 15), child: ListTile(title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(status, style: TextStyle(color: c)), trailing: Text(amt, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))));
}

class NotificationsScreen extends StatelessWidget {
  final bool isLandlord;
  const NotificationsScreen({super.key, required this.isLandlord});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Notifications", style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, iconTheme: const IconThemeData(color: Colors.black)), body: ListView(padding: const EdgeInsets.all(20), children: isLandlord ? [_notiCard(Icons.attach_money, "Rent Received", "Aman Kumar paid ₹25,000 for Green Villa.", Colors.green), _notiCard(Icons.warning, "Maintenance Request", "Unit 404 reported a plumbing issue.", Colors.red), _notiCard(Icons.document_scanner, "New Lease Signed", "Sunny Apt lease renewed for 11 months.", Colors.blue)] : [_notiCard(Icons.warning, "Electricity Bill Pending", "Your bill of ₹1,400 is due in 2 days.", Colors.orange), _notiCard(Icons.verified, "Trust Score Updated", "Your score increased by 15 points!", Colors.green), _notiCard(Icons.message, "Landlord Message", "Mr. Sharma: 'The plumber will arrive tomorrow at 10 AM.'", Colors.blue)]));
  }
  Widget _notiCard(IconData icon, String title, String sub, Color c) => Card(margin: const EdgeInsets.only(bottom: 15), child: ListTile(leading: CircleAvatar(backgroundColor: c.withOpacity(0.2), child: Icon(icon, color: c)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(sub)));
}

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});
  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}
class _LanguageScreenState extends State<LanguageScreen> {
  String _selected = "English";
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Language", style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, iconTheme: const IconThemeData(color: Colors.black)), body: ListView(children: ["English", "हिंदी (Hindi)", "Español", "मराठी (Marathi)"].map((lang) => RadioListTile(title: Text(lang, style: GoogleFonts.poppins(fontSize: 18)), value: lang, groupValue: _selected, activeColor: Colors.teal, onChanged: (val) => setState(() => _selected = val.toString()))).toList()));
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Profile", style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, iconTheme: const IconThemeData(color: Colors.black)), body: ListView(padding: const EdgeInsets.all(20), children: [const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)), const SizedBox(height: 20), TextField(decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder()), controller: TextEditingController(text: "Rahul Sharma")), const SizedBox(height: 15), TextField(decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()), controller: TextEditingController(text: "rahul@example.com")), const SizedBox(height: 15), TextField(decoration: const InputDecoration(labelText: "Phone", border: OutlineInputBorder()), controller: TextEditingController(text: "+91 9876543210"))]));
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}
class _SettingsScreenState extends State<SettingsScreen> {
  bool noti = true; bool priv = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text("Settings", style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, iconTheme: const IconThemeData(color: Colors.black)), body: ListView(children: [SwitchListTile(title: const Text("Push Notifications"), value: noti, onChanged: (v) => setState(() => noti = v)), SwitchListTile(title: const Text("Private Profile"), value: priv, onChanged: (v) => setState(() => priv = v)), const ListTile(title: Text("Privacy Policy"), trailing: Icon(Icons.arrow_forward_ios, size: 16)), const ListTile(title: Text("Terms of Service"), trailing: Icon(Icons.arrow_forward_ios, size: 16))]));
  }
}
