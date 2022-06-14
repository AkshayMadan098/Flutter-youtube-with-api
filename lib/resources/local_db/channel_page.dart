import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/icon_button.dart';
import 'package:flutter_chat_app/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'avatar.dart';
import 'display_error_message.dart';
import 'glowing_action.dart';

class ChannelPage extends StatefulWidget {
  static Route routeWithChannel(Channel channel) => MaterialPageRoute(
    builder: (context) => StreamChannel(
      channel: channel,
      child: const ChannelPage(),
    ),
  );

  const ChannelPage({Key? key}) : super(key: key);

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  late StreamSubscription<int> unreadCountSubscription;
  var size,height,width;

  @override
  void initState() {
    super.initState();

    unreadCountSubscription = StreamChannel.of(context)
        .channel
        .state!
        .unreadCountStream
        .listen(_unreadCountHandler);
  }

  Future<void> _unreadCountHandler(int count) async {
    if (count > 0) {
      await StreamChannel.of(context).channel.markRead();
    }
  }

  @override
  void dispose() {
    unreadCountSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final channel = StreamChannel.of(context).channel;
    return  GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          leading: Expanded(
            child: Row(
              children: [
                const SizedBox(
                  width: 25,
                ),
                GestureDetector(
                  onTap: () {
                  },
                  child: Image.asset(
                    'assets/images/back.png',
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    channel.name ?? "",maxLines: 1,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,fontFamily: 'sans'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: SvgPicture.asset(
                    'assets/images/figurine.svg',width: 15,
                  ),
                ),
                const SizedBox(
                  width: 35,
                ),

                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'assets/images/menuDots.png',
                  ),
                ),
                const SizedBox(
                  width: 22,
                )
              ],
            )
          ],
          leadingWidth: 150,
        ),
        body: Column(
          children: [
            Expanded(
              child: MessageListCore(
                loadingBuilder: (context) {
                  return const Center(child: CircularProgressIndicator());
                },
                emptyBuilder: (context) => const SizedBox.shrink(),
                errorBuilder: (context, error) =>
                    DisplayErrorMessage(error: error),
                messageListBuilder: (context, messages) =>
                    _MessageList(messages: messages),
              ),
            ),
            const _ActionBar(),
          ],
        ),
      ),
    );
  }
}


class _MessageList extends StatelessWidget {
  const _MessageList({
    Key? key,
    required this.messages,
  }) : super(key: key);

  final List<Message> messages;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        itemCount: messages.length + 1,
        reverse: true,
        separatorBuilder: (context, index) {
          if (index == messages.length - 1) {
            return _DateLable(dateTime: messages[index].createdAt);
          }
          if (messages.length == 1) {
            return const SizedBox.shrink();
          } else if (index >= messages.length - 1) {
            return const SizedBox.shrink();
          } else if (index <= messages.length) {
            final message = messages[index];
            final nextMessage = messages[index + 1];
            if (!Jiffy(message.createdAt.toLocal())
                .isSame(nextMessage.createdAt.toLocal(), Units.DAY)) {
              return _DateLable(
                dateTime: message.createdAt,
              );
            } else {
              return const SizedBox.shrink();
            }
          } else {
            return const SizedBox.shrink();
          }
        },
        itemBuilder: (context, index) {
          if (index < messages.length) {
            final message = messages[index];
            if (message.user?.id == StreamChat.of(context).currentUser?.id)
            {
              return _MessageOwnTile(message: message);
            } else {
              return _MessageTile(message: message);
            }
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class _MessageTile extends StatelessWidget {
  const _MessageTile({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  static const _borderRadius = 26.0;

  @override
  Widget build(BuildContext context) {
    var size,height,width;
    size = MediaQuery.of(context).size;
    final channel = StreamChannel.of(context).channel;
    return Align(
        alignment:Alignment.centerLeft,
        child: Row(
          children: [
            Avatar.small(
              url: channel.image,
            ),
            ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: size.width * 0.6,
                ),
                child: Card(
                  color:Colors.grey[300],
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  // color: Color(0xffdcf8c6),
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 8,
                              bottom: 8,
                            ),
                            child: Text(
                              message.text ?? "",
                              style: const TextStyle(
                                fontSize: 15,
                                  fontFamily: 'sans'
                              ),
                            ),
                          ),
                          // Positioned(bottom: -10,child: Container(color: const Color(0xffE2E2E2),width: 50,height: 20))
                        ],
                      ),

                    ],
                  ),
                )),
          ],
        ));
  }
}

