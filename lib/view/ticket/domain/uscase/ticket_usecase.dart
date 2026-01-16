import 'package:vet_internal_ticket/view/ticket/data/model/request/destination_from_body.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/request/destination_to_body.dart';
import 'package:vet_internal_ticket/view/ticket/data/model/response/destination_model.dart';
import 'package:vet_internal_ticket/view/ticket/domain/repositories/ticket_reppo.dart';

class TicketUsecase {
  final TicketReppo ticketReppo;

  TicketUsecase(this.ticketReppo);

  Future<DestinationFromModel> executeDestinationFrom(
      DestinationFromBody body) async {
    return await ticketReppo.getDestinationFrom(body);
  }

  Future<DestinationFromModel> executeDestinationTo(
      DestinationToBody body) async {
    return await ticketReppo.getDestinationTo(body);
  }
}
