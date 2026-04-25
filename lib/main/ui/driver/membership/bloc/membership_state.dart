part of 'membership_bloc.dart';

enum MembershipStatus {
  initial,
  loading,
  success,
  registering,
  registered,
  failure
}

class MembershipState extends Equatable {
  const MembershipState({
    this.status = MembershipStatus.initial,
    this.packages = const [],
    this.selectedPackageId,
    this.errorMessage,
  });

  final MembershipStatus status;
  final List<Package> packages;
  final String? selectedPackageId;
  final String? errorMessage;

  Package? get selectedPackage {
    try {
      return packages.firstWhere((p) => p.id == selectedPackageId);
    } catch (_) {
      return null;
    }
  }

  MembershipState copyWith({
    MembershipStatus? status,
    List<Package>? packages,
    String? selectedPackageId,
    String? errorMessage,
  }) {
    return MembershipState(
      status: status ?? this.status,
      packages: packages ?? this.packages,
      selectedPackageId: selectedPackageId ?? this.selectedPackageId,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        packages,
        selectedPackageId,
        errorMessage,
      ];
}
