import 'package:church_app/app/data/backend_queries_controller.dart';
import 'package:church_app/app/models/song_info.dart';
import 'package:church_app/app/widgets/search_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SearchWidgetDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(
          Icons.clear,
          color: Colors.black,
        ),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/good2.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<SongInfo>>(
          future: Get.find<BackendController>().getSearch(query),
          builder: (context, snapshot) => snapshot.hasData
              ? ListView.separated(
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) => SearchView(
                    songInfo: snapshot.data![index],
                  ),
                  itemCount: snapshot.data!.length,
                )
              : Center(
                  child: LoadingAnimationWidget.threeArchedCircle(
                    size: 70,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // Set the background color to transparent
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/good2.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(),
      ),
    );
  }
}
