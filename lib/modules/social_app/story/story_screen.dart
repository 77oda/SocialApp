import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:test123/models/social_app/story_model.dart';

import '../../../layout/social_app/cubit/cubit.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/styles/colors.dart';
import '../visit_profile/visit_profile_screen.dart';

class StoryScreen extends StatelessWidget {
  final List<StoryModel> storyModel;
  final _storyController = StoryController();

  StoryScreen({super.key, required this.storyModel});
  @override
  Widget build(BuildContext context) {
    final controller = StoryController();
    List<StoryItem> storyItems = [];
    storyModel.forEach((element) {
      storyItems.add(
        StoryItem.pageImage(
            imageFit: BoxFit.cover,
            url: "${element.storyImage}",
            controller: _storyController),
      );
    });

    DateTime? t = DateTime.parse('${storyModel[0].dateTime}');
    String? time = convertToAgo(t);
    return Material(
      child: Stack(children: [
        StoryView(
          onVerticalSwipeComplete: (direction) {
            if (direction == Direction.right) {
              Navigator.pop(context);
            }
          },
          onComplete: () {
            Navigator.pop(context);
          },
          indicatorForegroundColor: defaultColor,
          storyItems: storyItems,
          controller: controller,
          inline: false,
          repeat: false,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 60, left: 15),
          child: SizedBox(
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (storyModel[0].uId != uId) {
                      SocialCubit.get(context).getProfile(storyModel[0].uId);
                      navigateTo(context, VisitProfileScreen());
                    }
                  },
                  child: CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(
                      '${storyModel[0].image}',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${storyModel[0].name}',
                            style: const TextStyle(
                              color: Colors.white,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          const Icon(
                            Icons.check_circle,
                            color: defaultColor,
                            size: 16.0,
                          ),
                        ],
                      ),
                      Text(
                        time,
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              height: 1.4,
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
