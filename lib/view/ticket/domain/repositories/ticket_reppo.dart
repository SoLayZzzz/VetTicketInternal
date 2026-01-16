import 'package:vet_internal_ticket/view/ticket/data/model/request/destination_from_body.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/request/destination_to_body.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/destination_model.dart';

abstract class TicketReppo {
  Future<DestinationFromModel> getDestinationFrom(DestinationFromBody body);
  Future<DestinationFromModel> getDestinationTo(DestinationToBody body);
}
