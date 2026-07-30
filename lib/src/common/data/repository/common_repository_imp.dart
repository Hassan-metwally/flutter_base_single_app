import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/entity/city_entity.dart';
import '../../domain/entity/common_entity.dart';
import '../../domain/repository/common_repository.dart';
import '../models/api_city_model.dart';
import '../models/api_common_model.dart';

@Injectable(as: CommonRepository)
class CommonRepositoryImp implements CommonRepository {
  final DioHelper _dioHelper;

  const CommonRepositoryImp(this._dioHelper);

  @override
  DomainServiceType<AppLanguageEnum> changeLanguage(AppLanguageEnum lang) {
    return failureCollect(() async {
      await _dioHelper.post(url: "auth/change-language", body: {"language": lang.value});
      return Right(lang);
    });
  }

  @override
  DomainServiceType<List<CityEntity>> getCities() async {
    return await failureCollect(() async {
      final response = await _dioHelper.get(url: '/shared-api/v1/cities', queryParameters: {'page': '0', 'limit': '0'});
      final List date = List.from(response['data']);
      final List<ApiCityModel> cities = date.map((e) {
        return ApiCityModel.fromJson(e);
      }).toList();
      return Right(cities.map((e) => e.map).toList());
    });
  }

  @override
  DomainServiceType<List<CommonEntity>> getServices() async {
    return await failureCollect(() async {
      final response = await _dioHelper.get(url: '/shared-api/v1/services', queryParameters: {'page': '0', 'limit': '0'});
      final List date = List.from(response['data']);
      final List<ApiCommonModel> countries = date.map((e) {
        return ApiCommonModel.fromJson(e);
      }).toList();
      return Right(countries.map((e) => e.map).toList());
    });
  }

  @override
  DomainServiceType<List<CommonEntity>> getBanks() async {
    return await failureCollect(() async {
      final response = await _dioHelper.get(url: '/shared-api/v1/banks', queryParameters: {'page': '0', 'limit': '0'});
      final List date = List.from(response['data']);
      final List<ApiCommonModel> banks = date.map((e) {
        return ApiCommonModel.fromJson(e);
      }).toList();
      return Right(banks.map((e) => e.map).toList());
    });
  }
}
