import 'dart:ui';

import 'package:demo_app/main/data/model/goong/place_detail.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

import 'package:demo_app/main/data/model/goong/location.dart';
import 'package:demo_app/main/data/repository/goong_repository.dart';

part 'search_destination_event.dart';
part 'search_destination_state.dart';

class SearchDestinationBloc
    extends Bloc<SearchDestinationEvent, SearchDestinationState> {
  SearchDestinationBloc() : super(SearchDestinationInitial()) {
    on<LoadSearchDataEvent>(_onLoadData);
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
    on<SaveLocationEvent>(_onSaveLocation);
    on<FetchCurrentLocationEvent>(_onFetchCurrentLocation);
    on<SavePickupLocationEvent>(_onSavePickupLocation);
    on<SaveDestinationLocationEvent>(_onSaveDestinationLocation);
    on<SavePickupPlaceIdEvent>(_onSavePickupPlaceId);
    on<SaveDestinationPlaceIdEvent>(_onSaveDestinationPlaceId);
    on<SubmitSearchEvent>(_onSubmitSearch);
  }

  Future<void> _onLoadData(
      LoadSearchDataEvent event, Emitter<SearchDestinationState> emit) async {
    emit(SearchDestinationLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 700));
      final locations = [
        GoongLocation(
          description: "Huyện Trạm Tấu, Yên Bái",
          matchedSubstrings: const [
            MatchedSubstring(length: 1, offset: 6),
            MatchedSubstring(length: 1, offset: 11),
          ],
          placeId:
              "WwQAon2CqIxlhWYtqBaCvkf7ZTe3TriYU99xJIO0oMdVh1RPY7OBsH_AQYqNFId1Y8Qso6RxmaFT5FswhF-OmHw7R_xjq7geZutUQBRygphngkcUtBSESsGXCTz-CFfmu",
          reference:
              "WwQAon2CqIxlhWYtqBaCvkf7ZTe3TriYU99xJIO0oMdVh1RPY7OBsH_AQYqNFId1Y8Qso6RxmaFT5FswhF-OmHw7R_xjq7geZutUQBRygphngkcUtBSESsGXCTz-CFfmu",
          structuredFormatting: const StructuredFormatting(
            mainText: "Huyện Trạm Tấu",
            secondaryText: "Yên Bái",
          ),
          terms: const [
            Term(offset: 0, value: "Huyện Trạm Tấu"),
            Term(offset: 21, value: "Yên Bái"),
          ],
          hasChildren: false,
          displayType: "expand0",
          score: 0,
          plusCode: const PlusCode(compoundCode: "", globalCode: ""),
        ),
        GoongLocation(
          description: "Trà Vinh",
          matchedSubstrings: const [
            MatchedSubstring(length: 1, offset: 0),
          ],
          placeId:
              "gFSDxqhxpYNqxFoDgmKQymSyTQOxFFvjwfr9GHb1i8NmvVVY_qHOMhKPHVgW1FY_0fcZsO4tgn4Z-Oi3HhBWDZ8MNdDeFY_1iZ6NVQYNzg05mmeoVtRWTRmSxTj6DFPjD",
          reference:
              "gFSDxqhxpYNqxFoDgmKQymSyTQOxFFvjwfr9GHb1i8NmvVVY_qHOMhKPHVgW1FY_0fcZsO4tgn4Z-Oi3HhBWDZ8MNdDeFY_1iZ6NVQYNzg05mmeoVtRWTRmSxTj6DFPjD",
          structuredFormatting: const StructuredFormatting(
            mainText: "Trà Vinh",
            secondaryText: "",
          ),
          terms: const [
            Term(offset: 0, value: "Trà Vinh"),
          ],
          hasChildren: false,
          displayType: "expand0",
          score: 0,
          plusCode: const PlusCode(compoundCode: "", globalCode: ""),
        ),
        GoongLocation(
          description: "Thành phố Thanh Hóa, Tỉnh Thanh Hóa",
          matchedSubstrings: const [
            MatchedSubstring(length: 1, offset: 0),
            MatchedSubstring(length: 1, offset: 10),
            MatchedSubstring(length: 1, offset: 21),
            MatchedSubstring(length: 1, offset: 26),
          ],
          placeId:
              "kb4BIo6eUwV_vmUmq26om2DbaZaef64Hf6xtJ7dUIo51IgEPbr22F1U6iW1OpQ7z_eKIIS54KjtpgvEsIoH7t2EiyZRi0cZLnerxIXJ5unvd7hHoIf6iOnluseSMICeXe",
          reference:
              "kb4BIo6eUwV_vmUmq26om2DbaZaef64Hf6xtJ7dUIo51IgEPbr22F1U6iW1OpQ7z_eKIIS54KjtpgvEsIoH7t2EiyZRi0cZLnerxIXJ5unvd7hHoIf6iOnluseSMICeXe",
          structuredFormatting: const StructuredFormatting(
            mainText: "Thành phố Thanh Hóa",
            secondaryText: "Tỉnh Thanh Hóa",
          ),
          terms: const [
            Term(offset: 0, value: "Thành phố Thanh Hóa"),
            Term(offset: 24, value: "Tỉnh Thanh Hóa"),
          ],
          hasChildren: false,
          displayType: "expand0",
          score: 0,
          plusCode: const PlusCode(compoundCode: "", globalCode: ""),
        ),
        GoongLocation(
          description: "Quận Thanh Xuân, Thành phố Hà Nội",
          matchedSubstrings: const [
            MatchedSubstring(length: 1, offset: 5),
            MatchedSubstring(length: 1, offset: 17),
          ],
          placeId:
              "fHdum3KtnW1MvWoGt1CanHjaq15ECIXhebGbX5hQge6xfFAHLrEiN9ZOxYVuYC53EfKFIIZp5gcV_fEgkJNmV-3l0R5tZlZJReb1LX53j7vR4h1gLqwuNnXqvUCCdCubd",
          reference:
              "fHdum3KtnW1MvWoGt1CanHjaq15ECIXhebGbX5hQge6xfFAHLrEiN9ZOxYVuYC53EfKFIIZp5gcV_fEgkJNmV-3l0R5tZlZJReb1LX53j7vR4h1gLqwuNnXqvUCCdCubd",
          structuredFormatting: const StructuredFormatting(
            mainText: "Quận Thanh Xuân",
            secondaryText: "Thành phố Hà Nội",
          ),
          terms: const [
            Term(offset: 0, value: "Quận Thanh Xuân"),
            Term(offset: 19, value: "Thành phố Hà Nội"),
          ],
          hasChildren: false,
          displayType: "expand0",
          score: 0,
          plusCode: const PlusCode(compoundCode: "", globalCode: ""),
        ),
        GoongLocation(
          description: "Huyện Trảng Bom, Đồng Nai",
          matchedSubstrings: const [
            MatchedSubstring(length: 1, offset: 6),
          ],
          placeId:
              "orCeTrjk4GNSnUsdq66E0cmadeUGwYLHff5xfQ7JOsOJTnFcBqXBPhXxmuEOpO1v9sWBTcbccmut_xE9GhBenjVKuREWFbYekZqJUQIJygutnwkcUtBSSgmWKTz-CFfmY",
          reference:
              "orCeTrjk4GNSnUsdq66E0cmadeUGwYLHff5xfQ7JOsOJTnFcBqXBPhXxmuEOpO1v9sWBTcbccmut_xE9GhBenjVKuREWFbYekZqJUQIJygutnwkcUtBSSgmWKTz-CFfmY",
          structuredFormatting: const StructuredFormatting(
            mainText: "Huyện Trảng Bom",
            secondaryText: "Đồng Nai",
          ),
          terms: const [
            Term(offset: 0, value: "Huyện Trảng Bom"),
            Term(offset: 20, value: "Đồng Nai"),
          ],
          hasChildren: false,
          displayType: "expand0",
          score: 0,
          plusCode: const PlusCode(compoundCode: "", globalCode: ""),
        ),
        GoongLocation(
          description: "Thái Bình",
          matchedSubstrings: const [
            MatchedSubstring(length: 1, offset: 0),
          ],
          placeId:
              "ro5sa-yiAMhekUcRp0O86GqRfk29dbTTc5BTT75CvO5fkFuBpXwNiV5qQLSlfZLxv4ZfELtClmxzb0NKiOeruF4bSEmiY2aiJN4tYaq5-judMlEsYuBiejmm8QzOOGfXO",
          reference:
              "ro5sa-yiAMhekUcRp0O86GqRfk29dbTTc5BTT75CvO5fkFuBpXwNiV5qQLSlfZLxv4ZfELtClmxzb0NKiOeruF4bSEmiY2aiJN4tYaq5-judMlEsYuBiejmm8QzOOGfXO",
          structuredFormatting: const StructuredFormatting(
            mainText: "Thái Bình",
            secondaryText: "",
          ),
          terms: const [
            Term(offset: 0, value: "Thái Bình"),
          ],
          hasChildren: false,
          displayType: "expand0",
          score: 0,
          plusCode: const PlusCode(compoundCode: "", globalCode: ""),
        ),
        GoongLocation(
          description: "Thanh Hóa",
          matchedSubstrings: const [
            MatchedSubstring(length: 1, offset: 0),
          ],
          placeId:
              "Wmfgl5hVaY2pt0kZR3i5c6Rek6BFBAZdsprZ4KGt3m9Ogq0IMQACXLryZUtVGZrYJpJ9CFEB0j9On8W9SRnWb6aGleHZzu5vPlzhBeHK3l_6hjVIBcAGHl5eloSpaAOzX",
          reference:
              "Wmfgl5hVaY2pt0kZR3i5c6Rek6BFBAZdsprZ4KGt3m9Ogq0IMQACXLryZUtVGZrYJpJ9CFEB0j9On8W9SRnWb6aGleHZzu5vPlzhBeHK3l_6hjVIBcAGHl5eloSpaAOzX",
          structuredFormatting: const StructuredFormatting(
            mainText: "Thanh Hóa",
            secondaryText: "",
          ),
          terms: const [
            Term(offset: 0, value: "Thanh Hóa"),
          ],
          hasChildren: false,
          displayType: "expand0",
          score: 0,
          plusCode: const PlusCode(compoundCode: "", globalCode: ""),
        ),
        GoongLocation(
          description: "Thái Nguyên",
          matchedSubstrings: const [
            MatchedSubstring(length: 1, offset: 0),
          ],
          placeId:
              "K5d71eGSUGJDdmUJuF-Vk7J3S1GUB4rudr59UJdfjuFznEcEvmGC-myjWy2NBJLLX65zLpVwjspH1kcrlHOk9HaiSJ2amlZedrJElJLskvt3iFcEc6USCknWgXy8EBenS",
          reference:
              "K5d71eGSUGJDdmUJuF-Vk7J3S1GUB4rudr59UJdfjuFznEcEvmGC-myjWy2NBJLLX65zLpVwjspH1kcrlHOk9HaiSJ2amlZedrJElJLskvt3iFcEc6USCknWgXy8EBenS",
          structuredFormatting: const StructuredFormatting(
            mainText: "Thái Nguyên",
            secondaryText: "",
          ),
          terms: const [
            Term(offset: 0, value: "Thái Nguyên"),
          ],
          hasChildren: false,
          displayType: "expand0",
          score: 0,
          plusCode: const PlusCode(compoundCode: "", globalCode: ""),
        ),
        GoongLocation(
          description: "Huyện Trà Cú, Tỉnh Trà Vinh",
          matchedSubstrings: const [
            MatchedSubstring(length: 1, offset: 6),
            MatchedSubstring(length: 1, offset: 14),
            MatchedSubstring(length: 1, offset: 19),
          ],
          placeId:
              "Q1PR3M31_fZp-uKwodXmSkUq7fl-qR5_6pKlMW6tTtCNL3DWesWjhFWSqtiKxaJbyelODGq9QtONnqFxen1blV0qF2F-wauQ1e7pMWJp-mvOVgF8MrAxqmoqoVyeaDeHa",
          reference:
              "Q1PR3M31_fZp-uKwodXmSkUq7fl-qR5_6pKlMW6tTtCNL3DWesWjhFWSqtiKxaJbyelODGq9QtONnqFxen1blV0qF2F-wauQ1e7pMWJp-mvOVgF8MrAxqmoqoVyeaDeHa",
          structuredFormatting: const StructuredFormatting(
            mainText: "Huyện Trà Cú",
            secondaryText: "Tỉnh Trà Vinh",
          ),
          terms: const [
            Term(offset: 0, value: "Huyện Trà Cú"),
            Term(offset: 17, value: "Tỉnh Trà Vinh"),
          ],
          hasChildren: false,
          displayType: "expand0",
          score: 0,
          plusCode: const PlusCode(compoundCode: "", globalCode: ""),
        ),
        GoongLocation(
          description: "Tây Ninh",
          matchedSubstrings: const [
            MatchedSubstring(length: 1, offset: 0),
          ],
          placeId:
              "aopORqmKNktfrGgBsW6f32bJJTW6fbmjbe8pQm6TppZvkTBCRhq9xnGX9GC4GPGNbr39OIb5FkIxqyFKHpmyLKHO-IdamcJ_ka69ZTY9_j-ZrlUoZuRmfj2i9QoCPGDLP",
          reference:
              "aopORqmKNktfrGgBsW6f32bJJTW6fbmjbe8pQm6TppZvkTBCRhq9xnGX9GC4GPGNbr39OIb5FkIxqyFKHpmyLKHO-IdamcJ_ka69ZTY9_j-ZrlUoZuRmfj2i9QoCPGDLP",
          structuredFormatting: const StructuredFormatting(
            mainText: "Tây Ninh",
            secondaryText: "",
          ),
          terms: const [
            Term(offset: 0, value: "Tây Ninh"),
          ],
          hasChildren: false,
          displayType: "expand0",
          score: 0,
          plusCode: const PlusCode(compoundCode: "", globalCode: ""),
        ),
      ];
      final popular = [
        GoongLocation(
          description: "91 Trung Kính, Trung Hòa, Cầu Giấy, Hà Nội",
          matchedSubstrings: const [],
          placeId:
              "Hobn8WqBW6rsKtKq2PDrVKp4BJNRtiILxTQbB__muXgRB3v8GRDTfkp_6lc4cbLw/5PUgWrMDrSI/xlqDBt5XA==.ZXhwYW5kMA==",
          reference:
              "o/QzXNc_eBKsOWX6kdbOcABtO4zUQz0lzdK1jpi0R__J2vFKeRAM2VSYo38AfaShP/7qpUhrwc0l/t/AIYwRnQ==.ZXhwYW5kMA==",
          structuredFormatting: const StructuredFormatting(
            mainText: "91 Trung Kính",
            secondaryText: "Trung Hòa, Cầu Giấy, Hà Nội",
          ),
          terms: const [],
          hasChildren: false,
          displayType: "expand0",
          score: 633.7587,
          plusCode: const PlusCode(
            compoundCode: "+6DW1G Trung Hòa, Cầu Giấy, Hà Nội",
            globalCode: "LOC1+6DW1G",
          ),
        ),
        GoongLocation(
          description: "43/91 Trung Kính, Trung Hòa, Cầu Giấy, Hà Nội",
          matchedSubstrings: const [],
          placeId:
              "ytdKslLHBd1_mSnLu_bQHGu1yZyLeBt9haGgyFDN1EIOy7I9uEQyTmRkyNZL3BRpT_Knj31YK/Irv3KkEIIZqw==.ZXhwYW5kMA==",
          reference:
              "nP7fBjweFzWzkU8gq/ki_xEAF3fpVoZ3aQcfXx4ZRHX7QaQPNBPpNToMKx1KZw09gWUhpnSdXJSLowB4qFlCMg==.ZXhwYW5kMA==",
          structuredFormatting: const StructuredFormatting(
            mainText: "43/91 Trung Kính",
            secondaryText: "Trung Hòa, Cầu Giấy, Hà Nội",
          ),
          terms: const [],
          hasChildren: false,
          displayType: "expand0",
          score: 597.5509,
          plusCode: const PlusCode(
            compoundCode: "+63G73 Trung Hòa, Cầu Giấy, Hà Nội",
            globalCode: "LOC1+63G73",
          ),
        ),
        GoongLocation(
          description: "95 Trung Kính, Trung Hòa, Cầu Giấy, Hà Nội",
          matchedSubstrings: const [],
          placeId:
              "mUuwMwTPf5/1WFznDr94rtLvQffNhj1NzWQqDJqgsdUfCqTZdUcHTTav64BxPOC6dSdgZ9WUmwARwQlhmYonvA==.ZXhwYW5kMA==",
          reference:
              "lPHbKnLx64d2Ikp35RrFcdRphjayJn2rjapjNhjPuBmPxB9GzirgM6NT0OH65gG2Mf4qGswZXQ8d6U4XBfltjQ==.ZXhwYW5kMA==",
          structuredFormatting: const StructuredFormatting(
            mainText: "95 Trung Kính",
            secondaryText: "Trung Hòa, Cầu Giấy, Hà Nội",
          ),
          terms: const [],
          hasChildren: false,
          displayType: "expand0",
          score: 358.45456,
          plusCode: const PlusCode(
            compoundCode: "+6DW1M Trung Hòa, Cầu Giấy, Hà Nội",
            globalCode: "LOC1+6DW1M",
          ),
        ),
        GoongLocation(
          description: "93 Trung Kính, Trung Hòa, Cầu Giấy, Hà Nội",
          matchedSubstrings: const [],
          placeId:
              "xFchTd18UNmq7/rWipBrI6LtqEcDdReZ8cGV3mxeK4yxmmL7hZat/i8cLBdGhdaeNYFQLk4H5AuP2ntIHfS7EQ==.ZXhwYW5kMA==",
          reference:
              "dMG3Lmo6Rux8NsEd9lwoDGUOH22aZbMdzDiMy1RhS73mM/uA0rZsX2M0y0Wm990nx4PGw1jd54YkUeqLzySwaQ==.ZXhwYW5kMA==",
          structuredFormatting: const StructuredFormatting(
            mainText: "93 Trung Kính",
            secondaryText: "Trung Hòa, Cầu Giấy, Hà Nội",
          ),
          terms: const [],
          hasChildren: false,
          displayType: "expand0",
          score: 358.1594,
          plusCode: const PlusCode(
            compoundCode: "+6DW1I Trung Hòa, Cầu Giấy, Hà Nội",
            globalCode: "LOC1+6DW1I",
          ),
        ),
        GoongLocation(
          description: "89 Trung Kính, Trung Hòa, Cầu Giấy, Hà Nội",
          matchedSubstrings: const [],
          placeId:
              "OTzyxbl3DUoqV90GZW8D_2FCVMaEizDWVmAhzTc2d8KmYL/h2cPpfE97BmSabHzliRz3GSgjXWVRxI0bZMxqew==.ZXhwYW5kMA==",
          reference:
              "7ESn5kbjYSJJfOstrAkpIRG26bEQi1atPuZKWKyymY9Q7raTcScHyAFeWejvoiu_aa46E/IYxOvOPsmkZgYfOQ==.ZXhwYW5kMA==",
          structuredFormatting: const StructuredFormatting(
            mainText: "89 Trung Kính",
            secondaryText: "Trung Hòa, Cầu Giấy, Hà Nội",
          ),
          terms: const [],
          hasChildren: false,
          displayType: "expand0",
          score: 358.14783,
          plusCode: const PlusCode(
            compoundCode: "+6DW1E Trung Hòa, Cầu Giấy, Hà Nội",
            globalCode: "LOC1+6DW1E",
          ),
        ),
      ];

      final recent = [
        GoongLocation(
          description: "93 Trung Kính, Trung Hòa, Cầu Giấy, Hà Nội",
          matchedSubstrings: const [],
          placeId:
              "xFchTd18UNmq7/rWipBrI6LtqEcDdReZ8cGV3mxeK4yxmmL7hZat/i8cLBdGhdaeNYFQLk4H5AuP2ntIHfS7EQ==.ZXhwYW5kMA==",
          reference:
              "dMG3Lmo6Rux8NsEd9lwoDGUOH22aZbMdzDiMy1RhS73mM/uA0rZsX2M0y0Wm990nx4PGw1jd54YkUeqLzySwaQ==.ZXhwYW5kMA==",
          structuredFormatting: const StructuredFormatting(
            mainText: "93 Trung Kính",
            secondaryText: "Trung Hòa, Cầu Giấy, Hà Nội",
          ),
          terms: const [],
          hasChildren: false,
          displayType: "expand0",
          score: 358.1594,
          plusCode: const PlusCode(
            compoundCode: "+6DW1I Trung Hòa, Cầu Giấy, Hà Nội",
            globalCode: "LOC1+6DW1I",
          ),
        ),
        GoongLocation(
          description: "89 Trung Kính, Trung Hòa, Cầu Giấy, Hà Nội",
          matchedSubstrings: const [],
          placeId:
              "OTzyxbl3DUoqV90GZW8D_2FCVMaEizDWVmAhzTc2d8KmYL/h2cPpfE97BmSabHzliRz3GSgjXWVRxI0bZMxqew==.ZXhwYW5kMA==",
          reference:
              "7ESn5kbjYSJJfOstrAkpIRG26bEQi1atPuZKWKyymY9Q7raTcScHyAFeWejvoiu_aa46E/IYxOvOPsmkZgYfOQ==.ZXhwYW5kMA==",
          structuredFormatting: const StructuredFormatting(
            mainText: "89 Trung Kính",
            secondaryText: "Trung Hòa, Cầu Giấy, Hà Nội",
          ),
          terms: const [],
          hasChildren: false,
          displayType: "expand0",
          score: 358.14783,
          plusCode: const PlusCode(
            compoundCode: "+6DW1E Trung Hòa, Cầu Giấy, Hà Nội",
            globalCode: "LOC1+6DW1E",
          ),
        ),
      ];
      final pickup = await SharePreferenceUtil.getCurrentPickup();
      final dropOff = await SharePreferenceUtil.getCurrentDropOff();
      final home = await SharePreferenceUtil.getHomeAddress();
      final work = await SharePreferenceUtil.getWorkAddress();
      print("pickup tu shared: ${pickup?.toJson()}");
      print("dropOff tu shared: ${dropOff?.toJson()}");
      print("home tu shared: ${home?.toJson()}");
      print("work tu shared: ${work?.toJson()}");
      if (pickup != null && dropOff != null) {
        print("KHoi tao destination thanh cong $dropOff");
        emit(SearchDestinationLoaded(
          popularDestinations: locations,
          recentSearches: locations,
          pickupLocation: pickup,
          destinationLocation: dropOff,
          pickupPlaceId: pickup.placeId,
          destinationPlaceId: dropOff.placeId,
          homeLocation: home,
          workLocation: work,
        ));
      } else {
        emit(SearchDestinationLoaded(
          popularDestinations: locations,
          recentSearches: locations,
          pickupLocation: null,
          destinationLocation: null,
          homeLocation: home,
          workLocation: work,
        ));
      }
    } catch (e) {
      emit(SearchDestinationError("Không thể tải dữ liệu ${e}"));
    }
  }

  Future<void> _onSearchQueryChanged(SearchQueryChangedEvent event,
      Emitter<SearchDestinationState> emit) async {
    if (state is! SearchDestinationLoaded) return;
    final currentState = state as SearchDestinationLoaded;

    final query = event.query.trim();

    if (query.isEmpty) {
      // Nếu rỗng, hiển thị lại lịch sử/gợi ý
      emit(currentState.copyWith(
        isSearching: false,
        searchResults: [],
      ));
      return;
    }

    // Đánh dấu đang tìm kiếm
    emit(currentState.copyWith(isSearching: true));

    // Gọi API từ GoongRepository
    final goongRepo = GoongRepository();
    // TODO: Truyền thêm vĩ độ kinh độ nếu cần ưu tiên vị trí người dùng
    final (success, locations) = await goongRepo.getAutocompletePlaces(
      input: query,
      limit: 10,
    );

    if (success) {
      emit(currentState.copyWith(
        isSearching: true,
        searchResults: locations,
      ));
    } else {
      // Lỗi hoặc rỗng
      emit(currentState.copyWith(
        isSearching: true,
        searchResults: [],
      ));
    }
  }

  void _onSaveLocation(
      SaveLocationEvent event, Emitter<SearchDestinationState> emit) {
    // TODO: Lưu vào danh sách yêu thích
    print("Saved location: ${event.locationId}");
  }

  // ============================================================
  // Lấy vị trí GPS hiện tại + Reverse Geocoding → địa chỉ text
  // ============================================================

  Future<void> _onFetchCurrentLocation(FetchCurrentLocationEvent event,
      Emitter<SearchDestinationState> emit) async {
    if (state is! SearchDestinationLoaded) return;
    final current = state as SearchDestinationLoaded;

    // Hiển thị loading spinner trên nút
    emit(current.copyWith(isLoadingLocation: true));

    try {
      // 1. Kiểm tra location service
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(current.copyWith(
          isLoadingLocation: false,
          currentLocation: "Vui lòng bật GPS",
        ));
        return;
      }

      // 2. Kiểm tra quyền
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        emit(current.copyWith(
          isLoadingLocation: false,
          currentLocation: "Không có quyền truy cập vị trí",
        ));
        return;
      }

      // 3. Lấy tọa độ hiện tại
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      print("📍 GPS: ${position.latitude}, ${position.longitude}");

      // 4. Reverse geocoding → tên địa chỉ
      String addressText = "${position.latitude.toStringAsFixed(5)}, "
          "${position.longitude.toStringAsFixed(5)}";

      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          final parts = <String>[
            if (p.street?.isNotEmpty == true) p.street!,
            if (p.subAdministrativeArea?.isNotEmpty == true)
              p.subAdministrativeArea!,
            if (p.administrativeArea?.isNotEmpty == true) p.administrativeArea!,
          ];
          if (parts.isNotEmpty) {
            addressText = parts.join(", ");
          }
        }
      } catch (geoError) {
        print("⚠️ Geocoding error (dùng tọa độ thô): $geoError");
      }
      await SharePreferenceUtil.saveCurrentPickup(GoongPlaceDetail(
        name: addressText,
        geometry: GoongGeometry(
          location: GoongLocationCoords(
            lat: position.latitude,
            lng: position.longitude,
          ),
        ),
        placeId: 'didGetFromGPS',
        formattedAddress: addressText,
      ));

      emit(current.copyWith(
        isLoadingLocation: false,
        currentLocation: addressText,
        pickupLocation: GoongPlaceDetail(
          name: addressText,
          geometry: GoongGeometry(
            location: GoongLocationCoords(
              lat: position.latitude,
              lng: position.longitude,
            ),
          ),
          placeId: 'didGetFromGPS',
          formattedAddress: addressText,
        ),
      ));
    } catch (e, st) {
      print("❌ FetchCurrentLocation error: $e\n$st");
      emit(current.copyWith(
        isLoadingLocation: false,
        currentLocation: "Không thể lấy vị trí",
      ));
    }
  }

  void _onSavePickupLocation(
      SavePickupLocationEvent event, Emitter<SearchDestinationState> emit) {
    emit((state as SearchDestinationLoaded).copyWith(
      pickupLocation: event.pickupLocation,
    ));
  }

  void _onSaveDestinationLocation(SaveDestinationLocationEvent event,
      Emitter<SearchDestinationState> emit) {
    emit((state as SearchDestinationLoaded).copyWith(
      destinationLocation: event.destinationLocation,
    ));
  }

  Future<void> _onSavePickupPlaceId(SavePickupPlaceIdEvent event,
      Emitter<SearchDestinationState> emit) async {
    print("emit pickupPlaceId: ${event.pickupPlaceId}");
    print("pickupPlaceId: ${event.pickupPlaceId}");
    final (success, locations) = await GoongRepository().getPlaceDetail(
      placeId: event.pickupPlaceId,
    );
    if (success && locations != null) {
      SharePreferenceUtil.saveCurrentPickup(locations);
    }
    emit((state as SearchDestinationLoaded).copyWith(
      pickupPlaceId: event.pickupPlaceId,
    ));
  }

  Future<void> _onSaveDestinationPlaceId(SaveDestinationPlaceIdEvent event,
      Emitter<SearchDestinationState> emit) async {
    print("emit destinationPlaceId: ${event.destinationPlaceId}");
    print("pickupPlaceId: ${event.destinationPlaceId}");

    try {
      final (success, locations) = await GoongRepository().getPlaceDetail(
        placeId: event.destinationPlaceId,
      );
      if (success && locations != null) {
        SharePreferenceUtil.saveCurrentDropOff(locations);
      }
      emit((state as SearchDestinationLoaded).copyWith(
        destinationPlaceId: event.destinationPlaceId,
      ));
    } catch (e) {}
  }

  Future<void> _onSubmitSearch(
      SubmitSearchEvent event, Emitter<SearchDestinationState> emit) async {
    print("search goi submit");
    if (state is! SearchDestinationLoaded) {
      print("state k la SearchDestinationLoaded");
      return;
    }
    final current = state as SearchDestinationLoaded;
    GoongPlaceDetail? pickupLocation = current.pickupLocation;
    GoongPlaceDetail? destinationLocation = current.destinationLocation;
    if (current.pickupPlaceId != null &&
        current.pickupPlaceId != 'didGetFromGPS') {
      final (success, locations) = await GoongRepository().getPlaceDetail(
        placeId: current.pickupPlaceId!,
      );
      if (success && locations != null) {
        pickupLocation = locations;
      }
    }
    if (current.destinationPlaceId != null &&
        current.destinationPlaceId != 'didGetFromGPS') {
      final (success, locations) = await GoongRepository().getPlaceDetail(
        placeId: current.destinationPlaceId!,
      );
      if (success && locations != null) {
        print("goi api false");
        destinationLocation = locations;
      }
    }
    if (pickupLocation == null || destinationLocation == null) {
      print("pickupLocation hoac destinationLocation la null");
      print("pickupLocation: $pickupLocation");
      print("destinationLocation: $destinationLocation");
      emit(current.copyWith(
        submitMessage: "Vui lòng nhập địa chỉ hợp lệ",
      ));
      return;
    }
    print("pickupLocation: ${pickupLocation.name}");
    print("destinationLocation: ${destinationLocation.name}");
    await SharePreferenceUtil.saveCurrentDropOff(destinationLocation);
    await SharePreferenceUtil.saveCurrentPickup(pickupLocation);
    print(" emit submit push booking");
    event.onSuccess(pickupLocation, destinationLocation);
    // emit(SearchDestinationSubmit(
    //   pickupLocation: pickupLocation,
    //   destinationLocation: destinationLocation,
    // ));
  }
}
