import 'package:flutter/material.dart';

/// Primary bottom navbar for main screens.
class PrimaryBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const PrimaryBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF49454F), width: 0.2)),
      ),
      child: BottomNavigationBar(
        backgroundColor: const Color(0xFF1D1B20),
        elevation: 16,
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(label: "Wallet", icon: Icon(Icons.wallet)),
          BottomNavigationBarItem(
            label: "Stake",
            icon: Icon(Icons.monetization_on),
          ),
          BottomNavigationBarItem(
            label: "Transfer",
            icon: Icon(Icons.compare_arrows),
          ),
          BottomNavigationBarItem(
            label: "Deposit",
            icon: Icon(Icons.deblur_rounded),
          ),
          BottomNavigationBarItem(
            label: "Account",
            icon: Icon(Icons.account_circle_rounded),
          ),
        ],
        onTap: onItemTapped,
        unselectedItemColor: Colors.grey,
        selectedItemColor: const Color(0xFFFFFF00),
      ),
    );
  }
}
