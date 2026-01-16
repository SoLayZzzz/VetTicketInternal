import 'package:get/get.dart';
import 'package:vet_internal_ticket/view/report/presentation/controller/report_sale_controller.dart';

class ReportSaleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportSaleController>(() => ReportSaleController());
  }
}
