import 'package:vet_internal_ticket/core/base/state_controller.dart';
import 'package:vet_internal_ticket/view/home/presentaion/state/home_state.dart';

class HomeController extends StateController<HomeState> {
  @override
  HomeState onInitUiState() => HomeState();
}
