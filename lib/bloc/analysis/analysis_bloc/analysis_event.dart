import 'package:equatable/equatable.dart';

abstract class AnalysisEvent extends Equatable {
  const AnalysisEvent();
}

class GetAnalysis extends AnalysisEvent {
  @override
  List<Object?> get props => [];
}

