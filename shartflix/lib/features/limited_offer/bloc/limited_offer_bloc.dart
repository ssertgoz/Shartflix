import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'limited_offer_event.dart';
part 'limited_offer_state.dart';

class LimitedOfferBloc extends Bloc<LimitedOfferEvent, LimitedOfferState> {
  LimitedOfferBloc({int initialSelectedIndex = 1})
      : super(LimitedOfferState(selectedPackageIndex: initialSelectedIndex)) {
    on<PackageSelected>(_onPackageSelected);
  }

  void _onPackageSelected(
    PackageSelected event,
    Emitter<LimitedOfferState> emit,
  ) {
    emit(state.copyWith(selectedPackageIndex: event.index));
  }
}
