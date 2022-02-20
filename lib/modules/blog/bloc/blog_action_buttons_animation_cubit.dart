import 'package:flutter_bloc/flutter_bloc.dart';

class BlogActionButtonsAnimationCubit extends Cubit<int?> {
  BlogActionButtonsAnimationCubit() : super(null);

  Future<void> process(int id) async => emit(id);
}
