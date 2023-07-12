import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_assistant/src/common_widgets/async_value_widget.dart';
import 'package:weather_assistant/src/constants/app_sizes.dart';
import 'package:weather_assistant/src/features/authentication/data/auth_repository.dart';
import 'package:weather_assistant/src/features/locations/data/firestore/location_firestore_repository.dart';
import 'package:weather_assistant/src/features/locations/data/http/nominatim_place_repository.dart';
import 'package:weather_assistant/src/features/locations/domain/location/location.dart';
import 'package:weather_assistant/src/features/locations/domain/place/place.dart';
import 'package:weather_assistant/src/features/locations/presentation/widget/location_card.dart';
import 'package:weather_assistant/src/features/locations/presentation/widget/location_header.dart';
import 'package:weather_assistant/src/features/locations/presentation/widget/place_search_item.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final ValueNotifier<bool> _isEditing = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _isSearching = ValueNotifier<bool>(false);
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isEditing.addListener(() {
      _isSearching.value = !_isEditing.value;
      if (!_isEditing.value) {
        searchController.clear();
      }
      setState(() {});
    });

    _isSearching.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _isEditing.dispose();
    searchController.dispose();
    _isSearching.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(Sizes.p20, Sizes.p24),
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.only(left: Sizes.p16),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {
              context.pop();
            },
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: Sizes.p16),
            child: IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.black,
              ),
              onPressed: () {
                context.go('/');
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: Sizes.p24,
          left: Sizes.p24,
          right: Sizes.p24,
        ),
        child: Column(
          children: [
            LocationHeader(
              isWriting: _isEditing,
              isSearching: _isSearching,
              searchController: searchController,
            ),
            const SizedBox(height: Sizes.p16),
            Visibility(
                visible: _isEditing.value,
                child: Expanded(
                  child: Consumer(builder: (context, ref, child) {
                    if (!_isSearching.value) {
                      return const SizedBox();
                    }
                    final places = ref
                        .watch(placesListFutureProvider(searchController.text));

                    return AsyncValueWidget<List<Place>>(
                      value: places,
                      data: (places) => ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: places.length,
                        itemBuilder: (context, index) {
                          return PlaceSearchItem(
                            isEditing: _isEditing,
                            place: places[index],
                          );
                        },
                      ),
                    );
                  }),
                )),
            Visibility(
              visible: !_isEditing.value,
              child: Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Text(
                      "Added Locations",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: Sizes.p16),
                    Consumer(
                      builder: (context, ref, child) {
                        final authRepository =
                            ref.watch(authRepositoryProvider);
                        final locations = ref.watch(locationsListFutureProvider(
                            authRepository.currentUser!.uid!));
                        return AsyncValueWidget<List<Location>>(
                          value: locations,
                          data: (locations) => ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: locations.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: Sizes.p8),
                                child: LocationCard(
                                  location: locations[index],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: Sizes.p24),
                    Text(
                      "Recommended",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: Sizes.p16),
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Container(
                          margin:
                              const EdgeInsets.symmetric(vertical: Sizes.p8),
                          //child: LocationCard(),
                        );
                      },
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
