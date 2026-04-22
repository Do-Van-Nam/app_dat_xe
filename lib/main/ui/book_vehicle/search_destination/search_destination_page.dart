import 'dart:math';

import 'package:demo_app/core/app_export.dart';
import 'package:demo_app/generated/app_localizations.dart';
import 'package:demo_app/main/data/repository/goong_repository.dart';
import 'package:demo_app/main/data/share_preference/share_preference.dart';
import 'package:demo_app/main/utils/widget/textfield_widgets.dart';
import 'package:demo_app/res/app_colors.dart';
import 'package:demo_app/res/app_fonts.dart';
import 'package:demo_app/res/app_images.dart';
import 'package:demo_app/res/app_styles.dart';
import 'package:demo_app/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:demo_app/main/data/model/goong/location.dart';
import 'search_destination_bloc.dart';

class SearchDestinationPage extends StatefulWidget {
  const SearchDestinationPage({super.key});

  @override
  State<SearchDestinationPage> createState() => _SearchDestinationPageState();
}

class _SearchDestinationPageState extends State<SearchDestinationPage> {
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _pickUpController = TextEditingController();
  final FocusNode _destinationFocus = FocusNode();
  final FocusNode _pickUpFocus = FocusNode();
  @override
  void initState() {
    super.initState();
    _loadInitialDataFromSharedPreferences();
  }

  Future<void> _loadInitialDataFromSharedPreferences() async {
    try {
      // Lấy dữ liệu từ SharedPreferences
      final pickup = await SharePreferenceUtil.getCurrentPickup();
      final dropOff = await SharePreferenceUtil.getCurrentDropOff();

      // Gán vào controller (chỉ gán nếu có dữ liệu)
      if (pickup != null) {
        _pickUpController.text = pickup.formattedAddress;
      }

      if (dropOff != null) {
        _destinationController.text = dropOff.formattedAddress;
      }

      print("✅ Đã load dữ liệu ban đầu từ SharedPreferences");
      print("Pickup: ${pickup ?? 'null'}");
      print("DropOff: ${dropOff ?? 'null'}");
    } catch (e) {
      print("❌ Lỗi khi load dữ liệu từ SharedPreferences: $e");
    }
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _pickUpController.dispose();
    _destinationFocus.dispose();
    _pickUpFocus.dispose();
    super.dispose();
  }