class _MessageOwnTile extends StatelessWidget {
  const _MessageOwnTile({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  static const _borderRadius = 26.0;

  @override
  Widget build(BuildContext context) {
    var size,height,width;
     size = MediaQuery.of(context).size;
    return Align(
        alignment:Alignment.centerRight,
        child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: size.width * 0.6,
            ),
            child: Card(
              color:const Color(0xFF79DBA7),
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              // color: Color(0xffdcf8c6),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 8,
                          bottom: 8,
                        ),
                        child: Text(
                          message.text ?? "",
                          style: const TextStyle(
                            fontSize: 15,
                              fontFamily: 'sans'
                          ),
                        ),
                      ),
                      // Positioned(bottom: -10,child: Container(color: const Color(0xffE2E2E2),width: 50,height: 20))
                    ],
                  ),

                ],
              ),
            )));
/*      Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
*//*            Container(
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_borderRadius),
                  bottomRight: Radius.circular(_borderRadius),
                  bottomLeft: Radius.circular(_borderRadius),
                ),
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
                child: Text(message.text ?? '',
                    style: const TextStyle(
                      color: AppColors.textLigth,
                    )),
              ),
            ),*//*
            Card(
              color: const Color(0xFF79DBA7),
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              // color: Color(0xffdcf8c6),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 8,
                          bottom: 8,
                        ),
                        child: Text(
                          message.text ?? '',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      // Positioned(bottom: -10,child: Container(color: const Color(0xffE2E2E2),width: 50,height: 20))
                    ],
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );*/
  }
}

class _DateLable extends StatefulWidget {
  const _DateLable({
    Key? key,
    required this.dateTime,
  }) : super(key: key);

  final DateTime dateTime;

  @override
  __DateLableState createState() => __DateLableState();
}

class __DateLableState extends State<_DateLable> {
  late String dayInfo;

