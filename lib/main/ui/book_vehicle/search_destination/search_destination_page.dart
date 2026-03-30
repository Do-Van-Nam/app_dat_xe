import 'package:demo_app/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_destination_bloc.dart';

class SearchDestinationPage extends StatelessWidget {
  const SearchDestinationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => SearchDestinationBloc()..add(LoadSearchDataEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.searchDestination),
          leading: const BackButton(),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<SearchDestinationBloc, SearchDestinationState>(
          builder: (context, state) {
            if (state is SearchDestinationLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is SearchDestinationError) {
              return Center(child: Text(state.message));
            }

            if (state is SearchDestinationLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Search Inputs Section
                    _SearchInputsSection(l10n: l10n),

                    const SizedBox(height: 24),

                    // 2. Quick Add Buttons
                    _QuickAddButtons(l10n: l10n),

                    const SizedBox(height: 32),

                    // 3. Popular Destinations
                    _PopularDestinationsSection(
                      destinations: state.popularDestinations,
                      l10n: l10n,
                    ),

                    const SizedBox(height: 40),

                    // 4. Recent Searches
                    _RecentSearchesSection(
                      searches: state.recentSearches,
                      l10n: l10n,
                    ),

                    const SizedBox(height: 32),

                    // 5. Map Section
                    _MapSection(l10n: l10n),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.home), label: l10n.home),
            BottomNavigationBarItem(
                icon: const Icon(Icons.article), label: l10n.activity),
            BottomNavigationBarItem(
                icon: const Icon(Icons.person), label: l10n.profile),
          ],
        ),
      ),
    );
  }
}

// ==================== WIDGETS DÙNG CHUNG ====================

class _SearchInputsSection extends StatelessWidget {
  final AppLocalizations l10n;

  const _SearchInputsSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Vị trí hiện tại
        TextField(
          decoration: InputDecoration(
            hintText: l10n.yourLocation,
            prefixIcon: const Icon(Icons.location_on, color: Colors.blue),
            suffixIcon: const Icon(Icons.my_location, color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey[100],
          ),
          enabled: false,
        ),
        const SizedBox(height: 12),

        // Điểm đến
        TextField(
          decoration: InputDecoration(
            hintText: l10n.whereToGo,
            prefixIcon: const Icon(Icons.location_on, color: Colors.orange),
            suffixIcon: const Icon(Icons.map, color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (value) {
            context
                .read<SearchDestinationBloc>()
                .add(SearchQueryChangedEvent(value));
          },
        ),
      ],
    );
  }
}

class _QuickAddButtons extends StatelessWidget {
  final AppLocalizations l10n;

  const _QuickAddButtons({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QuickAddChip(icon: Icons.home, label: l10n.addHome, onTap: () {}),
        const SizedBox(width: 8),
        _QuickAddChip(
            icon: Icons.business, label: l10n.addCompany, onTap: () {}),
        const SizedBox(width: 8),
        _QuickAddChip(
            icon: Icons.favorite, label: l10n.addFavorite, onTap: () {}),
      ],
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
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PopularDestinationsSection extends StatelessWidget {
  final List<PopularDestination> destinations;
  final AppLocalizations l10n;

  const _PopularDestinationsSection({
    required this.destinations,
    required this.l10n,
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
                  color: Colors.blue, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...destinations.map((dest) => _DestinationItem(
              destination: dest,
              isPopular: true,
            )),
      ],
    );
  }
}

class _RecentSearchesSection extends StatelessWidget {
  final List<RecentSearch> searches;
  final AppLocalizations l10n;

  const _RecentSearchesSection({
    required this.searches,
    required this.l10n,
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
        ...searches.map((search) => _DestinationItem(
              destination: PopularDestination(
                id: search.id,
                name: search.name,
                distance: "",
                address: search.address,
              ),
              isPopular: false,
            )),
      ],
    );
  }
}

class _DestinationItem extends StatelessWidget {
  final PopularDestination destination;
  final bool isPopular;

  const _DestinationItem({
    required this.destination,
    required this.isPopular,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.grey[100],
        child: Icon(
          isPopular ? Icons.location_on : Icons.history,
          color: isPopular ? Colors.red : Colors.grey,
        ),
      ),
      title: Text(
        destination.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        destination.distance.isNotEmpty
            ? "${destination.distance} • ${destination.address}"
            : destination.address,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.bookmark_border),
        onPressed: () {
          // Save to favorite
        },
      ),
    );
  }
}

class _MapSection extends StatelessWidget {
  final AppLocalizations l10n;

  const _MapSection({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.blue, size: 18),
            const SizedBox(width: 6),
            Text(
              "VỊ TRÍ HIỆN TẠI\nThành phố Hồ Chí Minh",
              style: const TextStyle(fontSize: 13, height: 1.3),
            ),
          ],
        ),
      ],
    );
  }
}
