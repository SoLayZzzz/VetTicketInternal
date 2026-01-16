import 'package:vet_internal_ticket/view/ticket/data/model/request/destination_from_body.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/request/destination_to_body.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/destination_model.dart';
import 'package:vet_internal_ticket/view/ticket/data/network/ticket_network_datasource.dart';
import 'package:vet_internal_ticket/view/ticket/domain/repositories/ticket_reppo.dart';

class TicketRepoimpl implements TicketReppo {
  final TicketNetworkDatasource _networkDatasource;

  TicketRepoimpl(this._networkDatasource);

  @override
  Future<DestinationFromModel> getDestinationFrom(DestinationFromBody body) {
    return _networkDatasource.destiFrom(body);
  }

  @override
  Future<DestinationFromModel> getDestinationTo(DestinationToBody body) {
    return _networkDatasource.destiTo(body);
  }
}
