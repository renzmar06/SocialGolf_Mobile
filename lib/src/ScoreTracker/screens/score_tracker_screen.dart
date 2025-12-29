import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../../core/common/widgets/custom_button.dart';
import '../../../core/utils/constants/colors.dart';
import '../bloc/score_tracker_bloc.dart';
import '../bloc/score_tracker_event.dart';
import '../bloc/score_tracker_state.dart';

class ScoreTrackerScreen extends StatelessWidget {
  const ScoreTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScoreTrackerBloc(),
      // The Builder provides a context BELOW the BlocProvider
      child: Builder(
          builder: (innerContext) {
            return Scaffold(
              backgroundColor: const Color(0xFFFBFBFB),
              appBar: AppBar(
                title: const Text('Score Tracker',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: false,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextButton(
                      // Pass innerContext so the dialog can find the Bloc
                      onPressed: () => _showAddScoreDialog(innerContext),
                      style: TextButton.styleFrom(
                        backgroundColor: ColorConstants.btnColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add, size: 18, color: Colors.white),
                          SizedBox(width: 5),
                          Text(
                            'Add Score',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              body: BlocBuilder<ScoreTrackerBloc, ScoreTrackerState>(
                builder: (context, state) {
                  if (state.rounds.isEmpty) return _buildEmptyState(innerContext);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stats Section - Uses Wrap to prevent overflow
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildStatBox(innerContext, 'Best Score', state.bestScore.toString(),
                                Icons.emoji_events_outlined, Colors.orange),
                            _buildStatBox(innerContext, 'Average', state.averageScore.toString(),
                                Icons.track_changes, Colors.green),
                            _buildStatBox(innerContext, 'Rounds', state.totalRounds.toString(),
                                Icons.outlined_flag, Colors.blue),
                            _buildStatBox(innerContext, 'Last Change',
                                state.rounds.length < 2 ? "—" : "+3", Icons.trending_up, Colors.red),
                          ],
                        ),

                        // Trend Graph - Shows if 2 or more rounds exist
                        if (state.rounds.length >= 2) ...[
                          const SizedBox(height: 24),
                          const Text('Score Trend',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          _buildTrendChart(state.rounds),
                        ],

                        const SizedBox(height: 24),
                        const Text('Recent Rounds',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.rounds.length,
                          itemBuilder: (context, index) => _buildRoundCard(state.rounds[index]),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
      ),
    );
  }

  // --- Helper Components ---

  Widget _buildStatBox(BuildContext context, String label, String value, IconData icon, Color color) {
    // Dynamic width to prevent overflow on any screen size
    final width = (MediaQuery.of(context).size.width - 44) / 2;
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis),
                Text(label,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChart(List<ScoreRound> rounds) {
    final sortedRounds = [...rounds]
      ..sort((a, b) {
        final dateA = DateFormat('MMM dd, yyyy').parse(a.date);
        final dateB = DateFormat('MMM dd, yyyy').parse(b.date);
        return dateA.compareTo(dateB); // oldest → latest
      });


    final minScore =
    rounds.map((e) => e.score).reduce((a, b) => a < b ? a : b);
    final maxScore =
    rounds.map((e) => e.score).reduce((a, b) => a > b ? a : b);

    return Container(
      height: 260,
      padding: const EdgeInsets.fromLTRB(12, 30, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: LineChart(
        LineChartData(
          minY: (minScore - 5).toDouble(),
          maxY: (maxScore + 5).toDouble(),

          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),

          // 👇 TOUCH + TOOLTIP
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            getTouchedSpotIndicator:
                (LineChartBarData barData, List<int> spotIndexes) {
              return spotIndexes.map((index) {
                return TouchedSpotIndicatorData(
                  FlLine(
                    color: Colors.grey.shade300,
                    strokeWidth: 1,
                  ),
                  FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, bar, index) =>
                        FlDotCirclePainter(
                          radius: 6,
                          color: const Color(0xFF0D5D33),
                          strokeWidth: 3,
                          strokeColor: Colors.white,
                        ),
                  ),
                );
              }).toList();
            },
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor:(LineBarSpot spot) {
                return Colors.white; // 👈 WHITE tooltip background
              },
             tooltipBorderRadius: BorderRadius.all(Radius.circular(14)),
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              tooltipMargin: 16,
              fitInsideHorizontally: true,
              fitInsideVertically: true,
                tooltipBorder: BorderSide(
                  color: Colors.black.withOpacity(0.08),
                  width: 1,
                ),
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  final index = spot.x.toInt();
                  final round = sortedRounds[index];

                  return LineTooltipItem(
                    '',
                    const TextStyle(),
                    children: [
                      TextSpan(
                        text: round.date.split(',')[0],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const TextSpan(text: '\n'),
                      TextSpan(
                        text: 'score : ${round.score}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF0D5D33),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
          ),

          // 👇 AXIS TITLES
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < sortedRounds.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        sortedRounds[index].date.split(',')[0],
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 6,
                reservedSize: 32,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
            topTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),

          // 👇 LINE
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              curveSmoothness: 0.3,
              barWidth: 3,
              color: const Color(0xFF0D5D33),

              spots: sortedRounds
                  .asMap()
                  .entries
                  .map((e) =>
                  FlSpot(e.key.toDouble(), e.value.score.toDouble()))
                  .toList(),

              dotData: const FlDotData(show: false),

              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0D5D33).withOpacity(0.18),
                    const Color(0xFF0D5D33).withOpacity(0.02),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildRoundCard(ScoreRound round) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(round.courseName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey.shade400),
                  const SizedBox(width: 6),
                  Text(round.date, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(round.score.toString(),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(round.toPar >= 0 ? '+${round.toPar}' : '${round.toPar}',
                  style: const TextStyle(
                      color: Colors.red, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
              radius: 40,
              backgroundColor: Colors.green.shade50,
              child: const Icon(Icons.emoji_events_outlined, size: 40, color: Colors.green)),
          const SizedBox(height: 20),
          const Text('No scores yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text('Start tracking your rounds!', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomButton(
                onPressed: () => _showAddScoreDialog(context),
              backgroundColor: ColorConstants.btnColor,
              btnText: 'Add Your First Score',
              maxWidth: 200,
            ),
          )
        ],
      ),
    );
  }

  void _showAddScoreDialog(BuildContext context) {
    final courseCtrl = TextEditingController();
    final scoreCtrl = TextEditingController();
    final parCtrl = TextEditingController();
    DateTime pickedDate = DateTime.now();

    final scoreBloc = BlocProvider.of<ScoreTrackerBloc>(context);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Colors.white, // Pure white background
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 8, 0),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'New Score Entry',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(ctx),
                icon: Icon(Icons.close, color: Colors.grey.shade400, size: 22),
              )
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dialogLabel("Golf Course"),
                TextField(
                  controller: courseCtrl,
                  style: const TextStyle(fontSize: 15),
                  decoration: _inputDeco('Enter course name'),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _dialogLabel("Score"),
                          TextField(
                            controller: scoreCtrl,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            decoration: _inputDeco('72'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _dialogLabel("Par"),
                          TextField(
                            controller: parCtrl,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            decoration: _inputDeco('72'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _dialogLabel("Date of Play"),
                InkWell(
                  onTap: () async {
                    final DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: pickedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      // Apply the custom theme here
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(0xFF0D5D33), // Header background & selected day color
                              onPrimary: Colors.white,    // Text color on top of primary
                              onSurface: Colors.black,    // Default text color
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF0D5D33), // Action button color (OK/Cancel)
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (date != null) {
                      setDialogState(() => pickedDate = date);
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMMM dd, yyyy').format(pickedDate),
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        const Icon(Icons.calendar_month_rounded, size: 20, color: Color(0xFF0D5D33))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          actions: [
            // --- Custom Professional Button ---
            GestureDetector(
              onTap: () {
                if (courseCtrl.text.isNotEmpty && scoreCtrl.text.isNotEmpty) {
                  final score = int.tryParse(scoreCtrl.text) ?? 0;
                  final par = int.tryParse(parCtrl.text) ?? 72;
                  scoreBloc.add(AddNewScore(ScoreRound(
                    courseName: courseCtrl.text,
                    score: score,
                    toPar: score - par,
                    date: DateFormat('MMM dd, yyyy').format(pickedDate),
                  )));
                  Navigator.pop(ctx);
                }
              },
              child: Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D5D33), Color(0xFF167E48)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D5D33).withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Save Round Score',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: Colors.grey
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
  );

  Widget _dialogLabel(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)));
}