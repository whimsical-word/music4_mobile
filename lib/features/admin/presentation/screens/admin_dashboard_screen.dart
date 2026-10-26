import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/state/auth_state.dart';
import '../widgets/vector_sync_card.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isAdmin = authState is AuthAuthenticated && authState.user.isAdmin;

    if (!isAdmin) return _buildAccessDenied(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (isLoading) return _buildShimmer(constraints);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hệ thống gợi ý', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                const VectorSyncCard(),
                const SizedBox(height: 32),
                Text('Thống kê tổng quan', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatCard(context, 'Users', '1,204', Icons.people),
                    const SizedBox(width: 16),
                    _buildStatCard(context, 'Artists', '84', Icons.mic),
                  ],
                ),
                const SizedBox(height: 32),
                Text('Hoạt động gần đây', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                const Center(child: Text('Chưa có hoạt động nào (Empty State)')),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAccessDenied(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 64),
              const SizedBox(height: 16),
              Text(
                'Chỉ dành cho Quản trị viên',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'Trang này chỉ dành cho tài khoản ADMIN. Vui lòng đăng nhập bằng tài khoản quản trị để truy cập.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Quay lại'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 8),
              Text(title, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer(BoxConstraints constraints) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[800]!, highlightColor: Colors.grey[600]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 200, height: 24, color: Colors.white),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Container(height: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)))),
                const SizedBox(width: 16),
                Expanded(child: Container(height: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)))),
              ],
            ),
            const SizedBox(height: 32),
            Container(width: 150, height: 24, color: Colors.white),
            const SizedBox(height: 16),
            ...List.generate(3, (index) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(height: 72, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
            ))
          ],
        ),
      ),
    );
  }
}
