class AnalysisResult {
  AnalysisResult({
    required this.toxicityScore,
    required this.riskLevel,
    required this.sentiment,
    required this.emotionalShiftSummary,
    required this.topBehaviors,
    this.content,
    this.createdAt,
    this.id,
  });

  final int? id;
  final String? content;
  final DateTime? createdAt;
  final double toxicityScore;
  final String riskLevel;
  final String sentiment;
  final String emotionalShiftSummary;
  final List<BehaviorEvidence> topBehaviors;

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    final sentimentData = Map<String, dynamic>.from(json['sentiment'] as Map);
    return AnalysisResult(
      id: json['id'] as int?,
      content: json['content'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      toxicityScore: (json['toxicity_score'] as num).toDouble(),
      riskLevel: json['risk_level'] as String,
      sentiment: sentimentData['label'] as String,
      emotionalShiftSummary: json['emotional_shift_summary'] as String,
      topBehaviors: (json['top_behaviors'] as List)
          .map((item) => BehaviorEvidence.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
    );
  }
}

class BehaviorEvidence {
  BehaviorEvidence({
    required this.category,
    required this.severity,
    required this.evidence,
    required this.sentiment,
    required this.impactSummary,
  });

  final String category;
  final double severity;
  final String evidence;
  final String sentiment;
  final String impactSummary;

  factory BehaviorEvidence.fromJson(Map<String, dynamic> json) {
    return BehaviorEvidence(
      category: json['category'] as String,
      severity: (json['severity'] as num).toDouble(),
      evidence: json['evidence'] as String,
      sentiment: json['sentiment'] as String,
      impactSummary: json['impact_summary'] as String,
    );
  }
}
