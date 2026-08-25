part of 'personal_profile_cubit.dart';

class PersonalProfileState extends Equatable {
  final Async<ClientEntity> getDataState;
  final Async<void> updateDataState;

  const PersonalProfileState({required this.getDataState, required this.updateDataState});

  const PersonalProfileState.initial() : this(getDataState: const Async.initial(), updateDataState: const Async.initial());
  PersonalProfileState copyWith({final Async<ClientEntity>? getDataState, final Async<void>? updateDataState}) {
    return PersonalProfileState(getDataState: getDataState ?? this.getDataState, updateDataState: updateDataState ?? this.updateDataState);
  }

  @override
  List<Object?> get props => [getDataState, updateDataState];
}
