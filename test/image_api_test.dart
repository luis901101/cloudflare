import 'package:cloudflare/cloudflare.dart';
import 'package:cloudflare/src/base_api/c_response.dart';
import 'package:test/test.dart';

import 'base_tests.dart';


void main() async {

  await init();

  group('Retrieve images use cases', () {

    late final CResponse<List<CloudflareImage>?> responseList;
    String? imageId;
    setUpAll(() async {
      responseList = await cloudflare.imageAPI.getAll(page: 1, size: 20);
      print(responseList);
    });

    test('Get image list', () async {
      expect(responseList.isSuccessful, true);
      expect(responseList.body, isNotNull);
      expect(responseList.body, isNotEmpty);
      imageId = responseList.body![0].id;
    });

    test('Get image byId', () async {
      if(imageId == null) {
        markTestSkipped('Get image byId skipped: No image available to get by Id');
        return;
      }
      final response = await cloudflare.imageAPI.get(id: imageId!);
      expect(response.isSuccessful, true);
      expect(response.body!.variants.isNotEmpty, isNotNull);
    });
  });

  // group('Create payment use cases', () {
  //   final payment = PaymentRequest(
  //     returnUrl: "http://url.to.return.after.payment.confirmation",
  //     cancelUrl: "http://url.to.return.after.payment.cancellation",
  //     merchantOpId: PaymentRequest.generateRandomMerchantOpId(),
  //     currency: "CUP",
  //     amount: PaymentAmount(
  //       total: 33,
  //       details: PaymentAmountDetails(
  //         shipping: 1,
  //         tax: 0,
  //         discount: 2,
  //         tip: 4,
  //       ),
  //     ),
  //     items: [
  //       PaymentItem(
  //         name: "Payment Item 1",
  //         description: "Some item description",
  //         quantity: 2,
  //         price: 15,
  //         tax: 0,
  //       )
  //     ],
  //     description: "This is an example payment description",
  //   );
  //
  //   test('Create payment', () async {
  //     final response = await cloudflare.imageAPI.createPayment(data: payment);
  //     expect(response.isSuccessful, true);
  //     expect(response.body, isNotNull);
  //     expect(response.body?.statusCode, StatusCode.pendiente);
  //   });
  //
  //   test('Create and complete payment', () async {
  //     var response = await cloudflare.imageAPI.createPayment(data: payment);
  //     expect(response.isSuccessful, true);
  //     expect(response.body, isNotNull);
  //     final createdPayment = response.body!;
  //     expect(createdPayment.transactionUUID, isNotNull);
  //     response = await cloudflare.imageAPI.completePayment(transactionUUID: createdPayment.transactionUUID!);
  //     expect(response.isSuccessful, false);
  //     expect(response.error, GenericMatcher(
  //       onMatches: (item, matchState) =>
  //         item is ErrorResponse && item.code == StatusCode.transaccionNoConfirmada ? true : false
  //     ));
  //   });
  //
  //   test('Create and cancel payment', () async {
  //     var response = await cloudflare.imageAPI.createPayment(data: payment);
  //     expect(response.isSuccessful, true);
  //     expect(response.body, isNotNull);
  //     final createdPayment = response.body!;
  //     expect(createdPayment.transactionUUID, isNotNull);
  //     response = await cloudflare.imageAPI.cancelPayment(transactionUUID: createdPayment.transactionUUID!);
  //     expect(response.isSuccessful, true);
  //     expect(response.body?.statusCode, StatusCode.fallida);
  //   });
  // });
  //
  // group('Refund payment use cases', () {
  //   String? fullRefundPaymentId, partialRefundPaymentId;
  //   String? refundId;
  //
  //   bool isResponseNoREDSAConnection(EResponse response) =>
  //     !response.isSuccessful &&
  //     response.error is ErrorResponse &&
  //     (response.error as ErrorResponse).code == StatusCode.noConexionREDSA;
  //
  //   setUp(() async {
  //     final responsePayments = await cloudflare.imageAPI.getPayments(pageIndex: 0, pageSize: 2, status: StatusCode.aceptada);
  //     if(responsePayments.body != null) {
  //       if(responsePayments.body!.isNotEmpty) {
  //         fullRefundPaymentId = responsePayments.body![0].transactionUUID;
  //       }
  //       if(responsePayments.body!.length > 1) {
  //         partialRefundPaymentId = responsePayments.body![1].transactionUUID;
  //       }
  //     }
  //
  //     final responseRefunds = await cloudflare.imageAPI.getRefunds(pageIndex: 0, pageSize: 1);
  //     if(responseRefunds.body != null) {
  //       if(responseRefunds.body!.isNotEmpty) {
  //         refundId = responseRefunds.body![0].transactionUUID;
  //       }
  //     }
  //   });
  //
  //   test('Get refunds list', () async {
  //     final response = await cloudflare.imageAPI.getRefunds(pageIndex: 0, pageSize: 5);
  //     expect(response.isSuccessful, true);
  //     expect(response.body, isNotNull);
  //   },);
  //
  //   test('Get refund byId', () async {
  //     if(refundId == null) {
  //       markTestSkipped('Get refund byId skipped: No refund available to get by Id');
  //       return;
  //     }
  //     final response = await cloudflare.imageAPI.getRefund(transactionUUID: refundId!);
  //     expect(response.isSuccessful, true);
  //     expect(response.body, isNotNull);
  //   },);
  //
  //   test('Full payment refund', () async {
  //     if(fullRefundPaymentId == null) {
  //       markTestSkipped('Full payment refund skipped: No payment completed available to fully refund');
  //       return;
  //     }
  //     final response = await cloudflare.imageAPI.refundPayment(transactionUUID: fullRefundPaymentId!);
  //     if (isResponseNoREDSAConnection(response)) {
  //       markTestSkipped('Full payment refund skipped: No REDSA connection');
  //       return;
  //     }
  //     expect(response.isSuccessful, true);
  //     expect(response.body, isNotNull);
  //     expect(response.body?.statusCode, StatusCode.devuelta);
  //   }, timeout: Timeout(Duration(seconds: 60)));
  //
  //   test('Partial payment refund', () async {
  //     if(partialRefundPaymentId == null) {
  //       markTestSkipped('Partial payment refund skipped: No payment completed available to partially refund');
  //       return;
  //     }
  //     final refund = Refund(
  //       amount: PaymentAmount(
  //         total: 1,
  //       ),
  //       description: 'This is a partial refund'
  //     );
  //     final response = await cloudflare.imageAPI.refundPayment(transactionUUID: partialRefundPaymentId!, data: refund);
  //     if (isResponseNoREDSAConnection(response)) {
  //       markTestSkipped('Partial payment refund skipped: No REDSA connection');
  //       return;
  //     }
  //     expect(response.isSuccessful, true);
  //     expect(response.body, isNotNull);
  //     expect(response.body?.statusCode, StatusCode.devuelta);
  //   }, timeout: Timeout(Duration(seconds: 60)));
  // });
}
