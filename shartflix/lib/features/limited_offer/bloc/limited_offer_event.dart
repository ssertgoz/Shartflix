part of 'limited_offer_bloc.dart';

abstract class LimitedOfferEvent extends Equatable {
  const LimitedOfferEvent();

  @override
  List<Object?> get props => [];
}

class PackageSelected extends LimitedOfferEvent {
  final int index;

  const PackageSelected(this.index);

  @override
  List<Object?> get props => [index];
}
