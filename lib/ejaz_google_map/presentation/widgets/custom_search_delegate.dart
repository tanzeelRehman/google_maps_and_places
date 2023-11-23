import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sb_myreports/core/utils/globals/globals.dart';
import 'package:sb_myreports/features/google_map/presentation/manager/map_provider.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext mainContext) {
    MapProvider mapProvider = sl();
    return ChangeNotifierProvider.value(
      value: mapProvider,
      child: Builder(builder: (context) {
        mapProvider.getQueryPlace(query);
        return ValueListenableBuilder<bool>(
          valueListenable: context.read<MapProvider>().placeLoading,
          builder: (context, value, child) {
            if (value) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (mapProvider.locationsSearched.isEmpty) {
              return const Center(child: Text("No Data Found"));
            } else {
              return ListView.builder(
                itemCount: mapProvider.locationsSearched.length,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemBuilder: (context, index) {
                  var result = mapProvider.locationsSearched[index];
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      onTap: () => close(context, result),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(result.name!),
                          const SizedBox(height: 5),
                          Text(
                            result.formattedAddress!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        );
      }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column();
  }
}
