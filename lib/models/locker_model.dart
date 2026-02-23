enum LockerSize { s, m, l }
enum CompartmentType { dropIn, package, cooled, clothes }
enum LockerStatus { available, occupied, myLocker, reserved }
enum AccessMethod { app, nfc, pin }

extension LockerSizeExt on LockerSize {
  String get label => ['S', 'M', 'L'][index];
  String get dimensions => ['300×200mm', '500×350mm', '900×550mm'][index];
  String get description => ['Small items', 'Standard parcels', 'Large packages'][index];
}

extension CompartmentTypeExt on CompartmentType {
  String get label => ['Drop-in', 'Package', 'Cooled', 'Clothes'][index];
  String get emoji => ['🎒', '📦', '🌡️', '🧥'][index];
  String get description => [
    'Quick daily storage',
    'Deliveries & parcels',
    '12°C – 16°C zone',
    'Garments on hangers',
  ][index];
}

class LockerCompartment {
  final String id;
  final String zone;
  final LockerSize size;
  final CompartmentType type;
  final LockerStatus status;
  final double? temperature;
  final int row;
  final int col;

  const LockerCompartment({
    required this.id,
    required this.zone,
    required this.size,
    required this.type,
    required this.status,
    this.temperature,
    required this.row,
    required this.col,
  });

  bool get isAvailable => status == LockerStatus.available;
  bool get isMyLocker => status == LockerStatus.myLocker;
  bool get isCooled => type == CompartmentType.cooled;
}

class AccessLog {
  final String id;
  final String lockerId;
  final AccessMethod method;
  final DateTime timestamp;
  final String description;
  final bool success;
  final int? tokenRevocationMs;

  const AccessLog({
    required this.id,
    required this.lockerId,
    required this.method,
    required this.timestamp,
    required this.description,
    this.success = true,
    this.tokenRevocationMs,
  });

  String get methodLabel => ['App', 'NFC', 'PIN'][method.index];
  String get methodEmoji => ['📱', '📡', '🔢'][method.index];
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String campus;
  final String membershipTier;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.campus,
    required this.membershipTier,
  });

  String get initials {
    final parts = name.split(' ');
    return parts.map((p) => p[0]).take(2).join().toUpperCase();
  }
}

class LockerStats {
  final double utilizationPct;
  final int totalLockers;
  final int availableLockers;
  final int avgRetrievalSeconds;
  final int activeSessions;
  final Map<AccessMethod, int> sessionsByMethod;
  final Map<LockerSize, double> utilizationBySize;

  const LockerStats({
    required this.utilizationPct,
    required this.totalLockers,
    required this.availableLockers,
    required this.avgRetrievalSeconds,
    required this.activeSessions,
    required this.sessionsByMethod,
    required this.utilizationBySize,
  });
}

// Sample data
class SampleData {
  static final user = UserProfile(
    id: 'usr_001',
    name: 'Ahmed M.',
    email: 'ahmed@campus.sa',
    campus: 'Campus Zone B',
    membershipTier: 'Pro Member',
  );

  static final List<LockerCompartment> compartments = [
    // Row 1 - Large
    LockerCompartment(id: 'B-07', zone: 'B', size: LockerSize.l, type: CompartmentType.package, status: LockerStatus.myLocker, row: 0, col: 0),
    // Row 2 - Medium x2
    LockerCompartment(id: 'B-08', zone: 'B', size: LockerSize.m, type: CompartmentType.dropIn, status: LockerStatus.occupied, row: 1, col: 0),
    LockerCompartment(id: 'B-09', zone: 'B', size: LockerSize.m, type: CompartmentType.package, status: LockerStatus.available, row: 1, col: 1),
    // Row 3 - Cooled
    LockerCompartment(id: 'C-01', zone: 'B', size: LockerSize.l, type: CompartmentType.cooled, status: LockerStatus.occupied, temperature: 14.0, row: 2, col: 0),
    // Row 4 - Small x3
    LockerCompartment(id: 'S-01', zone: 'B', size: LockerSize.s, type: CompartmentType.dropIn, status: LockerStatus.available, row: 3, col: 0),
    LockerCompartment(id: 'S-02', zone: 'B', size: LockerSize.s, type: CompartmentType.clothes, status: LockerStatus.occupied, row: 3, col: 1),
    LockerCompartment(id: 'S-03', zone: 'B', size: LockerSize.s, type: CompartmentType.dropIn, status: LockerStatus.available, row: 3, col: 2),
  ];

  static final myLocker = compartments.firstWhere((c) => c.isMyLocker);

  static final List<AccessLog> logs = [
    AccessLog(id: '1', lockerId: 'B-07', method: AccessMethod.app, timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 2)), description: 'Locker B-07 Unlocked · AES-256 token verified in 48ms'),
    AccessLog(id: '2', lockerId: 'B-07', method: AccessMethod.nfc, timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 24)), description: 'NFC Access · Challenge-response handshake · Offline mode'),
    AccessLog(id: '3', lockerId: 'C-01', method: AccessMethod.app, timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 46)), description: 'Temp Alert Cleared · HVAC restored to 14°C via Control Unit'),
    AccessLog(id: '4', lockerId: 'S-01', method: AccessMethod.pin, timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 21)), description: 'PIN Access · Fallback offline PIN · Token revoked in 2.1s', tokenRevocationMs: 2100),
    AccessLog(id: '5', lockerId: 'B-09', method: AccessMethod.app, timestamp: DateTime.now().subtract(const Duration(hours: 3, minutes: 5)), description: 'Locker B-09 Reserved · AI assigned in 142ms'),
    AccessLog(id: '6', lockerId: 'B-07', method: AccessMethod.nfc, timestamp: DateTime.now().subtract(const Duration(hours: 4, minutes: 33)), description: 'NFC Tap · Lock engaged · WebSocket sync confirmed'),
  ];

  static final stats = LockerStats(
    utilizationPct: 0.87,
    totalLockers: 186,
    availableLockers: 24,
    avgRetrievalSeconds: 18,
    activeSessions: 9,
    sessionsByMethod: {
      AccessMethod.nfc: 5,
      AccessMethod.app: 3,
      AccessMethod.pin: 1,
    },
    utilizationBySize: {
      LockerSize.s: 0.72,
      LockerSize.m: 0.91,
      LockerSize.l: 0.85,
    },
  );
}
