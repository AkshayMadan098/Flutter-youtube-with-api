import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/Label.dart';
import 'package:flutter_chat_app/theme.dart';
import 'package:flutter_chat_app/translations.dart';
import 'package:flutter_chat_app/unread_indicator.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'avatar.dart';
import 'channel_page.dart';
import 'display_error_message.dart';

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({Key? key}) : super(key: key);

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  final channelListController = ChannelListController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: SizedBox(
                width: 30,
                height: 20,
                child: SvgPicture.asset(
                  "assets/images/green_logo.svg"
              )
              ),
            ),
            actions: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                    },
                    child: Image.asset(
                      'assets/images/hamburgerMenu.png',
                    ),
                  ),
                  const SizedBox(
                    width: 17,
                  )
                ],
              )
            ],
            leadingWidth: 80,
            bottom:  TabBar(
              unselectedLabelColor: Colors.grey,
              labelStyle:
              const TextStyle(fontWeight: FontWeight.bold),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 4,
              padding: EdgeInsets.symmetric(horizontal: 40),
              indicatorPadding: EdgeInsets.zero,
              labelPadding: EdgeInsets.zero,
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: [
                Tab(
                  child: Text("Dating (1)",style: TextStyle(fontFamily: 'sans'),),iconMargin: EdgeInsets.zero,),
                Tab(child: Text("Networking (2)",style: TextStyle(fontFamily: 'sans'),),iconMargin: EdgeInsets.zero,),
              ],
            ),
          ),
          resizeToAvoidBottomInset: false,
          body:TabBarView(
            children: [
              ChannelsBloc(
                child: ChannelListView(
                  channelListController: channelListController,
                  filter: Filter.and(
                    [
                      Filter.equal('type', 'messaging'),
                    ],
                  ),
                  emptyBuilder: (context) => const Center(
                    child: Text(
                      'So empty.\nGo and message someone.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  errorBuilder: (context, error) => DisplayErrorMessage(
                    error: error,
                  ),
                  loadingBuilder: (
                      context,
                      ) =>
                  const Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  listBuilder: (context, channels) {
                    return CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              return _MessageTile(
                                channel: channels[index],
                              );
                            },
                            childCount: channels.length,
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              ChannelsBloc(
                child: ChannelListView(
                  channelListController: channelListController,
                  filter: Filter.and(
                    [
                      Filter.equal('type', 'commerce'),
                    ],
                  ),
                  emptyBuilder: (context) => const Center(
                    child: Text(
                      'So empty.\nGo and message someone.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  errorBuilder: (context, error) => DisplayErrorMessage(
                    error: error,
                  ),
                  loadingBuilder: (
                      context,
                      ) =>
                  const Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  listBuilder: (context, channels) {
                    return CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              return _MessageTile(
                                channel: channels[index],
                              );
                            },
                            childCount: channels.length,
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          ),
    );
  }
}


class _MessageTile extends StatelessWidget {
  const _MessageTile({
    Key? key,
    required this.channel,
  }) : super(key: key);

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(ChannelPage.routeWithChannel(channel));
        },
        child: Container(
          height: 96,
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  const Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/profile.jpeg'),
                      radius: 30,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              channel.name ?? "No title",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18,fontFamily: 'sans'),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              child: Flexible(
                                child: _buildLastMessage()
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 5,
                              backgroundColor: Colors.green,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            _buildLastMessageAt()
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              const Divider(
                thickness: 0.6,
              ),
            ],
          ),
        ),
/*      Container(
          height: 100,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 0.5,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Avatar.medium(
                      url:
                      channel.image),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          channel.name??"",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            letterSpacing: 0.2,
                            wordSpacing: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: _buildLastMessage(),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        height: 4,
                      ),
                      _buildLastMessageAt(),
                      const SizedBox(
                        height: 8,
                      ),
                      Center(
                        child: UnreadMessageIndicator(
                          channel: channel,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),*/
      ),
    );
  }

  Widget _buildLastMessage() {
    return BetterStreamBuilder<int>(
      stream: channel.state!.unreadCountStream,
      initialData: channel.state?.unreadCount ?? 0,
      builder: (context, count) {
        return BetterStreamBuilder<Message>(
          stream: channel.state!.lastMessageStream,
          initialData: channel.state!.lastMessage,
          builder: (context, lastMessage) {
            return Expanded(
              child: Text(
                  lastMessage.text ?? " " ,maxLines: 1,overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    overflow: TextOverflow.ellipsis,
                    color: Colors.grey,
                        fontFamily: 'sans'),
              ),
            );
/*              Text(
              lastMessage.text ?? '',
              overflow: TextOverflow.ellipsis,
              style: (count > 0)
                  ? const TextStyle(
                fontSize: 12,
                color: AppColors.secondary,
              )
                  : const TextStyle(
                fontSize: 12,
                color: AppColors.textFaded,
              ),
            );*/
          },
        );
      },
    );
  }

  Widget _buildLastMessageAt() {
    return BetterStreamBuilder<DateTime>(
      stream: channel.lastMessageAtStream,
      initialData: channel.lastMessageAt,
      builder: (context, data) {
        final lastMessageAt = data.toLocal();
        String stringDate;
        final now = DateTime.now();

        final startOfDay = DateTime(now.year, now.month, now.day);

        if (lastMessageAt.millisecondsSinceEpoch >=
            startOfDay.millisecondsSinceEpoch) {
          stringDate = Jiffy(lastMessageAt.toLocal()).jm;
        } else if (lastMessageAt.millisecondsSinceEpoch >=
            startOfDay
                .subtract(const Duration(days: 1))
                .millisecondsSinceEpoch) {
          stringDate = 'YESTERDAY';
        } else if (startOfDay.difference(lastMessageAt).inDays < 7) {
          stringDate = Jiffy(lastMessageAt.toLocal()).EEEE;
        } else {
          stringDate = Jiffy(lastMessageAt.toLocal()).yMd;
        }
        return Text(
          stringDate,
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 10,fontFamily: 'sans'),
        );
      },
    );
  }
}

