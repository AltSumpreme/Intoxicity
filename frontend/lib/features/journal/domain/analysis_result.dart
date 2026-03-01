class AnalysisResult {
  AnalysisResult({
    required this.toxicityScore,
    required this.riskLevel,
    required this.sentiment,
    required this.emotionalProfile,
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
  final Map<String, double> emotionalProfile;
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
      emotionalProfile: (json['emotional_profile'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, (value as num).toDouble())),
      topBehaviors: (json['top_behaviors'] as List)
          .map((item) => BehaviorEvidence.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
    );
  }
}

class BehaviorEvidence {
  BehaviorEvidence({
    required this.behavior,
    required this.severity,
    required this.sentence,
    required this.sentimentLabel,
  });

  final String behavior;
  final double severity;
  final String sentence;
  final String sentimentLabel;

  factory BehaviorEvidence.fromJson(Map<String, dynamic> json) {
    return BehaviorEvidence(
      behavior: json['behavior'] as String,
      severity: (json['severity'] as num).toDouble(),
      sentence: json['sentence'] as String,
      sentimentLabel: json['sentiment_label'] as String,
    );
  }
}
