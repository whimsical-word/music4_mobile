import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(icon: const Icon(Icons.logout, color: AppColors.error), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Stats Overview
          Row(
            children: [
              _StatCard(label: 'Tổng Users', value: '1,248', icon: Icons.people),
              const SizedBox(width: 12),
              _StatCard(label: 'Tổng Artists', value: '312', icon: Icons.mic),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatCard(label: 'Tổng Tracks', value: '4,512', icon: Icons.music_note),
              const SizedBox(width: 12),
              _StatCard(label: 'Lượt nghe hôm nay', value: '8,904', icon: Icons.bar_chart),
            ],
          ),
          const SizedBox(height: 24),
          // User management
          const Text('Quản lý người dùng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text('User #${index + 1}'),
                subtitle: const Text('user@example.com'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.block, color: AppColors.warning), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.delete, color: AppColors.error), onPressed: () {}),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
