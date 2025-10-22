import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:namadawallet/services/namada_sdk/seed_service.dart';
import 'package:namadawallet/ui/screens/seed/verify_seed_screen.dart';
import 'package:namadawallet/ui/screens/seed/widgets/copy_seed_button.dart';
import 'package:namadawallet/ui/screens/seed/widgets/security_notification_container.dart';
import 'package:namadawallet/ui/screens/seed/widgets/seed_words_container.dart';

class SeedWordsScreen extends StatefulWidget {
  const SeedWordsScreen({Key? key}) : super(key: key);

  @override
  _SeedWordsScreenState createState() => _SeedWordsScreenState();
}

class _SeedWordsScreenState extends State<SeedWordsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> _twelveSeedWords = [];
  List<String> _twentyFourSeedWords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    /// Initialize the TabController for two tabs.
    _tabController = TabController(length: 2, vsync: this);

    /// Generate seed phrases asynchronously.
    _generateSeedPhrases();
  }

  Future<void> _generateSeedPhrases() async {
    try {
      /// Call FFI functions (wrapped in WalletService) to generate seed phrases.
      /// These functions should return a string with space-delimited seed words.
      final String seed12 = await SeedService.generateSeedPhrase12();
      final String seed24 = await SeedService.generateSeedPhrase24();
      setState(() {
        _twelveSeedWords = seed12.split(' ');
        _twentyFourSeedWords = seed24.split(' ');
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error generating seed")));
    }
  }

  void _copySeedToClipboard() {
    /// determine which tab is active.
    final int currentIndex = _tabController.index;
    final List<String> seedWords = currentIndex == 0
        ? _twelveSeedWords
        : _twentyFourSeedWords;
    final String seed = seedWords.join(' ');
    Clipboard.setData(ClipboardData(text: seed));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Seed copied to clipboard")));
  }

  void _navigateToVerifySeed() {
    /// Based on the active tab, pick the corresponding seed.
    final int currentIndex = _tabController.index;
    final List<String> seedWords = currentIndex == 0
        ? _twelveSeedWords
        : _twentyFourSeedWords;

    /// Navigate and send the seedWords to VerifySeedScreen.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerifySeedScreen(seedWords: seedWords),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "New Seed Phrase: step 2 of 5",
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontFamily: 'SpaceGrotesk',
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white, // iOS-style back icon
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: const Color(0xFF1D1B20),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFFFFFF00),
            labelColor: const Color(0xFFFFFF00),
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: "12 words"),
              Tab(text: "24 words"),
            ],
          ),
        ),
        backgroundColor: const Color(0xFF1D1B20),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Show the 12 seed words.
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            top: 8,
                            bottom: 0,
                          ),
                          child: TappableSeedWordsWidget(
                            seedWords: _twelveSeedWords,
                          ),
                        ),
                        // Show the 24 seed words.
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            top: 8,
                            bottom: 0,
                          ),
                          child: TappableSeedWordsWidget(
                            seedWords: _twentyFourSeedWords,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CopySeedButton(onTap: _copySeedToClipboard),
                  const SecurityNotificationContainer(shouldDisplayIcon: false),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFFF00),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _navigateToVerifySeed,
                      child: Center(
                        child: Text(
                          "Next",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'SpaceGrotesk',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
      ),
    );
  }
}
