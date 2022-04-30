// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:telepay/src/exceptions/exceptions.dart';
import 'package:telepay/src/models/models.dart';
import 'package:telepay/telepay.dart';
import 'package:test/test.dart';

import '../fixtures/fixture_reader.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late TelePay telepay;

  setUpAll(() {
    dio = MockDio();
    telepay = TelePay(secretApiKey: 'secretApiKey', dio: dio);

    registerFallbackValue(Options());
  });

  group('TelepayDart', () {
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

      test('should throw [TelePayException] when the statusCode is 500',
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
  });
}
