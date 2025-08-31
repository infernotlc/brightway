import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object?> get props => [];
}

class LanguageChanged extends LanguageEvent {
  final Locale locale;

  const LanguageChanged(this.locale);

  @override
  List<Object?> get props => [locale];
}

class LanguageLoadRequested extends LanguageEvent {}

// States
abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object?> get props => [];
}

class LanguageInitial extends LanguageState {}

class LanguageLoading extends LanguageState {}

class LanguageLoaded extends LanguageState {
  final Locale locale;

  const LanguageLoaded(this.locale);

  @override
  List<Object?> get props => [locale];
}

class LanguageError extends LanguageState {
  final String message;

  const LanguageError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageInitial()) {
    on<LanguageLoadRequested>(_onLanguageLoadRequested);
    on<LanguageChanged>(_onLanguageChanged);
  }

  Future<void> _onLanguageLoadRequested(
    LanguageLoadRequested event,
    Emitter<LanguageState> emit,
  ) async {
    emit(LanguageLoading());
    
    try {
      // TODO: Load saved language preference from shared preferences
      // For now, default to Turkish
      const defaultLocale = Locale('tr', 'TR');
      emit(LanguageLoaded(defaultLocale));
    } catch (e) {
      emit(LanguageError('Failed to load language: $e'));
    }
  }

  Future<void> _onLanguageChanged(
    LanguageChanged event,
    Emitter<LanguageState> emit,
  ) async {
    emit(LanguageLoading());
    
    try {
      // TODO: Save language preference to shared preferences
      emit(LanguageLoaded(event.locale));
    } catch (e) {
      emit(LanguageError('Failed to change language: $e'));
    }
  }

  Locale get currentLocale {
    if (state is LanguageLoaded) {
      return (state as LanguageLoaded).locale;
    }
    return const Locale('tr', 'TR'); // Default to Turkish
  }
}
