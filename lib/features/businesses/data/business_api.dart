import '../../../app/model/business.dart';

/// Maps between the app's domain enums and the backend enum strings.
///
/// Frontend historically used names like `crafts`/`shop`/`moneyIn`; the
/// backend uses `handicrafts`/`rural_retail`/`in`. The mapping is centralized
/// here so screens don't leak wire-format knowledge.
class BusinessApiMapper {
  static String segment(BusinessSegment s) => switch (s) {
        BusinessSegment.shg => 'shg',
        BusinessSegment.fpo => 'fpo',
        BusinessSegment.own => 'own',
      };

  static String sector(BusinessSector s) => switch (s) {
        BusinessSector.dairy => 'dairy',
        BusinessSector.poultry => 'poultry',
        BusinessSector.foodProcessing => 'food_processing',
        BusinessSector.crafts => 'handicrafts',
        BusinessSector.shop => 'rural_retail',
        BusinessSector.other => 'other',
      };

  static String tenure(BusinessTenure t) => switch (t) {
        BusinessTenure.underOneYear => 'under_1',
        BusinessTenure.oneToThreeYears => '1_to_3',
        BusinessTenure.threeToTenYears => '3_to_10',
        BusinessTenure.tenPlus => '10_plus',
      };

  static String basis(MoneyBasis b) => switch (b) {
        MoneyBasis.roughEstimate => 'rough',
        MoneyBasis.fromRecords => 'records',
      };
}

/// Backend representation of a Business, decoded from `/api/v1/businesses`.
class RemoteBusiness {
  const RemoteBusiness({
    required this.id,
    required this.name,
    required this.segment,
    required this.sector,
    required this.tenure,
    required this.staffCount,
    required this.isNewBusiness,
    required this.yearsInOperation,
  });

  final int id;
  final String name;
  final String segment;
  final String sector;
  final String tenure;
  final int staffCount;
  final bool isNewBusiness;
  final int yearsInOperation;

  factory RemoteBusiness.fromJson(Map<String, dynamic> json) {
    return RemoteBusiness(
      id: json['id'] as int,
      name: json['name'] as String,
      segment: json['segment'] as String,
      sector: json['sector'] as String,
      tenure: json['tenure'] as String,
      staffCount: json['staff_count'] as int,
      isNewBusiness: json['is_new_business'] as bool,
      yearsInOperation: json['years_in_operation'] as int,
    );
  }

  /// Build a partial [Business] for `AppSession` after `GET /businesses`.
  /// The monthly snapshot isn't returned by that endpoint, so we seed it
  /// with zeros — the ML score + monthly-in/out come from the insights
  /// endpoints instead, which are the real source of truth on Home.
  Business toDomain() {
    return Business(
      name: name,
      segment: _segmentFromWire(segment),
      sector: _sectorFromWire(sector),
      tenure: _tenureFromWire(tenure),
      staffCount: staffCount,
      monthly: const MonthlyMoney(
        moneyIn: 0, moneyOut: 0, loanEmi: 0, savings: 0,
        basis: MoneyBasis.roughEstimate,
      ),
    );
  }
}

BusinessSegment _segmentFromWire(String s) => switch (s) {
      'shg' => BusinessSegment.shg,
      'fpo' => BusinessSegment.fpo,
      _ => BusinessSegment.own,
    };

BusinessSector _sectorFromWire(String s) => switch (s) {
      'dairy' => BusinessSector.dairy,
      'poultry' => BusinessSector.poultry,
      'food_processing' => BusinessSector.foodProcessing,
      'handicrafts' => BusinessSector.crafts,
      'rural_retail' => BusinessSector.shop,
      _ => BusinessSector.other,
    };

BusinessTenure _tenureFromWire(String s) => switch (s) {
      'under_1' => BusinessTenure.underOneYear,
      '1_to_3' => BusinessTenure.oneToThreeYears,
      '3_to_10' => BusinessTenure.threeToTenYears,
      _ => BusinessTenure.tenPlus,
    };

Map<String, dynamic> businessCreateBody(Business b) => {
      'name': b.name,
      'segment': BusinessApiMapper.segment(b.segment),
      'sector': BusinessApiMapper.sector(b.sector),
      'tenure': BusinessApiMapper.tenure(b.tenure),
      'staff_count': b.staffCount,
      'is_new_business': b.tenure == BusinessTenure.underOneYear,
      'years_in_operation': switch (b.tenure) {
        BusinessTenure.underOneYear => 0,
        BusinessTenure.oneToThreeYears => 2,
        BusinessTenure.threeToTenYears => 5,
        BusinessTenure.tenPlus => 10,
      },
      'monthly': {
        'money_in': b.monthly.moneyIn,
        'money_out': b.monthly.moneyOut,
        'loan_emi': b.monthly.loanEmi,
        'savings': b.monthly.savings,
        'basis': BusinessApiMapper.basis(b.monthly.basis),
      },
    };
