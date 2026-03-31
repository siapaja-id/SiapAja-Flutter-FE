import 'package:flutter/material.dart';

class NavItem {
  final IconData icon;
  final String label;
  final String route;
  final bool isPrimary;
  final VoidCallback? action;

  const NavItem({
    required this.icon,
    required this.label,
    required this.route,
    this.isPrimary = false,
    this.action,
  });
}
