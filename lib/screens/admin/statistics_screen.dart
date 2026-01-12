import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/statistics_provider.dart';
import '../../widgets/common/loading_widget.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(libraryStatisticsProvider);
    final categoryStatsAsync = ref.watch(categoryStatisticsProvider);
    final monthlyStatsAsync = ref.watch(monthlyLoanStatisticsProvider);
    final topBooksAsync = ref.watch(topBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('İstatistikler'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(libraryStatisticsProvider);
          ref.invalidate(categoryStatisticsProvider);
          ref.invalidate(monthlyLoanStatisticsProvider);
          ref.invalidate(topBooksProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats Cards
              statsAsync.when(
                data: (stats) => _buildStatsGrid(context, stats),
                loading: () => const Center(child: LoadingWidget()),
                error: (e, _) => _buildErrorCard('İstatistikler yüklenemedi'),
              ),
              const SizedBox(height: 24),

              // Category Chart
              Text('Kategorilere Göre Kitaplar', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              categoryStatsAsync.when(
                data: (categories) => _buildCategoryChart(context, categories),
                loading: () => const SizedBox(height: 200, child: Center(child: LoadingWidget())),
                error: (e, _) => _buildErrorCard('Kategori verileri yüklenemedi'),
              ),
              const SizedBox(height: 24),

              // Monthly Trend Chart
              Text('Aylık Ödünç Trendi', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              monthlyStatsAsync.when(
                data: (monthly) => _buildMonthlyChart(context, monthly),
                loading: () => const SizedBox(height: 200, child: Center(child: LoadingWidget())),
                error: (e, _) => _buildErrorCard('Aylık veriler yüklenemedi'),
              ),
              const SizedBox(height: 24),

              // Top Books
              Text('En Popüler Kitaplar', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              topBooksAsync.when(
                data: (books) => _buildTopBooksList(context, books),
                loading: () => const Center(child: LoadingWidget()),
                error: (e, _) => _buildErrorCard('Popüler kitaplar yüklenemedi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildStatCard(context, 'Toplam Kitap', stats.totalBooks.toString(), Icons.book, AppColors.primary),
        _buildStatCard(context, 'Müsait Kitap', stats.availableBooks.toString(), Icons.check_circle, AppColors.success),
        _buildStatCard(context, 'Bekleyen Talep', stats.pendingLoans.toString(), Icons.pending, AppColors.warning),
        _buildStatCard(context, 'Gecikmiş', stats.lateLoans.toString(), Icons.warning, AppColors.error),
        _buildStatCard(context, 'Toplam Üye', stats.totalUsers.toString(), Icons.people, AppColors.info),
        _buildStatCard(context, 'Aktif Ödünç', stats.activeLoans.toString(), Icons.bookmark, AppColors.secondary),
        _buildStatCard(context, 'İade Edilen', stats.returnedLoans.toString(), Icons.assignment_return, AppColors.success),
        _buildStatCard(context, 'Kategori', stats.totalCategories.toString(), Icons.category, AppColors.primary),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.white70), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChart(BuildContext context, List categories) {
    if (categories.isEmpty) return _buildErrorCard('Kategori verisi yok');
    
    final colors = [AppColors.primary, AppColors.secondary, AppColors.success, AppColors.warning, AppColors.info, AppColors.error, AppColors.primaryLight];
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: categories.asMap().entries.map((entry) {
                final i = entry.key;
                final cat = entry.value;
                return PieChartSectionData(
                  value: cat.bookCount.toDouble(),
                  title: '${cat.bookCount}',
                  color: colors[i % colors.length],
                  radius: 60,
                  titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyChart(BuildContext context, List monthly) {
    if (monthly.isEmpty) return _buildErrorCard('Aylık veri yok');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: true, drawVerticalLine: false),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < monthly.length) {
                        return Text(monthly[index].monthName.substring(0, 3), style: const TextStyle(fontSize: 10));
                      }
                      return const Text('');
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: monthly.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.loanCount.toDouble())).toList(),
                  isCurved: true,
                  color: AppColors.primary,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(show: true, color: AppColors.primary.withOpacity(0.2)),
                ),
                LineChartBarData(
                  spots: monthly.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.returnCount.toDouble())).toList(),
                  isCurved: true,
                  color: AppColors.success,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(show: true, color: AppColors.success.withOpacity(0.2)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBooksList(BuildContext context, List books) {
    if (books.isEmpty) return _buildErrorCard('Henüz ödünç kaydı yok');

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: books.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final book = books[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: book.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: book.imageUrl!,
                      width: 40,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(width: 40, height: 60, color: AppColors.greyLight),
                      errorWidget: (_, __, ___) => Container(width: 40, height: 60, color: AppColors.greyLight, child: const Icon(Icons.book)),
                    )
                  : Container(width: 40, height: 60, color: AppColors.greyLight, child: const Icon(Icons.book)),
            ),
            title: Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(book.author, style: TextStyle(color: AppColors.textSecondary)),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
              child: Text('${book.loanCount}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(child: Text(message, style: TextStyle(color: AppColors.textSecondary))),
      ),
    );
  }
}
