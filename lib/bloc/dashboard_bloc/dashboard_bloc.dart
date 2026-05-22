import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/dashboard_bloc/dashboard_state.dart';
import 'package:momaspayplus/domain/service/dashboard_service.dart';

import '../../core/storage/shared_pref.dart';
import 'dashboard_event.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardService service;

  DashboardBloc(this.service) : super(DashboardInitial()) {
    on<DashboardEvent>((event, emit) async {
      if (event is WalletDashboardEvent) {
        await _onWalletEvent(event, emit);
      } else if (event is FeatureDashboardEvent) {
        await _onFeatureEvent(event, emit);
      }
    });
  }

  Future<void> _onWalletEvent(
      DashboardEvent event, Emitter<DashboardState> emit) async {
    super.onEvent(event);
    try {
      if (event is WalletDashboardEvent) {
        emit(WalletLoading());
        var wallet = await service.getBalance();
        if (wallet.status == true) {
          emit(WalletSuccessful(wallet));
        } else {
          emit(WalletFailure());
        }
      }
    } catch (_, e) {
      emit(WalletFailure());
    }
  }

  Future<void> _onFeatureEvent(
      DashboardEvent event, Emitter<DashboardState> emit) async {
    if (event is FeatureDashboardEvent) {
      final cached = SharedPreferenceHelper.getCachedFeature();
      if (cached != null) {
        emit(FeaturesSuccessful(cached));
      } else {
        emit(FeaturesLoading());
      }

      try {
        final data = await service.getFeature();
        if (data.status == true) {
          await SharedPreferenceHelper.saveFeature(data.feature);
          emit(FeaturesSuccessful(data.feature));
        } else {
          if (cached == null) emit(FeaturesFailure());
        }
      } catch (e) {
        if (cached == null) emit(FeaturesFailure());
      }
    }
  }
}

class WalletBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardService service;

  WalletBloc(this.service) : super(DashboardInitial()) {
    on<WalletDashboardEvent>((event, emit) async {
      emit(WalletLoading());
      try {
        var wallet = await service.getBalance();
        if (wallet.status == true) {
          emit(WalletSuccessful(wallet));
        } else {
          emit(WalletFailure());
        }
      } catch (e) {
        emit(WalletFailure());
      }
    });
  }
}

class PromoBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardService service;

  PromoBloc(this.service) : super(DashboardInitial()) {
    on<PromotionEvent>((event, emit) async {
      final cached = SharedPreferenceHelper.getCachedPromo();
      if (cached != null) {
        emit(PromotionSuccessful(cached));
      } else {
        emit(FeaturesLoading());
      }

      try {
        final data = await service.getPromo();
        if (data.status == true) {
          await SharedPreferenceHelper.savePromo(data.promo);
          emit(PromotionSuccessful(data.promo));
        } else {
          if (cached == null) emit(PromotionFailure());
        }
      } catch (e) {
        if (cached == null) emit(PromotionFailure());
      }
    });
  }
}

class UserBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardService service;

  UserBloc(this.service) : super(DashboardInitial()) {
    on<GetUserDashboardEvent>((event, emit) async {
      final cached = await SharedPreferenceHelper.getUser();
      if (cached != null) {
        emit(GetUserSuccessful(cached));
      } else {
        emit(FeaturesLoading());
      }

      try {
        var data = await service.getUser();
        if (data.status == true && data.user != null) {
          SharedPreferenceHelper.saveUser(data.user!.toJson());
          emit(GetUserSuccessful(data.user!));
        } else {
          if (cached == null) emit(PromotionFailure());
        }
      } catch (e) {
        if (cached == null) emit(PromotionFailure());
      }
    });
  }
}
