import 'package:flutter/material.dart';
import 'package:story_view/story_controller.dart';
import 'package:story_view/story_view.dart';

class StoryPageView extends StatelessWidget {
  final controller=StoryController();
    final List<StoryItem> storyItems=[
      StoryItem.text("Hi", Colors.red),
      StoryItem.pageImage(NetworkImage("https://randomuser.me/api/portraits/men/91.jpg"))
    ];
  @override
  Widget build(BuildContext context) {
    
    return Material(
      child: StoryView(
        storyItems,
        controller: controller,
        inline: false,
        repeat:true)
      
    );
  }
}