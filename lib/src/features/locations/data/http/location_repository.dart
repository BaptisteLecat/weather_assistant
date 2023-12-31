import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:weatherjourney/src/features/weather/data/dto/generation_dto.dart';
import 'package:weatherjourney/src/features/weather/domain/generation/generation.dart';
import 'package:weatherjourney/src/utils/dio_fetcher.dart';

part 'location_repository.g.dart';

@RestApi(baseUrl: "https://weather-generation-api-iqazqscksq-ew.a.run.app/v1")
abstract class LocationRepository {
  factory LocationRepository(Dio dio, {String baseUrl}) = _LocationRepository;

  @POST("/locations/{locationId}/generations")
  Future<Generation> createGeneration(
    @Header("Authorization") String token,
    @Header("api-key") String apiKey,
    @Header("Content-Type") String contentType,
    @Path("locationId") String locationId,
    @Body() GenerationDto generation,
  );
}

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  final dio = ref.watch(dioFetcherProvider);
  return LocationRepository(dio);
});