  @override
  void initState() {
    final createdAt = Jiffy(widget.dateTime);
    final now = DateTime.now();

    if (Jiffy(createdAt).isSame(now, Units.DAY)) {
      dayInfo = 'Today';
    } else if (Jiffy(createdAt)
        .isSame(now.subtract(const Duration(days: 1)), Units.DAY)) {
      dayInfo = 'Yesterday';
    } else if (Jiffy(createdAt).isAfter(
      now.subtract(const Duration(days: 7)),
      Units.DAY,
    )) {
      dayInfo = createdAt.EEEE;
    } else if (Jiffy(createdAt).isAfter(
      Jiffy(now).subtract(years: 1),
      Units.DAY,
    )) {
      dayInfo = createdAt.MMMd;
    } else {
      dayInfo = createdAt.MMMd;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
            child: Text(
              dayInfo,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color:Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    return Row(
      children: [
        Expanded(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                channel.name ?? "",
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              const SizedBox(height: 2),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildConnectedTitleState(
      BuildContext context,
      List<Member>? members,
      ) {
    Widget? alternativeWidget;
    final channel = StreamChannel.of(context).channel;
    final memberCount = channel.memberCount;
    if (memberCount != null && memberCount > 2) {
      var text = 'Members: $memberCount';
      final watcherCount = channel.state?.watcherCount ?? 0;
      if (watcherCount > 0) {
        text = 'watchers $watcherCount';
      }
      alternativeWidget = Text(
        text,
      );
    } else {
      final userId = StreamChatCore.of(context).currentUser?.id;
      final otherMember = members?.firstWhere(
            (element) => element.userId != userId,
      );

      if (otherMember != null) {
        if (otherMember.user?.online == true) {
          alternativeWidget = const Text(
            'Online',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          );
        } else {
          alternativeWidget = Text(
            'Last online: '
                '${Jiffy(otherMember.user?.lastActive).fromNow()}',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          );
        }
      }
    }

    return TypingIndicator(
      alternativeWidget: alternativeWidget,
    );
  }
}

/// Widget to show the current list of typing users
class TypingIndicator extends StatelessWidget {
  /// Instantiate a new TypingIndicator
  const TypingIndicator({
    Key? key,
    this.alternativeWidget,
  }) : super(key: key);

  /// Widget built when no typings is happening
  final Widget? alternativeWidget;

  @override
  Widget build(BuildContext context) {
    final channelState = StreamChannel.of(context).channel.state!;

    final altWidget = alternativeWidget ?? const SizedBox.shrink();

    return BetterStreamBuilder<Iterable<User>>(
      initialData: channelState.typingEvents.keys,
      stream: channelState.typingEventsStream
          .map((typings) => typings.entries.map((e) => e.key)),
      builder: (context, data) {
        return Align(
          alignment: Alignment.centerLeft,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: data.isNotEmpty == true
                ? const Align(
              alignment: Alignment.centerLeft,
              key: ValueKey('typing-text'),
              child: Text(
                'Typing message',
                maxLines: 1,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
                : Align(
              alignment: Alignment.centerLeft,
              key: const ValueKey('altwidget'),
              child: altWidget,
            ),
          ),
        );
      },
    );
  }
}

/// Widget that builds itself based on the latest snapshot of interaction with
/// a [Stream] of type [ConnectionStatus].
///
/// The widget will use the closest [StreamChatClient.wsConnectionStatusStream]
/// in case no stream is provided.
class ConnectionStatusBuilder extends StatelessWidget {
  /// Creates a new ConnectionStatusBuilder
  const ConnectionStatusBuilder({
    Key? key,
    required this.statusBuilder,
    this.connectionStatusStream,
    this.errorBuilder,
    this.loadingBuilder,
  }) : super(key: key);

  /// The asynchronous computation to which this builder is currently connected.
  final Stream<ConnectionStatus>? connectionStatusStream;

  /// The builder that will be used in case of error
  final Widget Function(BuildContext context, Object? error)? errorBuilder;

  /// The builder that will be used in case of loading
  final WidgetBuilder? loadingBuilder;

  /// The builder that will be used in case of data
  final Widget Function(BuildContext context, ConnectionStatus status)
  statusBuilder;

  @override
  Widget build(BuildContext context) {
    final stream = connectionStatusStream ??
        StreamChatCore.of(context).client.wsConnectionStatusStream;
    final client = StreamChatCore.of(context).client;
    return BetterStreamBuilder<ConnectionStatus>(
      initialData: client.wsConnectionStatus,
      stream: stream,
      noDataBuilder: loadingBuilder,
      errorBuilder: (context, error) {
        if (errorBuilder != null) {
          return errorBuilder!(context, error);
        }
        return const Offstage();
      },
      builder: statusBuilder,
    );
  }
}

class _ActionBar extends StatefulWidget {
  const _ActionBar({Key? key}) : super(key: key);

  @override
  __ActionBarState createState() => __ActionBarState();
}

class __ActionBarState extends State<_ActionBar> {
  final TextEditingController controller = TextEditingController();
  var size,height,width;
  Future<void> _sendMessage() async {
    if (controller.text.isNotEmpty) {
      StreamChannel.of(context)
          .channel
          .sendMessage(Message(text: controller.text));
      controller.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
      bottom: true,
      top: false,
      child: Column(
        children: [
          const Divider(
            thickness: 1.2,
          ),
          SizedBox(
            height: size.height * 0.10,
            width: size.width * 0.85,
            child: Row(
              children: [
                Expanded(
                    flex: 5,
                    child: TextField(
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: "Send message",
                        hintStyle: TextStyle(fontSize: 15,fontFamily: 'sans'),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 30, right: 15),
                      ),
                      cursorColor: Colors.black,
                      controller: controller,
                      onChanged: (val) {
                        StreamChannel.of(context).channel.keyStroke();
                      },
                      onSubmitted: (_) => _sendMessage(),
                    )),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      _sendMessage();
                    },
                    child: const CircleAvatar(
                      radius: 23,
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )

/*      Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  width: 2,
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(
                CupertinoIcons.camera_fill,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: TextField(
                controller: controller,
                onChanged: (val) {
                  StreamChannel.of(context).channel.keyStroke();
                },
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Type something...',
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 24.0,
            ),
            child: GlowingActionButton(
              color: AppColors.accent,
              icon: Icons.send_rounded,
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),*/


    );
  }
}
