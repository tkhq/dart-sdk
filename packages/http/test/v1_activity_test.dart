import 'package:test/test.dart';
import 'package:turnkey_http/__generated__/models.dart';

// Minimal JSON that satisfies all required fields of v1Activity except result.
Map<String, dynamic> _baseActivity({Map<String, dynamic>? result}) => {
      'id': 'activity-123',
      'organizationId': 'org-456',
      'status': 'ACTIVITY_STATUS_CONSENSUS_NEEDED',
      'type': 'ACTIVITY_TYPE_CREATE_WALLET',
      'intent': <String, dynamic>{},
      'votes': <dynamic>[],
      'fingerprint': 'fp-abc',
      'canApprove': false,
      'canReject': false,
      'createdAt': {'seconds': '1000', 'nanos': '0'},
      'updatedAt': {'seconds': '1000', 'nanos': '0'},
      if (result != null) 'result': result,
    };

void main() {
  group('v1Activity.fromJson', () {
    test('parses with null result when status is CONSENSUS_NEEDED', () {
      final activity = v1Activity.fromJson(_baseActivity());
      expect(activity.id, 'activity-123');
      expect(
          activity.status, v1ActivityStatus.activity_status_consensus_needed);
      expect(activity.result, isNull);
    });

    test('parses with populated result when activity is completed', () {
      final activity = v1Activity.fromJson(_baseActivity(result: {}));
      expect(activity.id, 'activity-123');
      expect(activity.result, isNotNull);
      expect(activity.result, isA<v1Result>());
    });
  });
}
