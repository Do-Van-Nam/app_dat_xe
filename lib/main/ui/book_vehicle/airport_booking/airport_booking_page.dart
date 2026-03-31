import 'package:demo_app/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'airport_booking_bloc.dart';
import 'airport_booking_event.dart';
import 'airport_booking_state.dart';

class AirportBookingPage extends StatelessWidget {
  const AirportBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => AirportBookingBloc()..add(LoadDataEvent()),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _Header(),
              _TripTypeSection(),
              _AirportSuggestionSection(),
              _CarListSection(),
              _BottomButton(),
              _BottomNav(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.arrow_back),
          SizedBox(width: 12),
          Text(
            l10n.airportBooking,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Icon(Icons.notifications_outlined),
        ],
      ),
    );
  }
}

class _TripTypeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AirportBookingBloc, AirportBookingState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              _TripButton(
                title: l10n.toAirport,
                selected: state.isToAirport,
                onTap: () => context
                    .read<AirportBookingBloc>()
                    .add(SelectTripTypeEvent(true)),
              ),
              _TripButton(
                title: l10n.fromAirport,
                selected: !state.isToAirport,
                onTap: () => context
                    .read<AirportBookingBloc>()
                    .add(SelectTripTypeEvent(false)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AirportSuggestionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(l10n.nearestAirport),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _AirportCard(
                title: l10n.tanSonNhat,
                subtitle: "8.2 km • TP.HCM",
              ),
            ),
            Expanded(
              child: _AirportCard(
                title: l10n.longThanh,
                subtitle: l10n.comingSoon,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CarListSection extends StatelessWidget {
  final cars = [
    {"title": "Taxi sân bay", "price": "245.000đ"},
    {"title": "Xe 4 chỗ Riêng", "price": "280.000đ"},
    {"title": "Xe 7 chỗ SUV", "price": "350.000đ"},
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<AirportBookingBloc, AirportBookingState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (_, index) {
              final car = cars[index];

              return CarItem(
                title: car["title"]!,
                price: car["price"]!,
                selected: state.selectedCarIndex == index,
                onTap: () => context
                    .read<AirportBookingBloc>()
                    .add(SelectCarEvent(index)),
              );
            },
          );
        },
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {},
        child: Text(l10n.bookNow),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: l10n.home),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: l10n.activity),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: l10n.profile),
      ],
    );
  }
}

class _TripButton extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _TripButton({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(color: selected ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

class _AirportCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _AirportCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.flight),
          SizedBox(height: 8),
          Text(title),
          Text(subtitle),
        ],
      ),
    );
  }
}

class CarItem extends StatelessWidget {
  final String title;
  final String price;
  final bool selected;
  final VoidCallback onTap;

  const CarItem({
    required this.title,
    required this.price,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border:
              Border.all(color: selected ? Colors.blue : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(width: 60, height: 60, color: Colors.grey),
            SizedBox(width: 12),
            Expanded(child: Text(title)),
            Text(price),
          ],
        ),
      ),
    );
  }
}
