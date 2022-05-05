// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:telepay_http/src/http_extensions.dart';
import 'package:telepay_http/telepay_http.dart';
import 'package:test/test.dart';

import '../fixtures/fixture_reader.dart';

class MockClient extends Mock implements Client {}

extension StringX on String {
  Uri get uri => Uri.parse('${TelePay.baseUrl}$this');
}

extension MapX on Map<String, dynamic> {
  List<int> get encode => utf8.encode(json.encode(this));
}

void main() {
  late MockClient client;
  late TelePayHttp telepay;

  setUp(() {
    client = MockClient();
    telepay = TelePayHttp(secretApiKey: 'secretApiKey', httpClient: client);
  });

  group('TelePayHttp', () {
    group('getMe', () {
      final merchantResponse =
          jsonDecode(fixture('merchant.json')) as Map<String, dynamic>;
      final merchantJson = merchantResponse['merchant'] as Map<String, dynamic>;

      test('should return [Merchant] when the statusCode is equeal to 200',
          () async {
        when(
          () => client.get(
            'getMe'.uri,
            headers: any<Map<String, String>>(named: 'headers'),
          ),
        ).thenAnswer(
          (_) async => Response.bytes(
            merchantResponse.encode,
            200,
          ),
        );

        expect(await telepay.getMe(), Merchant.fromJson(merchantJson));

        verify(
          () => client.get(
            'getMe'.uri,
            headers: any<Map<String, String>>(named: 'headers'),
          ),
        ).called(1);
      });

      // TODO(luisciber): Check this test
      // test('should throw [UnauthorizedException] when the statusCode is 403',
      //     () async {
      //   when(
      //     () => client.get(
      //       'getMe',
      //       headers: any<Map<String, String>>(named: 'headers'),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: 'getMe'),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: 'getMe'),
      //         statusCode: 403,
      //         body: <String, dynamic>{'detail': 'Invalid secret key'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.getMe(),
      //     throwsA(
      //       isA<UnauthorizedException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Invalid secret key',
      //       ),
      //     ),
      //   );
      // });

      // TODO(luisciber): check this test
      // test('should throw [TelePayException] when the statusCode is 500',
      //     () async {
      //   when(
      //     () => client.get(
      //       'getMe',
      //       headers: any<Map<String, String>>(named: 'headers'),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: 'getMe'),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: 'getMe'),
      //         statusCode: 500,
      //         body: <String, dynamic>{'detail': 'Internal server error'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.getMe(),
      //     throwsA(
      //       isA<TelePayException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Failed to get Me: \n'
      //             'STATUS_CODE: 500 \n'
      //             'RESPONSE: {detail: Internal server error}',
      //       ),
      //     ),
      //   );
      // });
    });
    group('getBalance', () {
      final balanceResponse =
          jsonDecode(fixture('wallets.json')) as Map<String, dynamic>;
      final balanceJson = (balanceResponse['wallets'] as List<dynamic>)
          .cast<Map<String, dynamic>>();

      test('should return [Walllet] list when the statusCode is equeal to 200',
          () async {
        when(
          () => client.get(
            'getBalance'.uri,
            headers: any<Map<String, String>>(named: 'headers'),
          ),
        ).thenAnswer(
          (_) async => TelepayResponse(
            statusCode: 200,
            data: balanceResponse,
          ),
        );

        final balance = await telepay.getBalance();

        expect(
          balance,
          balanceJson.map(Wallet.fromJson).toList(),
        );
        
        verify(
          () => client.get(
            'getBalance'.uri,
            headers: any<Map<String, String>>(named: 'headers'),
          ),
        ).called(1);
      });

      // TODO(luisciber): check this test
      // test('should throw [UnauthorizedException] when the statusCode is 403',
      //     () async {
      //   when(
      //     () => client.get(
      //       'getBalance',
      //       headers: any<Map<String, String>>(named: 'headers'),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: 'getBalance'),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: 'getBalance'),
      //         statusCode: 403,
      //         body: <String, dynamic>{'detail': 'Invalid secret key'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.getBalance(),
      //     throwsA(
      //       isA<UnauthorizedException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Invalid secret key',
      //       ),
      //     ),
      //   );
      // });

      // TODO(luisciber): check this test
      // test(
      //     'should throw [TelePayException] when the statusCode is '
      //     'diferent the 403', () async {
      //   when(
      //     () => client.get(
      //       'getBalance',
      //       headers: any<Map<String, String>>(named: 'headers'),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: 'getBalance'),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: 'getBalance'),
      //         statusCode: 500,
      //         body: <String, dynamic>{'detail': 'Internal server error'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.getBalance(),
      //     throwsA(
      //       isA<TelePayException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Failed to get balance: \n'
      //             'STATUS_CODE: 500 \n'
      //             'RESPONSE: {detail: Internal server error}',
      //       ),
      //     ),
      //   );
      // });
    });

    group('getInvoices', () {
      final invoicesResponse =
          jsonDecode(fixture('invoices.json')) as Map<String, dynamic>;
      final invoicesJson = (invoicesResponse['invoices'] as List<dynamic>)
          .cast<Map<String, dynamic>>();

      test('should return [Invoice] list when the statusCode is equeal to 200',
          () async {
        when(
          () => client.get(
            'getInvoices'.uri,
            headers: any<Map<String, String>>(named: 'headers'),
          ),
        ).thenAnswer(
          (_) async => TelepayResponse(
            statusCode: 200,
            data: invoicesResponse,
          ),
        );

        final invoices = await telepay.getInvoices();

        expect(
          invoices,
          invoicesJson.map(Invoice.fromJson).toList(),
        );

        verify(
          () => client.get(
            'getInvoices'.uri,
            headers: any<Map<String, String>>(named: 'headers'),
          ),
        ).called(1);
      });

      // TODO(luisciber): check this test
      // test('should throw [UnauthorizedException] when the statusCode is 403',
      //     () async {
      //   when(
      //     () => client.get(
      //       'getInvoices',
      //       headers: any<Map<String, String>>(named: 'headers'),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: 'getInvoices'),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: 'getInvoices'),
      //         statusCode: 403,
      //         body: <String, dynamic>{'detail': 'Invalid secret key'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.getInvoices(),
      //     throwsA(
      //       isA<UnauthorizedException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Invalid secret key',
      //       ),
      //     ),
      //   );
      // });

      // TODO(luisciber): check this test
      // test(
      //     'should throw [TelePayException] when the statusCode '
      //     'is diferent the 403', () async {
      //   when(
      //     () => client.get(
      //       'getInvoices',
      //       headers: any<Map<String, String>>(named: 'headers'),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: 'getInvoices'),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: 'getInvoices'),
      //         statusCode: 500,
      //         body: <String, dynamic>{'detail': 'Internal server error'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.getInvoices(),
      //     throwsA(
      //       isA<TelePayException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Failed to get invoices: \n'
      //             'STATUS_CODE: 500 \n'
      //             'RESPONSE: {detail: Internal server error}',
      //       ),
      //     ),
      //   );
      // });
    });

    group('getInvoice', () {
      final invoices =
          jsonDecode(fixture('invoices.json')) as Map<String, dynamic>;
      final invoiceResponse = (invoices['invoices'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .first;

      const invoiceNumber = 'PUEOS5RFQY';
      const getInvoicePath = 'getInvoice/$invoiceNumber';

      test('should return [Invoice] list when the statusCode is equeal to 200',
          () async {
        when(
          () => client.get(
            getInvoicePath.uri,
            headers: any<Map<String, String>>(named: 'headers'),
          ),
        ).thenAnswer(
          (_) async => TelepayResponse(
            statusCode: 200,
            data: invoiceResponse,
          ),
        );

        final invoice = await telepay.getInvoice(invoiceNumber);

        expect(
          invoice,
          Invoice.fromJson(invoiceResponse),
        );
        verify(
          () => client.get(
            getInvoicePath.uri,
            headers: any<Map<String, String>>(named: 'headers'),
          ),
        ).called(1);
      });

      // TODO(luisciber): check this test
      // test('should throw [UnauthorizedException] when the statusCode is 403',
      //     () async {
      //   when(
      //     () => client.get(
      //       getInvoicePath,
      //       headers: any<Map<String, String>>(named: 'headers'),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: getInvoicePath),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: getInvoicePath),
      //         statusCode: 403,
      //         body: <String, dynamic>{'detail': 'Invalid secret key'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.getInvoice(invoiceNumber),
      //     throwsA(
      //       isA<UnauthorizedException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Invalid secret key',
      //       ),
      //     ),
      //   );
      // });

      // TODO(luisciber): check this test
      // test(
      //     'should throw [TelePayException] when the statusCode '
      //     'is diferent the 403', () async {
      //   when(
      //     () => client.get(
      //       getInvoicePath,
      //       headers: any<Map<String, String>>(named: 'headers'),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: getInvoicePath),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: getInvoicePath),
      //         statusCode: 500,
      //         body: <String, dynamic>{'detail': 'Internal server error'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.getInvoice(invoiceNumber),
      //     throwsA(
      //       isA<TelePayException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Failed to get invoice: \n'
      //             'STATUS_CODE: 500 \n'
      //             'RESPONSE: {detail: Internal server error}',
      //       ),
      //     ),
      //   );
      // });
    });

    group('getAssets', () {
      final assetsResponse =
          jsonDecode(fixture('assets.json')) as Map<String, dynamic>;
      final assetsJson = (assetsResponse['assets'] as List<dynamic>)
          .cast<Map<String, dynamic>>();

      test('should return [Asset] list when the statusCode is equeal to 200',
          () async {
        when(
          () => client.get(
            'getAssets'.uri,
            headers: any<Map<String, String>>(named: 'headers'),
          ),
        ).thenAnswer(
          (_) async => TelepayResponse(
            statusCode: 200,
            data: assetsResponse,
          ),
        );

        final balance = await telepay.getAssets();

        expect(
          balance,
          assetsJson.map(Asset.fromJson).toList(),
        );
        verify(
          () => client.get(
            'getAssets'.uri,
            headers: any<Map<String, String>>(named: 'headers'),
          ),
        ).called(1);
      });

      // TODO(luisciber): check this test
      // test('should throw [UnauthorizedException] when the statusCode is 403',
      //     () async {
      //   when(
      //     () => client.get(
      //       'getAssets',
      //       headers: any<Map<String, String>>(named: 'headers'),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: 'getAssets'),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: 'getAssets'),
      //         statusCode: 403,
      //         body: <String, dynamic>{'detail': 'Invalid secret key'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.getAssets(),
      //     throwsA(
      //       isA<UnauthorizedException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Invalid secret key',
      //       ),
      //     ),
      //   );
      // });

      // TODO(luisciber): check this test
      // test(
      //     'should throw [TelePayException] when the statusCode '
      //     'is diferent the 403', () async {
      //   when(
      //     () => client.get(
      //       'getAssets',
      //       headers: any<Map<String, String>>(named: 'headers'),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: 'getAssets'),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: 'getAssets'),
      //         statusCode: 500,
      //         body: <String, dynamic>{'detail': 'Internal server error'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.getAssets(),
      //     throwsA(
      //       isA<TelePayException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Failed to get assets: \n'
      //             'STATUS_CODE: 500 \n'
      //             'RESPONSE: {detail: Internal server error}',
      //       ),
      //     ),
      //   );
      // });
    });

    group('createInvoice', () {
      final invoices =
          jsonDecode(fixture('invoices.json')) as Map<String, dynamic>;
      final invoiceResponse = (invoices['invoices'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .first;

      final createInvoiceJson =
          jsonDecode(fixture('create_invoice.json')) as Map<String, dynamic>;
      final createInvoiceModel = CreateInvoice.fromJson(createInvoiceJson);

      test('should return a [Invoice] when was created successfully', () async {
        when(
          () => client.telepayPost(
            'createInvoice',
            body: createInvoiceModel.toJson(),
            headers: any<Map<String, String>>(named: 'headers'),
          ),
        ).thenAnswer(
          (_) async => TelepayResponse(
            statusCode: 201,
            data: invoiceResponse,
          ),
        );

        final invoice = await telepay.createInvoice(createInvoiceModel);

        expect(
          invoice,
          Invoice.fromJson(invoiceResponse),
        );
        verify(
          () => client.telepayPost(
            'createInvoice',
            body: createInvoiceModel.toJson(),
            headers: any<Map<String, String>>(named: 'headers'),
          ),
        ).called(1);
      });

      // TODO(luisciber): check this test
      // test('should throw [UnauthorizedException] when the statusCode is 403',
      //     () async {
      //   when(
      //     () => client.telepayPost(
      //       'createInvoice',
      //       headers: any<Map<String, String>>(named: 'headers'),
      //       body: createInvoiceModel.toJson(),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: 'createInvoice'),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: 'createInvoice'),
      //         statusCode: 403,
      //         body: <String, dynamic>{'detail': 'Invalid secret key'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.createInvoice(createInvoiceModel),
      //     throwsA(
      //       isA<UnauthorizedException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Invalid secret key',
      //       ),
      //     ),
      //   );
      // });

      // TODO(luisciber): check this test
      // test(
      //     'should throw [TelePayException] when the statusCode '
      //     'is diferent the 403', () async {
      //   when(
      //     () => client.telepayPost(
      //       'createInvoice',
      //       headers: any<Map<String, String>>(named: 'headers'),
      //       body: createInvoiceModel.toJson(),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: 'createInvoice'),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: 'createInvoice'),
      //         statusCode: 500,
      //         body: <String, dynamic>{'detail': 'Internal server error'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.createInvoice(createInvoiceModel),
      //     throwsA(
      //       isA<TelePayException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Failed to create invoice: \n'
      //             'STATUS_CODE: 500 \n'
      //             'RESPONSE: {detail: Internal server error}',
      //       ),
      //     ),
      //   );
      // });
    });

    group('cancelInvoice', () {
      final invoices =
          jsonDecode(fixture('invoices.json')) as Map<String, dynamic>;
      final invoiceResponse = (invoices['invoices'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .first;

      const invoiceNumber = 'PUEOS5RFQY';
      const cancelInvoicePath = 'cancelInvoice/$invoiceNumber';

      test('should return the [Invoice] that was canceled', () async {
        when(
          () => client.telepayPost(
            cancelInvoicePath,
            headers: any<Map<String, String>>(named: 'headers'),
          ),
        ).thenAnswer(
          (_) async => TelepayResponse(
            statusCode: 200,
            data: invoiceResponse,
          ),
        );

        final invoice = await telepay.cancelInvoice(invoiceNumber);

        expect(
          invoice,
          Invoice.fromJson(invoiceResponse),
        );
        verify(
          () => client.telepayPost(
            cancelInvoicePath,
            headers: any<Map<String, String>>(named: 'headers'),
          ),
        ).called(1);
      });

      // TODO(luisciber): check this test
      // test('should throw [UnauthorizedException] when the statusCode is 403',
      //     () async {
      //   when(
      //     () => client.telepayPost(
      //       cancelInvoicePath,
      //       headers: any<Map<String, String>>(named: 'headers'),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: cancelInvoicePath),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: cancelInvoicePath),
      //         statusCode: 403,
      //         body: <String, dynamic>{'detail': 'Invalid secret key'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.cancelInvoice(invoiceNumber),
      //     throwsA(
      //       isA<UnauthorizedException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Invalid secret key',
      //       ),
      //     ),
      //   );
      // });

      // TODO(luisciber): check this test
      // test(
      //     'should throw [TelePayException] when the statusCode '
      //     'is diferent the 403', () async {
      //   when(
      //     () => client.telepayPost(
      //       cancelInvoicePath,
      //       headers: any<Map<String, String>>(named: 'headers'),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: cancelInvoicePath),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: cancelInvoicePath),
      //         statusCode: 500,
      //         body: <String, dynamic>{'detail': 'Internal server error'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.cancelInvoice(invoiceNumber),
      //     throwsA(
      //       isA<TelePayException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Failed to cancel invoice: \n'
      //             'STATUS_CODE: 500 \n'
      //             'RESPONSE: {detail: Internal server error}',
      //       ),
      //     ),
      //   );
      // });
    });

    group('deleteInvoice', () {
      final deleteResponse = <String, dynamic>{'status': 'deleted'};

      const invoiceNumber = 'PUEOS5RFQY';
      const deleteInvoicePath = 'deleteInvoice/$invoiceNumber';

      test('should return `true` when the invoice was delete', () async {
        when(
          () => client.telepayPost(
            deleteInvoicePath,
            headers: any<Map<String, String>>(named: 'headers'),
          ),
        ).thenAnswer(
          (_) async => TelepayResponse(
            statusCode: 200,
            data: deleteResponse,
          ),
        );

        expect(await telepay.deleteInvoice(invoiceNumber), isTrue);

        verify(
          () => client.telepayPost(
            deleteInvoicePath,
            headers: any<Map<String, String>>(named: 'headers'),
          ),
        ).called(1);
      });

      // TODO(luisciber): check this test
      // test(
      //     'should throw [UnauthorizedException] when the secret key is invalid',
      //     () async {
      //   when(
      //     () => client.telepayPost(
      //       deleteInvoicePath,
      //       headers: any<Map<String, String>>(named: 'headers'),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: deleteInvoicePath),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: deleteInvoicePath),
      //         statusCode: 403,
      //         body: <String, dynamic>{'detail': 'Invalid secret key'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.deleteInvoice(invoiceNumber),
      //     throwsA(
      //       isA<UnauthorizedException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Invalid secret key',
      //       ),
      //     ),
      //   );
      // });

      // TODO(luisciber): check this test
      // test(
      //     'should throw [NotFoundException] when not found '
      //     'the invoice to delete', () async {
      //   when(
      //     () => client.telepayPost(
      //       deleteInvoicePath,
      //       headers: any<Map<String, String>>(named: 'headers'),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: deleteInvoicePath),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: deleteInvoicePath),
      //         statusCode: 404,
      //         body: <String, dynamic>{
      //           'error': 'not-found',
      //           'message': 'Invoice with number $invoiceNumber does not exist',
      //         },
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.deleteInvoice(invoiceNumber),
      //     throwsA(
      //       isA<NotFoundException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Invoice with number $invoiceNumber does not exist',
      //       ),
      //     ),
      //   );
      // });

      // TODO(luisciber): check this test
      // test(
      //     'should throw [TelePayException] when the statusCode '
      //     'is diferent the 403', () async {
      //   when(
      //     () => client.telepayPost(
      //       deleteInvoicePath,
      //       headers: any<Map<String, String>>(named: 'headers'),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: deleteInvoicePath),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: deleteInvoicePath),
      //         statusCode: 500,
      //         body: <String, dynamic>{'detail': 'Internal server error'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.deleteInvoice(invoiceNumber),
      //     throwsA(
      //       isA<TelePayException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Failed to delete invoice: \n'
      //             'STATUS_CODE: 500 \n'
      //             'RESPONSE: {detail: Internal server error}',
      //       ),
      //     ),
      //   );
      // });
    });

    group('transfer', () {
      final tranferResponse = <String, dynamic>{'success': true};
      final tranferJson =
          jsonDecode(fixture('create_transfer.json')) as Map<String, dynamic>;
      final transferModel = CreateTransfer.fromJson(tranferJson);

      test('should return `true` when the transfer was create', () async {
        when(
          () => client.telepayPost(
            'transfer',
            headers: any<Map<String, String>>(named: 'headers'),
            body: transferModel.toJson(),
          ),
        ).thenAnswer(
          (_) async => TelepayResponse(
            statusCode: 200,
            data: tranferResponse,
          ),
        );

        expect(await telepay.transfer(transferModel), isTrue);

        verify(
          () => client.telepayPost(
            'transfer',
            headers: any<Map<String, String>>(named: 'headers'),
            body: transferModel.toJson(),
          ),
        ).called(1);
      });

      // TODO(luisciber): check this test
      // test(
      //     'should throw [UnauthorizedException] when the secret key is invalid',
      //     () async {
      //   when(
      //     () => client.telepayPost(
      //       'transfer',
      //       headers: any<Map<String, String>>(named: 'headers'),
      //       body: transferModel.toJson(),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: 'transfer'),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: 'transfer'),
      //         statusCode: 403,
      //         body: <String, dynamic>{'detail': 'Invalid secret key'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.transfer(transferModel),
      //     throwsA(
      //       isA<UnauthorizedException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Invalid secret key',
      //       ),
      //     ),
      //   );
      // });

      // TODO(luisciber): check this test
      // test(
      //     'should throw [NotFoundException] when merchant or user '
      //     'does not exist', () async {
      //   when(
      //     () => client.telepayPost(
      //       'transfer',
      //       headers: any<Map<String, String>>(named: 'headers'),
      //       body: transferModel.toJson(),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: 'transfer'),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: 'transfer'),
      //         statusCode: 401,
      //         body: <String, dynamic>{
      //           'error': 'not-found',
      //           'message':
      //               'User or merchant with username ${transferModel.username} '
      //                   'does not exist'
      //         },
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.transfer(transferModel),
      //     throwsA(
      //       isA<NotFoundException>().having(
      //         (e) => e.message,
      //         'message',
      //         'User or merchant with username ${transferModel.username} '
      //             'does not exist',
      //       ),
      //     ),
      //   );
      // });

      // TODO(luisciber): check this test
      // test('should throw [TelePayException] when occurre generic error',
      //     () async {
      //   when(
      //     () => client.telepayPost(
      //       'transfer',
      //       headers: any<Map<String, String>>(named: 'headers'),
      //       body: transferModel.toJson(),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: 'transfer'),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: 'transfer'),
      //         statusCode: 500,
      //         body: <String, dynamic>{'detail': 'Internal server error'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.transfer(transferModel),
      //     throwsA(
      //       isA<TelePayException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Failed to transfer: \n'
      //             'STATUS_CODE: 500 \n'
      //             'RESPONSE: {detail: Internal server error}',
      //       ),
      //     ),
      //   );
      // });
    });

    group('getWithdrawMinimum', () {
      final tranferResponse = <String, dynamic>{'withdraw_minimum': 0.2};

      final getWithdrawMinimumData = <String, String>{
        'asset': 'TON',
        'blockchain': 'TON',
        'network': 'mainnet'
      };

      test('should return `double` when the statusCode is equeal to 200',
          () async {
        when(
          () => client.telepayPost(
            'getWithdrawMinimum',
            headers: any<Map<String, String>>(named: 'headers'),
            body: getWithdrawMinimumData,
          ),
        ).thenAnswer(
          (_) async => TelepayResponse(
            statusCode: 200,
            data: tranferResponse,
          ),
        );

        final result = await telepay.getWithdrawMinimum(
          getWithdrawMinimumData['asset']!,
          getWithdrawMinimumData['blockchain']!,
          getWithdrawMinimumData['network'],
        );

        expect(result, equals(0.2));

        verify(
          () => client.telepayPost(
            'getWithdrawMinimum',
            headers: any<Map<String, String>>(named: 'headers'),
            body: getWithdrawMinimumData,
          ),
        ).called(1);
      });

      // TODO(luisciber): check this test
      // test('should throw [UnauthorizedException] when the statusCode is 403',
      //     () async {
      //   when(
      //     () => client.telepayPost(
      //       'getWithdrawMinimum',
      //       headers: any<Map<String, String>>(named: 'headers'),
      //       body: getWithdrawMinimumData,
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: 'getWithdrawMinimum'),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: 'getWithdrawMinimum'),
      //         statusCode: 403,
      //         body: <String, dynamic>{'detail': 'Invalid secret key'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.getWithdrawMinimum(
      //       getWithdrawMinimumData['asset']!,
      //       getWithdrawMinimumData['blockchain']!,
      //       getWithdrawMinimumData['network'],
      //     ),
      //     throwsA(
      //       isA<UnauthorizedException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Invalid secret key',
      //       ),
      //     ),
      //   );
      // });

      // TODO(luisciber): check this test
      // test(
      //     'should throw [TelePayException] when the statusCode '
      //     'is diferent the 403', () async {
      //   when(
      //     () => client.telepayPost(
      //       'getWithdrawMinimum',
      //       headers: any<Map<String, String>>(named: 'headers'),
      //       body: getWithdrawMinimumData,
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: 'getWithdrawMinimum'),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: 'getWithdrawMinimum'),
      //         statusCode: 500,
      //         body: <String, dynamic>{'detail': 'Internal server error'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.getWithdrawMinimum(
      //       getWithdrawMinimumData['asset']!,
      //       getWithdrawMinimumData['blockchain']!,
      //       getWithdrawMinimumData['network'],
      //     ),
      //     throwsA(
      //       isA<TelePayException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Failed to get withdraw minimum: \n'
      //             'STATUS_CODE: 500 \n'
      //             'RESPONSE: {detail: Internal server error}',
      //       ),
      //     ),
      //   );
      // });

      // TODO(luisciber): check this test
      // test('should throw [NotFoundException] when the asset was not found',
      //     () async {
      //   when(
      //     () => client.telepayPost(
      //       'getWithdrawMinimum',
      //       headers: any<Map<String, String>>(named: 'headers'),
      //       body: getWithdrawMinimumData,
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: 'getWithdrawMinimum'),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: 'getWithdrawMinimum'),
      //         statusCode: 401,
      //         body: <String, dynamic>{'error': 'asset-not-found'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.getWithdrawMinimum(
      //       getWithdrawMinimumData['asset']!,
      //       getWithdrawMinimumData['blockchain']!,
      //       getWithdrawMinimumData['network'],
      //     ),
      //     throwsA(
      //       isA<NotFoundException>().having(
      //         (e) => e.message,
      //         'message',
      //         'asset-not-found',
      //       ),
      //     ),
      //   );
      // });
    });

    group('getWithdrawFee', () {
      final withdrawFeeResponse = <String, dynamic>{
        'blockchain_fee': 0.00168,
        'processing_fee': 0.05,
        'total': 0.05168
      };

      final createWitdrawJson = {
        'asset': 'TON',
        'blockchain': 'TON',
        'network': 'mainnet',
        'amount': 2.5,
        'to_address': 'EQAwEl_ExMqFJIjfitPRPTdV_B9KTgHG-YognX6iKRWHdpX1',
        'message': 'Pay for services'
      };

      final createWithdrawModel = CreateWithdraw.fromJson(createWitdrawJson);

      test('should return [Fee] when the statusCode is equeal to 200',
          () async {
        when(
          () => client.telepayPost(
            'getWithdrawFee',
            headers: any<Map<String, String>>(named: 'headers'),
            body: createWithdrawModel.toJson(),
          ),
        ).thenAnswer(
          (_) async => TelepayResponse(
            statusCode: 200,
            data: withdrawFeeResponse,
          ),
        );

        final result = await telepay.getWithdrawFee(createWithdrawModel);

        expect(result, equals(Fee.fromJson(withdrawFeeResponse)));

        verify(
          () => client.telepayPost(
            'getWithdrawFee',
            headers: any<Map<String, String>>(named: 'headers'),
            body: createWithdrawModel.toJson(),
          ),
        ).called(1);
      });

      // TODO(luisciber): check this test
      // test('should throw [UnauthorizedException] when the statusCode is 403',
      //     () async {
      //   when(
      //     () => client.telepayPost(
      //       'getWithdrawFee',
      //       headers: any<Map<String, String>>(named: 'headers'),
      //       body: createWithdrawModel.toJson(),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: 'getWithdrawFee'),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: 'getWithdrawFee'),
      //         statusCode: 403,
      //         body: <String, dynamic>{'detail': 'Invalid secret key'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.getWithdrawFee(createWithdrawModel),
      //     throwsA(
      //       isA<UnauthorizedException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Invalid secret key',
      //       ),
      //     ),
      //   );
      // });

      // TODO(luisciber): check this test
      // test(
      //     'should throw [TelePayException] when the statusCode '
      //     'is diferent the 403', () async {
      //   when(
      //     () => client.telepayPost(
      //       'getWithdrawFee',
      //       headers: any<Map<String, String>>(named: 'headers'),
      //       body: createWithdrawModel.toJson(),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: 'getWithdrawFee'),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: 'getWithdrawFee'),
      //         statusCode: 500,
      //         body: <String, dynamic>{'detail': 'Internal server error'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.getWithdrawFee(createWithdrawModel),
      //     throwsA(
      //       isA<TelePayException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Failed to get withdraw fee: \n'
      //             'STATUS_CODE: 500 \n'
      //             'RESPONSE: {detail: Internal server error}',
      //       ),
      //     ),
      //   );
      // });

      // TODO(luisciber): check this test
      // test('should throw [NotFoundException] when the asset was not found',
      //     () async {
      //   when(
      //     () => client.telepayPost(
      //       'getWithdrawFee',
      //       headers: any<Map<String, String>>(named: 'headers'),
      //       body: createWithdrawModel.toJson(),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: 'getWithdrawFee'),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: 'getWithdrawFee'),
      //         statusCode: 401,
      //         body: <String, dynamic>{'error': 'asset-not-found'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.getWithdrawFee(createWithdrawModel),
      //     throwsA(
      //       isA<NotFoundException>().having(
      //         (e) => e.message,
      //         'message',
      //         'asset-not-found',
      //       ),
      //     ),
      //   );
      // });
    });

    group('withdraw', () {
      final withdrawResponse = <String, dynamic>{'success': true};

      final createWitdrawJson = {
        'asset': 'TON',
        'blockchain': 'TON',
        'network': 'mainnet',
        'amount': 2.5,
        'to_address': 'EQAwEl_ExMqFJIjfitPRPTdV_B9KTgHG-YognX6iKRWHdpX1',
        'message': 'Pay for services'
      };

      final createWithdrawModel = CreateWithdraw.fromJson(createWitdrawJson);

      test('should return `true` when the withdraw was successful', () async {
        when(
          () => client.telepayPost(
            'withdraw',
            headers: any<Map<String, String>>(named: 'headers'),
            body: createWithdrawModel.toJson(),
          ),
        ).thenAnswer(
          (_) async => TelepayResponse(
            statusCode: 200,
            data: withdrawResponse,
          ),
        );

        final result = await telepay.withdraw(createWithdrawModel);

        expect(result, isTrue);

        verify(
          () => client.telepayPost(
            'withdraw',
            headers: any<Map<String, String>>(named: 'headers'),
            body: createWithdrawModel.toJson(),
          ),
        ).called(1);
      });

      // TODO(luisciber): check this test
      // test('should throw [UnauthorizedException] when the statusCode is 403',
      //     () async {
      //   when(
      //     () => client.telepayPost(
      //       'withdraw',
      //       headers: any<Map<String, String>>(named: 'headers'),
      //       body: createWithdrawModel.toJson(),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: 'withdraw'),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: 'withdraw'),
      //         statusCode: 403,
      //         body: <String, dynamic>{'detail': 'Invalid secret key'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.withdraw(createWithdrawModel),
      //     throwsA(
      //       isA<UnauthorizedException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Invalid secret key',
      //       ),
      //     ),
      //   );
      // });

      // TODO(luisciber): check this test
      // test(
      //     'should throw [TelePayException] when the statusCode '
      //     'is diferent the 403', () async {
      //   when(
      //     () => client.telepayPost(
      //       'withdraw',
      //       headers: any<Map<String, String>>(named: 'headers'),
      //       body: createWithdrawModel.toJson(),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: 'withdraw'),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: 'withdraw'),
      //         statusCode: 500,
      //         body: <String, dynamic>{'detail': 'Internal server error'},
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.withdraw(createWithdrawModel),
      //     throwsA(
      //       isA<TelePayException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Failed to withdraw: \n'
      //             'STATUS_CODE: 500 \n'
      //             'RESPONSE: {detail: Internal server error}',
      //       ),
      //     ),
      //   );
      // });

      // TODO(luisciber): check this test
      // test(
      //     'should throw [InsufficienttFondsException] when not '
      //     'have suficient founds', () async {
      //   when(
      //     () => client.telepayPost(
      //       'withdraw',
      //       headers: any<Map<String, String>>(named: 'headers'),
      //       body: createWithdrawModel.toJson(),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: 'withdraw'),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: 'withdraw'),
      //         statusCode: 401,
      //         body: <String, dynamic>{
      //           'error': 'insufficient-funds',
      //           'message': 'Insufficient funds to withdraw'
      //         },
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.withdraw(createWithdrawModel),
      //     throwsA(
      //       isA<InsufficienttFondsException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Insufficient funds to withdraw',
      //       ),
      //     ),
      //   );
      // });

      // TODO(luisciber): check this test
      // test('should throw [NotFoundException] when not found the asset',
      //     () async {
      //   when(
      //     () => client.telepayPost(
      //       'withdraw',
      //       headers: any<Map<String, String>>(named: 'headers'),
      //       body: createWithdrawModel.toJson(),
      //     ),
      //   ).thenThrow(
      //     DioError(
      //       requestheaders: RequestOptions(path: 'withdraw'),
      //       response: Response<Map<String, dynamic>>(
      //         requestheaders: RequestOptions(path: 'withdraw'),
      //         statusCode: 401,
      //         body: <String, dynamic>{
      //           'error': 'asset-not-found',
      //           'message': 'Asset not found'
      //         },
      //       ),
      //     ),
      //   );

      //   expect(
      //     () => telepay.withdraw(createWithdrawModel),
      //     throwsA(
      //       isA<NotFoundException>().having(
      //         (e) => e.message,
      //         'message',
      //         'Asset not found',
      //       ),
      //     ),
      //   );
      // });
    });
  });
}
