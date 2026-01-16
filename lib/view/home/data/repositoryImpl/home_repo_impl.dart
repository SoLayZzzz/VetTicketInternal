import 'package:vet_internal_ticket/view/home/data/nework/home_data_source.dart';
import 'package:vet_internal_ticket/view/home/domain/repositories/home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  HomeRepoImpl(this.homeDataSource);
  final HomeDataSource homeDataSource;
}