  void _onSelectDestination(dynamic dest, BuildContext context) {
    String address = "";
    if (dest is GoongLocation) {
      print("dest la goonglocation");
      address = dest.description;
    }

    if (_pickUpFocus.hasFocus) {
      _pickUpController.text = address;
      context
          .read<SearchDestinationBloc>()
          .add(SavePickupPlaceIdEvent(dest.placeId));
      // context.read<SearchDestinationBloc>().add(SavePickupLocationEvent(dest));
    } else {
      _destinationController.text = address;
      context
          .read<SearchDestinationBloc>()
          .add(SaveDestinationPlaceIdEvent(dest.placeId));
      // context
      //     .read<SearchDestinationBloc>()
      //     .add(SaveDestinationLocationEvent(dest));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (_) => SearchDestinationBloc()..add(LoadSearchDataEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.searchDestination),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              print("xoa va back");
              await SharePreferenceUtil.saveCurrentPickup(null);
              await SharePreferenceUtil.saveCurrentDropOff(null);
              context.go(PATH_HOME);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocConsumer<SearchDestinationBloc, SearchDestinationState>(
          listenWhen: (previous, current) {
            if (previous is SearchDestinationLoaded &&
                current is SearchDestinationLoaded) {
              return previous.currentLocation != current.currentLocation;
            }
            return current is SearchDestinationLoaded ||
                current is SearchDestinationSubmit;
          },
          // Cập nhật pickUpController mỗi khi currentLocation thay đổi
          listener: (context, state) async {
            if (state is SearchDestinationLoaded &&
                !state.isLoadingLocation &&
                state.currentLocation != "Vị trí của bạn") {
              _pickUpController.text = state.currentLocation;
            }
            if (state is SearchDestinationSubmit) {
              print("push booking");
              // final result = await context.push(
              //     "$PATH_BOOKING?${DateTime.now().millisecondsSinceEpoch}",
              //     extra: {
              //       "pickUp": state.pickupLocation,
              //       "dropOff": state.destinationLocation,
              //     });
              // if (result != null) {
              //   context
              //       .read<SearchDestinationBloc>()
              //       .add(LoadSearchDataEvent());
              // }
              context.go(
                "$PATH_BOOKING?${Random().nextInt(1000000) + DateTime.now().millisecondsSinceEpoch}",
                extra: {
                  "pickUp": state.pickupLocation,
                  "dropOff": state.destinationLocation,
                },
              );
            }
          },
          builder: (context, state) {
            if (state is SearchDestinationLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SearchDestinationError) {
              return Center(child: Text(state.message));
            }

            if (state is SearchDestinationLoaded) {
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Search Inputs Section
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.color_F3F3F6,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                _SearchInputsSection(
                                  l10n: l10n,
                                  destinationController: _destinationController,
                                  pickUpController: _pickUpController,
                                  destinationFocus: _destinationFocus,
                                  pickUpFocus: _pickUpFocus,
                                  isLoadingLocation: state.isLoadingLocation,
                                ),

                                const SizedBox(height: 24),

                                // 2. Quick Add Buttons
                                _QuickAddButtons(
                                  l10n: l10n,
                                  state: state,
                                  onSelected: _onSelectDestination,
                                  context: context,
                                ),
                              ],
                            ),
                          ),

                          if (state.isSearching) ...[
                            const SizedBox(height: 32),
                            _SearchResultsSection(
                              results: state.searchResults,
                              l10n: l10n,
                              onSelect: (dest) =>
                                  _onSelectDestination(dest, context),
                            ),
                          ] else ...[
                            const SizedBox(height: 32),
                            // 3. Popular Destinations
                            _PopularDestinationsSection(
                              destinations: state.popularDestinations,
                              l10n: l10n,
                              onSelect: (dest) =>
                                  _onSelectDestination(dest, context),

                              // (dest) =>

                              // _onSelectDestination(dest, context),
                            ),
                            const SizedBox(height: 40),
                            // 4. Recent Searches
                            _RecentSearchesSection(
                              searches: state.recentSearches,
                              l10n: l10n,
                              onSelect: (dest) =>
                                  _onSelectDestination(dest, context),

                              // (dest) => _onSelectDestination(dest, context),
                            ),
                            const SizedBox(height: 32),
                            // 5. Map Section
                            _MapSection(l10n: l10n),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: commonButton(
                        text: "Xác nhận đặt xe",
                        onPressed: () {
                          context.read<SearchDestinationBloc>().add(
                                SubmitSearchEvent(
                                  pickupPlaceId: state.pickupPlaceId ?? '',
                                  destinationPlaceId:
                                      state.destinationPlaceId ?? '',
                                  onSuccess:
                                      (pickupLocation, destinationLocation) {
                                    context.push(
                                      PATH_BOOKING,
                                      extra: {
                                        'pickUp': pickupLocation,
                                        'dropOff': destinationLocation,
                                      },
                                    );
                                  },
                                ),
                              );
                        }),
                  )
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

// ==================== WIDGETS DÙNG CHUNG ====================

class _SearchInputsSection extends StatelessWidget {
  final AppLocalizations l10n;
  final TextEditingController destinationController;
  final TextEditingController pickUpController;
  final FocusNode destinationFocus;
  final FocusNode pickUpFocus;
  final bool isLoadingLocation;

  const _SearchInputsSection({
    required this.l10n,
    required this.destinationController,
    required this.pickUpController,
    required this.destinationFocus,
    required this.pickUpFocus,
    this.isLoadingLocation = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // ── Dấu chấm + đường kẻ dọc ────────────────────────────────
          Column(
            children: [
              const SizedBox(height: 24),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.colorMain,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const Expanded(
                child: VerticalDivider(
                  color: AppColors.color_C3C6D5,
                  thickness: 1.5,
                  width: 1,
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
          const SizedBox(width: 12),

          // ── 2 AutocompleteTextField ────────────────────────────────
          Expanded(
            child: Column(
              children: [
                // ── Trường vị trí hiện tại ──────────────────────────
                AutocompleteTextField<GoongLocation>(
                  controller: pickUpController,
                  focusNode: pickUpFocus,
                  hintText: l10n.yourLocation,
                  backgroundColor: Colors.white,
                  fetchSuggestions: (input) async {
                    final (ok, list) = await GoongRepository()
                        .getAutocompletePlaces(input: input);
                    return ok ? list : [];
                  },
                  itemBuilder: (context, location) =>
                      _locationSuggestionTile(location),
                  onSelected: (location) {
                    pickUpController.text = location.description;
                    context
                        .read<SearchDestinationBloc>()
                        .add(SavePickupPlaceIdEvent(location.placeId));
                  },
                  // Nút GPS luôn hiển thị (persistentTrailingWidget)
                  persistentTrailingWidget: GestureDetector(
                    onTap: isLoadingLocation
                        ? null
                        : () => context
                            .read<SearchDestinationBloc>()
                            .add(FetchCurrentLocationEvent()),
                    child: Tooltip(
                      message: 'Lấy vị trí hiện tại',
                      child: isLoadingLocation
                          ? const Padding(
                              padding: EdgeInsets.all(10),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.blue,
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.my_location,
                              color: Colors.blue,
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ── Trường điểm đến ─────────────────────────────────
                AutocompleteTextField<GoongLocation>(
                  controller: destinationController,
                  focusNode: destinationFocus,
                  hintText: l10n.whereToGo,
                  backgroundColor: Colors.white,
                  suffixIcon: const Icon(Icons.map, color: Colors.orange),
                  fetchSuggestions: (input) async {
                    final (ok, list) = await GoongRepository()
                        .getAutocompletePlaces(input: input);
                    return ok ? list : [];
                  },
                  itemBuilder: (context, location) =>
                      _locationSuggestionTile(location),
                  onSelected: (location) {
                    destinationController.text = location.description;
                    context
                        .read<SearchDestinationBloc>()
                        .add(SaveDestinationPlaceIdEvent(location.placeId));
                  },
                  // Giữ nguyên logic nhấn Enter → submit booking
                  onSubmitted: (_) {
                    final state = context.read<SearchDestinationBloc>().state;
                    if (state is SearchDestinationLoaded) {
                      context.read<SearchDestinationBloc>().add(
                            SubmitSearchEvent(
                              pickupPlaceId: state.pickupPlaceId ?? '',
                              destinationPlaceId:
                                  state.destinationPlaceId ?? '',
                              onSuccess: (pickupLocation, destinationLocation) {
                                context.push(
                                  PATH_BOOKING,
                                  extra: {
                                    'pickUp': pickupLocation,
                                    'dropOff': destinationLocation,
                                  },
                                );
                              },
                            ),
                          );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Render 1 item gợi ý địa điểm trong dropdown.
  Widget _locationSuggestionTile(GoongLocation location) {
    final mainText = location.structuredFormatting.mainText.isNotEmpty
        ? location.structuredFormatting.mainText
        : location.description;
    final subText = location.structuredFormatting.secondaryText;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.color_E8E8EA,
            child: const Icon(
              Icons.location_on_outlined,
              color: Colors.grey,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  mainText,
                  style: AppTextFonts.poppinsMedium.copyWith(
                    fontSize: 14,
                    color: AppColors.color_1618,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subText.isNotEmpty)
                  Text(
                    subText,
                    style: AppTextFonts.poppinsRegular.copyWith(
                      fontSize: 12,
                      color: AppColors.color_8588,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAddButtons extends StatelessWidget {
  final AppLocalizations l10n;
  final SearchDestinationLoaded state;
  final onSelected;
  final BuildContext context;

  const _QuickAddButtons(
      {required this.l10n,
      required this.state,
      required this.onSelected,
      required this.context});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (state.homeLocation != null)
            _QuickAddChip(
                icon: Icons.home,
                label: "Nhà: ${state.homeLocation!.description}",
                onTap: () => onSelected(state.homeLocation!, context)),
          const SizedBox(width: 8),
          if (state.workLocation != null)
            _QuickAddChip(
                icon: Icons.business,
                label: "Công ty: ${state.workLocation!.description}",
                onTap: () => onSelected(state.workLocation!, context)),
          // const SizedBox(width: 8),
          // _QuickAddChip(
          //     icon: Icons.location_pin, label: l10n.addFavorite, onTap: () {}),
        ],
      ),
    );
  }
}

class _QuickAddChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAddChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.color_E2E2E5,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 6),
            Text(label, style: AppStyles.inter14Medium),
          ],
        ),
      ),
    );
  }
}

class _PopularDestinationsSection extends StatelessWidget {
  final List<GoongLocation> destinations;
  final AppLocalizations l10n;
  final Function(GoongLocation) onSelect;

  const _PopularDestinationsSection({
    required this.destinations,
    required this.l10n,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.popularDestinations,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              l10n.viewMore,
              style: const TextStyle(
                  color: AppColors.colorMain, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...destinations.map((dest) => _DestinationItem(
              destination: dest,
              isPopular: true,
              onTap: () => onSelect(dest),
            )),
      ],
    );
  }
}

class _RecentSearchesSection extends StatelessWidget {
  final List<GoongLocation> searches;
  final AppLocalizations l10n;
  final Function(GoongLocation) onSelect;

  const _RecentSearchesSection({
    required this.searches,
    required this.l10n,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.recentSearches,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...searches.map((search) {
          return _DestinationItem(
            destination: search,
            isPopular: false,
            onTap: () => onSelect(search),
          );
        }),
      ],
    );
  }
}

class _DestinationItem extends StatelessWidget {
  final GoongLocation destination;
  final bool isPopular;
  final VoidCallback onTap;

  const _DestinationItem({
    required this.destination,
    required this.isPopular,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppColors.color_E8E8EA,
        child: SvgPicture.asset(
          AppImages.icHistory,
        ),
      ),
      title: Text(
        destination.description,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        destination.structuredFormatting.secondaryText,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _MapSection extends StatelessWidget {
  final AppLocalizations l10n;

  const _MapSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            "https://picsum.photos/id/1015/600/200", // Map image
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "VỊ TRÍ HIỆN TẠI\nThành phố Hồ Chí Minh",
            style: AppStyles.inter14Medium.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _SearchResultsSection extends StatelessWidget {
  final List<GoongLocation> results;
  final AppLocalizations l10n;
  final Function(dynamic) onSelect;

  const _SearchResultsSection({
    required this.results,
    required this.l10n,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            "Không tìm thấy kết quả",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Kết quả tìm kiếm",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...results.map((loc) {
          return ListTile(
            onTap: () => onSelect(loc),
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(
              backgroundColor: AppColors.color_E8E8EA,
              child: Icon(Icons.location_on, color: Colors.grey),
            ),
            title: Text(
              loc.structuredFormatting.mainText.isNotEmpty
                  ? loc.structuredFormatting.mainText
                  : loc.description,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: loc.structuredFormatting.secondaryText.isNotEmpty
                ? Text(loc.structuredFormatting.secondaryText,
                    maxLines: 2, overflow: TextOverflow.ellipsis)
                : null,
          );
        }),
      ],
    );
  }
}
