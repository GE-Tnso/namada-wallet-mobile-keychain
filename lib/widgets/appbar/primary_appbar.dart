import 'package:flutter/material.dart';

/// Primary appbar for screens
class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const PrimaryAppBar({
    Key? key,
    required this.title,
    this.leading,
    this.actions,
    this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      elevation: 0,
      backgroundColor: const Color(0xFF1D1B20),
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontFamily: 'SpaceGrotesk',
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

PreferredSizeWidget buildWalletAppBar(
  BuildContext context,
  String title,
  bool hasWallet,
) {
  return PrimaryAppBar(
    title: title,
    leading: hasWallet
        ? IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          )
        : null,
  );
}
