part of 'limited_offer_bloc.dart';

class LimitedOfferState extends Equatable {
  final int selectedPackageIndex;

  const LimitedOfferState({this.selectedPackageIndex = 1});

  LimitedOfferState copyWith({int? selectedPackageIndex}) {
    return LimitedOfferState(
      selectedPackageIndex: selectedPackageIndex ?? this.selectedPackageIndex,
    );
  }

  @override
  List<Object?> get props => [selectedPackageIndex];
}
