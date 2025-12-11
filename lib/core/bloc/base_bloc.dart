import 'package:social_golf_app/core/bloc/base_bloc_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseBloc<Event, State> extends Bloc<Event, State>
    with BaseBlocMixin<State> {
  BaseBloc(super.initialState);
}
