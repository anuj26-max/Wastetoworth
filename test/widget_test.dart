import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:waste2worth/main.dart';
import 'package:flutter/material.dart';
import 'package:waste2worth/models/waste_item.dart';
import 'package:waste2worth/providers/communication_provider.dart';
import 'package:waste2worth/services/mock_data.dart';
import 'package:waste2worth/services/waste_analysis_service.dart';
import 'package:waste2worth/services/marketplace_service.dart';

final Uint8List _transparentPng = Uint8List.fromList(<int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

class _MockHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = true;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _MockHttpRequest();
}

class _MockHttpRequest extends Fake implements HttpClientRequest {
  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async => _MockHttpResponse();
}

class _MockHttpHeaders extends Fake implements HttpHeaders {
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class _MockHttpResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => _transparentPng.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.value(_transparentPng).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

class _MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _MockHttpClient();
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _MockHttpOverrides();
  });

  group('Waste2Worth Unit & Service Tests', () {
    test('MockData contains initial listings and facilities', () {
      final listings = MockData.initialListings;
      final facilities = MockData.sampleFacilities;
      final scans = MockData.sampleScans;

      expect(listings.isNotEmpty, isTrue);
      expect(facilities.isNotEmpty, isTrue);
      expect(scans.isNotEmpty, isTrue);

      final iPhoneItem = listings.firstWhere((item) => item.id == 'item_1');
      expect(iPhoneItem.title, contains('Apple iPhone 12'));
      expect(iPhoneItem.price, equals(45000));
      expect(iPhoneItem.category, equals(WasteCategory.eWaste));
    });

    test('WasteAnalysisService simulates YOLO inference and valuation', () async {
      final service = WasteAnalysisService();
      final result = await service.analyzeImage(sampleType: 'plastic');

      expect(result.itemName, contains('PET Beverage Bottle'));
      expect(result.category, equals(WasteCategory.plastic));
      expect(result.confidence, greaterThan(0.9));
      expect(result.totalEstimatedWorth, greaterThan(0));
    });

    test('MarketplaceService filters by category and search', () async {
      final service = MarketplaceService();

      final metalListings = await service.getListings(category: WasteCategory.metal);
      expect(metalListings.every((item) => item.category == WasteCategory.metal), isTrue);

      final searchResults = await service.getListings(searchQuery: 'copper');
      expect(searchResults.isNotEmpty, isTrue);
      expect(searchResults.any((item) => item.title.toLowerCase().contains('copper')), isTrue);
    });
    test('CommunicationProvider manages notifications and messages', () {
      final comm = CommunicationProvider();
      expect(comm.notifications.isNotEmpty, isTrue);
      expect(comm.unreadNotificationCount, greaterThan(0));

      final firstNotifId = comm.notifications.first.id;
      comm.markNotificationAsRead(firstNotifId);
      expect(comm.notifications.first.isRead, isTrue);

      expect(comm.conversations.isNotEmpty, isTrue);
      final initialCount = comm.conversations.first.messages.length;
      comm.sendMessage(comm.conversations.first.id, 'Test reply message');
      expect(comm.conversations.first.messages.length, equals(initialCount + 1));
    });
  });

  group('Waste2Worth Widget Tests', () {
    testWidgets('Renders app title, notification bell, and chat icons in navbar', (WidgetTester tester) async {
      await tester.pumpWidget(const Waste2WorthApp());
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Waste2Worth'), findsOneWidget);
      expect(find.text('What are you looking for?'), findsOneWidget);
      expect(find.text('New Recommendations'), findsOneWidget);

      // Verify Navbar notification and chat icons are rendered
      expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
      expect(find.byIcon(Icons.chat_bubble_outline_rounded), findsOneWidget);
    });
  });
}
