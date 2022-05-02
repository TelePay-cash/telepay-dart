// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:telepay_dio/telepay_dio.dart';
import 'package:test/test.dart';

import '../fixtures/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late TelePayDio telepay;

  setUpAll(() {
    dio = MockDio();
    telepay = TelePayDio(secretApiKey: 'secretApiKey', dio: dio);

    registerFallbackValue(Options());
  });

  group('TelePayDio', () {
    group('getMe', () {
      final merchantResponse =
          jsonDecode(fixture('merchant.json')) as Map<String, dynamic>;
      final merchantJson = merchantResponse['merchant'] as Map<String, dynamic>;

      test('should return [Merchant] when the statusCode is equeal to 200',
          () async {
        when(
          () => dio.get<Map<String, dynamic>>(
            'getMe',
            options: any<Options>(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: 'getMe'),
            statusCode: 200,
            data: merchantResponse,
          ),
        );

        expect(await telepay.getMe(), Merchant.fromJson(merchantJson));
        verify(
          () => dio.get<Map<String, dynamic>>(
            'getMe',
            options: any<Options>(named: 'options'),
          ),
        ).called(1);
      });

      test('should throw [UnauthorizedException] when the statusCode is 403',
          () async {
        when(
          () => dio.get<Map<String, dynamic>>(
            'getMe',
            options: any<Options>(named: 'options'),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: 'getMe'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: 'getMe'),
              statusCode: 403,
              data: <String, dynamic>{'detail': 'Invalid secret key'},
            ),
          ),
        );

        expect(
          () => telepay.getMe(),
          throwsA(
            isA<UnauthorizedException>().having(
              (e) => e.message,
              'message',
              'Invalid secret key',
            ),
          ),
        );
      });

      test('should throw [TelePayException] when the statusCode is 500',
          () async {
        when(
          () => dio.get<Map<String, dynamic>>(
            'getMe',
            options: any<Options>(named: 'options'),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: 'getMe'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: 'getMe'),
              statusCode: 500,
              data: <String, dynamic>{'detail': 'Internal server error'},
            ),
          ),
        );

        expect(
          () => telepay.getMe(),
          throwsA(
            isA<TelePayException>().having(
              (e) => e.message,
              'message',
              'Failed to get Me: \n'
                  'STATUS_CODE: 500 \n'
                  'RESPONSE: {detail: Internal server error}',
            ),
          ),
        );
      });
    });
    group('getBalance', () {
      final balanceResponse =
          jsonDecode(fixture('wallets.json')) as Map<String, dynamic>;
      final balanceJson = (balanceResponse['wallets'] as List<dynamic>)
          .cast<Map<String, dynamic>>();

      test('should return [Walllet] list when the statusCode is equeal to 200',
          () async {
        when(
          () => dio.get<Map<String, dynamic>>(
            'getBalance',
            options: any<Options>(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: 'getBalance'),
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
          () => dio.get<Map<String, dynamic>>(
            'getBalance',
            options: any<Options>(named: 'options'),
          ),
        ).called(1);
      });

      test('should throw [UnauthorizedException] when the statusCode is 403',
          () async {
        when(
          () => dio.get<Map<String, dynamic>>(
            'getBalance',
            options: any<Options>(named: 'options'),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: 'getBalance'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: 'getBalance'),
              statusCode: 403,
              data: <String, dynamic>{'detail': 'Invalid secret key'},
            ),
          ),
        );

        expect(
          () => telepay.getBalance(),
          throwsA(
            isA<UnauthorizedException>().having(
              (e) => e.message,
              'message',
              'Invalid secret key',
            ),
          ),
        );
      });

      test(
          'should throw [TelePayException] when the statusCode is '
          'diferent the 403', () async {
        when(
          () => dio.get<Map<String, dynamic>>(
            'getBalance',
            options: any<Options>(named: 'options'),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: 'getBalance'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: 'getBalance'),
              statusCode: 500,
              data: <String, dynamic>{'detail': 'Internal server error'},
            ),
          ),
        );

        expect(
          () => telepay.getBalance(),
          throwsA(
            isA<TelePayException>().having(
              (e) => e.message,
              'message',
              'Failed to get balance: \n'
                  'STATUS_CODE: 500 \n'
                  'RESPONSE: {detail: Internal server error}',
            ),
          ),
        );
      });
    });

    group('getInvoices', () {
      final invoicesResponse =
          jsonDecode(fixture('invoices.json')) as Map<String, dynamic>;
      final invoicesJson = (invoicesResponse['invoices'] as List<dynamic>)
          .cast<Map<String, dynamic>>();

      test('should return [Invoice] list when the statusCode is equeal to 200',
          () async {
        when(
          () => dio.get<Map<String, dynamic>>(
            'getInvoices',
            options: any<Options>(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: 'getInvoices'),
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
          () => dio.get<Map<String, dynamic>>(
            'getInvoices',
            options: any<Options>(named: 'options'),
          ),
        ).called(1);
      });

      test('should throw [UnauthorizedException] when the statusCode is 403',
          () async {
        when(
          () => dio.get<Map<String, dynamic>>(
            'getInvoices',
            options: any<Options>(named: 'options'),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: 'getInvoices'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: 'getInvoices'),
              statusCode: 403,
              data: <String, dynamic>{'detail': 'Invalid secret key'},
            ),
          ),
        );

        expect(
          () => telepay.getInvoices(),
          throwsA(
            isA<UnauthorizedException>().having(
              (e) => e.message,
              'message',
              'Invalid secret key',
            ),
          ),
        );
      });

      test(
          'should throw [TelePayException] when the statusCode '
          'is diferent the 403', () async {
        when(
          () => dio.get<Map<String, dynamic>>(
            'getInvoices',
            options: any<Options>(named: 'options'),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: 'getInvoices'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: 'getInvoices'),
              statusCode: 500,
              data: <String, dynamic>{'detail': 'Internal server error'},
            ),
          ),
        );

        expect(
          () => telepay.getInvoices(),
          throwsA(
            isA<TelePayException>().having(
              (e) => e.message,
              'message',
              'Failed to get invoices: \n'
                  'STATUS_CODE: 500 \n'
                  'RESPONSE: {detail: Internal server error}',
            ),
          ),
        );
      });
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
          () => dio.get<Map<String, dynamic>>(
            getInvoicePath,
            options: any<Options>(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: 'getInvoice'),
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
          () => dio.get<Map<String, dynamic>>(
            getInvoicePath,
            options: any<Options>(named: 'options'),
          ),
        ).called(1);
      });

      test('should throw [UnauthorizedException] when the statusCode is 403',
          () async {
        when(
          () => dio.get<Map<String, dynamic>>(
            getInvoicePath,
            options: any<Options>(named: 'options'),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: getInvoicePath),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: getInvoicePath),
              statusCode: 403,
              data: <String, dynamic>{'detail': 'Invalid secret key'},
            ),
          ),
        );

        expect(
          () => telepay.getInvoice(invoiceNumber),
          throwsA(
            isA<UnauthorizedException>().having(
              (e) => e.message,
              'message',
              'Invalid secret key',
            ),
          ),
        );
      });

      test(
          'should throw [TelePayException] when the statusCode '
          'is diferent the 403', () async {
        when(
          () => dio.get<Map<String, dynamic>>(
            getInvoicePath,
            options: any<Options>(named: 'options'),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: getInvoicePath),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: getInvoicePath),
              statusCode: 500,
              data: <String, dynamic>{'detail': 'Internal server error'},
            ),
          ),
        );

        expect(
          () => telepay.getInvoice(invoiceNumber),
          throwsA(
            isA<TelePayException>().having(
              (e) => e.message,
              'message',
              'Failed to get invoice: \n'
                  'STATUS_CODE: 500 \n'
                  'RESPONSE: {detail: Internal server error}',
            ),
          ),
        );
      });
    });

    group('getAssets', () {
      final assetsResponse =
          jsonDecode(fixture('assets.json')) as Map<String, dynamic>;
      final assetsJson = (assetsResponse['assets'] as List<dynamic>)
          .cast<Map<String, dynamic>>();

      test('should return [Asset] list when the statusCode is equeal to 200',
          () async {
        when(
          () => dio.get<Map<String, dynamic>>(
            'getAssets',
            options: any<Options>(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: 'getAssets'),
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
          () => dio.get<Map<String, dynamic>>(
            'getAssets',
            options: any<Options>(named: 'options'),
          ),
        ).called(1);
      });

      test('should throw [UnauthorizedException] when the statusCode is 403',
          () async {
        when(
          () => dio.get<Map<String, dynamic>>(
            'getAssets',
            options: any<Options>(named: 'options'),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: 'getAssets'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: 'getAssets'),
              statusCode: 403,
              data: <String, dynamic>{'detail': 'Invalid secret key'},
            ),
          ),
        );

        expect(
          () => telepay.getAssets(),
          throwsA(
            isA<UnauthorizedException>().having(
              (e) => e.message,
              'message',
              'Invalid secret key',
            ),
          ),
        );
      });

      test(
          'should throw [TelePayException] when the statusCode '
          'is diferent the 403', () async {
        when(
          () => dio.get<Map<String, dynamic>>(
            'getAssets',
            options: any<Options>(named: 'options'),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: 'getAssets'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: 'getAssets'),
              statusCode: 500,
              data: <String, dynamic>{'detail': 'Internal server error'},
            ),
          ),
        );

        expect(
          () => telepay.getAssets(),
          throwsA(
            isA<TelePayException>().having(
              (e) => e.message,
              'message',
              'Failed to get assets: \n'
                  'STATUS_CODE: 500 \n'
                  'RESPONSE: {detail: Internal server error}',
            ),
          ),
        );
      });
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
          () => dio.post<Map<String, dynamic>>(
            'createInvoice',
            data: createInvoiceModel.toJson(),
            options: any<Options>(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: 'createInvoice',
              data: invoiceResponse,
            ),
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
          () => dio.post<Map<String, dynamic>>(
            'createInvoice',
            data: createInvoiceModel.toJson(),
            options: any<Options>(named: 'options'),
          ),
        ).called(1);
      });

      test('should throw [UnauthorizedException] when the statusCode is 403',
          () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            'createInvoice',
            options: any<Options>(named: 'options'),
            data: createInvoiceModel.toJson(),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: 'createInvoice'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: 'createInvoice'),
              statusCode: 403,
              data: <String, dynamic>{'detail': 'Invalid secret key'},
            ),
          ),
        );

        expect(
          () => telepay.createInvoice(createInvoiceModel),
          throwsA(
            isA<UnauthorizedException>().having(
              (e) => e.message,
              'message',
              'Invalid secret key',
            ),
          ),
        );
      });

      test(
          'should throw [TelePayException] when the statusCode '
          'is diferent the 403', () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            'createInvoice',
            options: any<Options>(named: 'options'),
            data: createInvoiceModel.toJson(),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: 'createInvoice'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: 'createInvoice'),
              statusCode: 500,
              data: <String, dynamic>{'detail': 'Internal server error'},
            ),
          ),
        );

        expect(
          () => telepay.createInvoice(createInvoiceModel),
          throwsA(
            isA<TelePayException>().having(
              (e) => e.message,
              'message',
              'Failed to create invoice: \n'
                  'STATUS_CODE: 500 \n'
                  'RESPONSE: {detail: Internal server error}',
            ),
          ),
        );
      });
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
          () => dio.post<Map<String, dynamic>>(
            cancelInvoicePath,
            options: any<Options>(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: cancelInvoicePath,
              data: invoiceResponse,
            ),
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
          () => dio.post<Map<String, dynamic>>(
            cancelInvoicePath,
            options: any<Options>(named: 'options'),
          ),
        ).called(1);
      });

      test('should throw [UnauthorizedException] when the statusCode is 403',
          () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            cancelInvoicePath,
            options: any<Options>(named: 'options'),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: cancelInvoicePath),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: cancelInvoicePath),
              statusCode: 403,
              data: <String, dynamic>{'detail': 'Invalid secret key'},
            ),
          ),
        );

        expect(
          () => telepay.cancelInvoice(invoiceNumber),
          throwsA(
            isA<UnauthorizedException>().having(
              (e) => e.message,
              'message',
              'Invalid secret key',
            ),
          ),
        );
      });

      test(
          'should throw [TelePayException] when the statusCode '
          'is diferent the 403', () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            cancelInvoicePath,
            options: any<Options>(named: 'options'),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: cancelInvoicePath),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: cancelInvoicePath),
              statusCode: 500,
              data: <String, dynamic>{'detail': 'Internal server error'},
            ),
          ),
        );

        expect(
          () => telepay.cancelInvoice(invoiceNumber),
          throwsA(
            isA<TelePayException>().having(
              (e) => e.message,
              'message',
              'Failed to cancel invoice: \n'
                  'STATUS_CODE: 500 \n'
                  'RESPONSE: {detail: Internal server error}',
            ),
          ),
        );
      });
    });

    group('deleteInvoice', () {
      final deleteResponse = <String, dynamic>{'status': 'deleted'};

      const invoiceNumber = 'PUEOS5RFQY';
      const deleteInvoicePath = 'deleteInvoice/$invoiceNumber';

      test('should return `true` when the invoice was delete', () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            deleteInvoicePath,
            options: any<Options>(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: deleteInvoicePath,
              data: deleteResponse,
            ),
            statusCode: 200,
            data: deleteResponse,
          ),
        );

        expect(await telepay.deleteInvoice(invoiceNumber), isTrue);

        verify(
          () => dio.post<Map<String, dynamic>>(
            deleteInvoicePath,
            options: any<Options>(named: 'options'),
          ),
        ).called(1);
      });

      test(
          'should throw [UnauthorizedException] when the secret key is invalid',
          () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            deleteInvoicePath,
            options: any<Options>(named: 'options'),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: deleteInvoicePath),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: deleteInvoicePath),
              statusCode: 403,
              data: <String, dynamic>{'detail': 'Invalid secret key'},
            ),
          ),
        );

        expect(
          () => telepay.deleteInvoice(invoiceNumber),
          throwsA(
            isA<UnauthorizedException>().having(
              (e) => e.message,
              'message',
              'Invalid secret key',
            ),
          ),
        );
      });

      test(
          'should throw [NotFoundException] when not found '
          'the invoice to delete', () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            deleteInvoicePath,
            options: any<Options>(named: 'options'),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: deleteInvoicePath),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: deleteInvoicePath),
              statusCode: 404,
              data: <String, dynamic>{
                'error': 'not-found',
                'message': 'Invoice with number $invoiceNumber does not exist',
              },
            ),
          ),
        );

        expect(
          () => telepay.deleteInvoice(invoiceNumber),
          throwsA(
            isA<NotFoundException>().having(
              (e) => e.message,
              'message',
              'Invoice with number $invoiceNumber does not exist',
            ),
          ),
        );
      });

      test(
          'should throw [TelePayException] when the statusCode '
          'is diferent the 403', () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            deleteInvoicePath,
            options: any<Options>(named: 'options'),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: deleteInvoicePath),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: deleteInvoicePath),
              statusCode: 500,
              data: <String, dynamic>{'detail': 'Internal server error'},
            ),
          ),
        );

        expect(
          () => telepay.deleteInvoice(invoiceNumber),
          throwsA(
            isA<TelePayException>().having(
              (e) => e.message,
              'message',
              'Failed to delete invoice: \n'
                  'STATUS_CODE: 500 \n'
                  'RESPONSE: {detail: Internal server error}',
            ),
          ),
        );
      });
    });

    group('transfer', () {
      final tranferResponse = <String, dynamic>{'success': true};
      final tranferJson =
          jsonDecode(fixture('create_transfer.json')) as Map<String, dynamic>;
      final transferModel = CreateTransfer.fromJson(tranferJson);

      test('should return `true` when the transfer was create', () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            'transfer',
            options: any<Options>(named: 'options'),
            data: transferModel.toJson(),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: 'transfer',
              data: tranferResponse,
            ),
            statusCode: 200,
            data: tranferResponse,
          ),
        );

        expect(await telepay.transfer(transferModel), isTrue);

        verify(
          () => dio.post<Map<String, dynamic>>(
            'transfer',
            options: any<Options>(named: 'options'),
            data: transferModel.toJson(),
          ),
        ).called(1);
      });

      test(
          'should throw [UnauthorizedException] when the secret key is invalid',
          () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            'transfer',
            options: any<Options>(named: 'options'),
            data: transferModel.toJson(),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: 'transfer'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: 'transfer'),
              statusCode: 403,
              data: <String, dynamic>{'detail': 'Invalid secret key'},
            ),
          ),
        );

        expect(
          () => telepay.transfer(transferModel),
          throwsA(
            isA<UnauthorizedException>().having(
              (e) => e.message,
              'message',
              'Invalid secret key',
            ),
          ),
        );
      });

      test(
          'should throw [NotFoundException] when merchant or user '
          'does not exist', () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            'transfer',
            options: any<Options>(named: 'options'),
            data: transferModel.toJson(),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: 'transfer'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: 'transfer'),
              statusCode: 401,
              data: <String, dynamic>{
                'error': 'not-found',
                'message':
                    'User or merchant with username ${transferModel.username} '
                        'does not exist'
              },
            ),
          ),
        );

        expect(
          () => telepay.transfer(transferModel),
          throwsA(
            isA<NotFoundException>().having(
              (e) => e.message,
              'message',
              'User or merchant with username ${transferModel.username} '
                  'does not exist',
            ),
          ),
        );
      });

      test('should throw [TelePayException] when occurre generic error',
          () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            'transfer',
            options: any<Options>(named: 'options'),
            data: transferModel.toJson(),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: 'transfer'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: 'transfer'),
              statusCode: 500,
              data: <String, dynamic>{'detail': 'Internal server error'},
            ),
          ),
        );

        expect(
          () => telepay.transfer(transferModel),
          throwsA(
            isA<TelePayException>().having(
              (e) => e.message,
              'message',
              'Failed to transfer: \n'
                  'STATUS_CODE: 500 \n'
                  'RESPONSE: {detail: Internal server error}',
            ),
          ),
        );
      });
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
          () => dio.post<Map<String, dynamic>>(
            'getWithdrawMinimum',
            options: any<Options>(named: 'options'),
            data: getWithdrawMinimumData,
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: 'getWithdrawMinimum',
              data: tranferResponse,
            ),
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
          () => dio.post<Map<String, dynamic>>(
            'getWithdrawMinimum',
            options: any<Options>(named: 'options'),
            data: getWithdrawMinimumData,
          ),
        ).called(1);
      });

      test('should throw [UnauthorizedException] when the statusCode is 403',
          () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            'getWithdrawMinimum',
            options: any<Options>(named: 'options'),
            data: getWithdrawMinimumData,
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: 'getWithdrawMinimum'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: 'getWithdrawMinimum'),
              statusCode: 403,
              data: <String, dynamic>{'detail': 'Invalid secret key'},
            ),
          ),
        );

        expect(
          () => telepay.getWithdrawMinimum(
            getWithdrawMinimumData['asset']!,
            getWithdrawMinimumData['blockchain']!,
            getWithdrawMinimumData['network'],
          ),
          throwsA(
            isA<UnauthorizedException>().having(
              (e) => e.message,
              'message',
              'Invalid secret key',
            ),
          ),
        );
      });

      test(
          'should throw [TelePayException] when the statusCode '
          'is diferent the 403', () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            'getWithdrawMinimum',
            options: any<Options>(named: 'options'),
            data: getWithdrawMinimumData,
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: 'getWithdrawMinimum'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: 'getWithdrawMinimum'),
              statusCode: 500,
              data: <String, dynamic>{'detail': 'Internal server error'},
            ),
          ),
        );

        expect(
          () => telepay.getWithdrawMinimum(
            getWithdrawMinimumData['asset']!,
            getWithdrawMinimumData['blockchain']!,
            getWithdrawMinimumData['network'],
          ),
          throwsA(
            isA<TelePayException>().having(
              (e) => e.message,
              'message',
              'Failed to get withdraw minimum: \n'
                  'STATUS_CODE: 500 \n'
                  'RESPONSE: {detail: Internal server error}',
            ),
          ),
        );
      });

      test('should throw [NotFoundException] when the asset was not found',
          () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            'getWithdrawMinimum',
            options: any<Options>(named: 'options'),
            data: getWithdrawMinimumData,
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: 'getWithdrawMinimum'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: 'getWithdrawMinimum'),
              statusCode: 401,
              data: <String, dynamic>{'error': 'asset-not-found'},
            ),
          ),
        );

        expect(
          () => telepay.getWithdrawMinimum(
            getWithdrawMinimumData['asset']!,
            getWithdrawMinimumData['blockchain']!,
            getWithdrawMinimumData['network'],
          ),
          throwsA(
            isA<NotFoundException>().having(
              (e) => e.message,
              'message',
              'asset-not-found',
            ),
          ),
        );
      });
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
          () => dio.post<Map<String, dynamic>>(
            'getWithdrawFee',
            options: any<Options>(named: 'options'),
            data: createWithdrawModel.toJson(),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: 'getWithdrawFee',
              data: withdrawFeeResponse,
            ),
            statusCode: 200,
            data: withdrawFeeResponse,
          ),
        );

        final result = await telepay.getWithdrawFee(createWithdrawModel);

        expect(result, equals(Fee.fromJson(withdrawFeeResponse)));

        verify(
          () => dio.post<Map<String, dynamic>>(
            'getWithdrawFee',
            options: any<Options>(named: 'options'),
            data: createWithdrawModel.toJson(),
          ),
        ).called(1);
      });

      test('should throw [UnauthorizedException] when the statusCode is 403',
          () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            'getWithdrawFee',
            options: any<Options>(named: 'options'),
            data: createWithdrawModel.toJson(),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: 'getWithdrawFee'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: 'getWithdrawFee'),
              statusCode: 403,
              data: <String, dynamic>{'detail': 'Invalid secret key'},
            ),
          ),
        );

        expect(
          () => telepay.getWithdrawFee(createWithdrawModel),
          throwsA(
            isA<UnauthorizedException>().having(
              (e) => e.message,
              'message',
              'Invalid secret key',
            ),
          ),
        );
      });

      test(
          'should throw [TelePayException] when the statusCode '
          'is diferent the 403', () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            'getWithdrawFee',
            options: any<Options>(named: 'options'),
            data: createWithdrawModel.toJson(),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: 'getWithdrawFee'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: 'getWithdrawFee'),
              statusCode: 500,
              data: <String, dynamic>{'detail': 'Internal server error'},
            ),
          ),
        );

        expect(
          () => telepay.getWithdrawFee(createWithdrawModel),
          throwsA(
            isA<TelePayException>().having(
              (e) => e.message,
              'message',
              'Failed to get withdraw fee: \n'
                  'STATUS_CODE: 500 \n'
                  'RESPONSE: {detail: Internal server error}',
            ),
          ),
        );
      });

      test('should throw [NotFoundException] when the asset was not found',
          () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            'getWithdrawFee',
            options: any<Options>(named: 'options'),
            data: createWithdrawModel.toJson(),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: 'getWithdrawFee'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: 'getWithdrawFee'),
              statusCode: 401,
              data: <String, dynamic>{'error': 'asset-not-found'},
            ),
          ),
        );

        expect(
          () => telepay.getWithdrawFee(createWithdrawModel),
          throwsA(
            isA<NotFoundException>().having(
              (e) => e.message,
              'message',
              'asset-not-found',
            ),
          ),
        );
      });
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
          () => dio.post<Map<String, dynamic>>(
            'withdraw',
            options: any<Options>(named: 'options'),
            data: createWithdrawModel.toJson(),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: 'withdraw',
              data: withdrawResponse,
            ),
            statusCode: 200,
            data: withdrawResponse,
          ),
        );

        final result = await telepay.withdraw(createWithdrawModel);

        expect(result, isTrue);

        verify(
          () => dio.post<Map<String, dynamic>>(
            'withdraw',
            options: any<Options>(named: 'options'),
            data: createWithdrawModel.toJson(),
          ),
        ).called(1);
      });

      test('should throw [UnauthorizedException] when the statusCode is 403',
          () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            'withdraw',
            options: any<Options>(named: 'options'),
            data: createWithdrawModel.toJson(),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: 'withdraw'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: 'withdraw'),
              statusCode: 403,
              data: <String, dynamic>{'detail': 'Invalid secret key'},
            ),
          ),
        );

        expect(
          () => telepay.withdraw(createWithdrawModel),
          throwsA(
            isA<UnauthorizedException>().having(
              (e) => e.message,
              'message',
              'Invalid secret key',
            ),
          ),
        );
      });

      test(
          'should throw [TelePayException] when the statusCode '
          'is diferent the 403', () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            'withdraw',
            options: any<Options>(named: 'options'),
            data: createWithdrawModel.toJson(),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: 'withdraw'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: 'withdraw'),
              statusCode: 500,
              data: <String, dynamic>{'detail': 'Internal server error'},
            ),
          ),
        );

        expect(
          () => telepay.withdraw(createWithdrawModel),
          throwsA(
            isA<TelePayException>().having(
              (e) => e.message,
              'message',
              'Failed to withdraw: \n'
                  'STATUS_CODE: 500 \n'
                  'RESPONSE: {detail: Internal server error}',
            ),
          ),
        );
      });
      test(
          'should throw [InsufficienttFondsException] when not '
          'have suficient founds', () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            'withdraw',
            options: any<Options>(named: 'options'),
            data: createWithdrawModel.toJson(),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: 'withdraw'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: 'withdraw'),
              statusCode: 401,
              data: <String, dynamic>{
                'error': 'insufficient-funds',
                'message': 'Insufficient funds to withdraw'
              },
            ),
          ),
        );

        expect(
          () => telepay.withdraw(createWithdrawModel),
          throwsA(
            isA<InsufficienttFondsException>().having(
              (e) => e.message,
              'message',
              'Insufficient funds to withdraw',
            ),
          ),
        );
      });

      test('should throw [NotFoundException] when not found the asset',
          () async {
        when(
          () => dio.post<Map<String, dynamic>>(
            'withdraw',
            options: any<Options>(named: 'options'),
            data: createWithdrawModel.toJson(),
          ),
        ).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: 'withdraw'),
            response: Response<Map<String, dynamic>>(
              requestOptions: RequestOptions(path: 'withdraw'),
              statusCode: 401,
              data: <String, dynamic>{
                'error': 'asset-not-found',
                'message': 'Asset not found'
              },
            ),
          ),
        );

        expect(
          () => telepay.withdraw(createWithdrawModel),
          throwsA(
            isA<NotFoundException>().having(
              (e) => e.message,
              'message',
              'Asset not found',
            ),
          ),
        );
      });
    });
  });
}
