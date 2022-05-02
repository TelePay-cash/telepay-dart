// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:telepay/src/exceptions/exceptions.dart';
import 'package:telepay/src/models/models.dart';
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
              'Failed to get balance: \n'
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
              'Failed to get balance: \n'
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
              'Failed to get balance: \n'
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
              'Failed to get balance: \n'
                  'STATUS_CODE: 500 \n'
                  'RESPONSE: {detail: Internal server error}',
            ),
          ),
        );
      });
    });
  });
}
