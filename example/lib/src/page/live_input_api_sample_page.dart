import 'dart:async';

import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import 'package:chewie/chewie.dart';
import 'package:cloudflare/cloudflare.dart';
import 'package:cloudflare_example/main.dart';
import 'package:cloudflare_example/src/page/types/channel.dart';
import 'package:cloudflare_example/src/page/types/params.dart';
import 'package:cloudflare_example/src/page/types/resolution.dart';
import 'package:cloudflare_example/src/page/types/sample_rate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:video_player/video_player.dart';

/// This allows a value of type T or T? to be treated as a value of type T?.
///
/// We use this so that APIs that have become non-nullable can still be used
/// with `!` and `?` on the stable branch.
T? _ambiguate<T>(T? value) => value;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key, required this.params}) : super(key: key);
  final Params params;

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int resultAlert = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(
                context,
              );
            }),
      ),
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SettingsList(
            sections: [
              SettingsSection(
                title: const Text('Video'),
                tiles: [
                  SettingsTile(
                    title: const Text('Resolution'),
                    value: Text(widget.params.getResolutionToString()),
                    onPressed: (BuildContext context) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return PickerScreen(
                                title: 'Pick a resolution',
                                initialValue: widget.params.video.resolution,
                                values: getResolutionsMap());
                          }).then((value) {
                        if (value != null) {
                          setState(() {
                            widget.params.video.resolution = value;
                          });
                        }
                      });
                    },
                  ),
                  SettingsTile(
                    title: const Text('Framerate'),
                    value: Text(widget.params.video.fps.toString()),
                    onPressed: (BuildContext context) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return PickerScreen(
                                title: 'Pick a frame rate',
                                initialValue:
                                    widget.params.video.fps.toString(),
                                values: fpsList.toMap());
                          }).then((value) {
                        if (value != null) {
                          setState(() {
                            widget.params.video.fps = value;
                          });
                        }
                      });
                    },
                  ),
                  CustomSettingsTile(
                    child: Column(
                      children: [
                        SettingsTile(
                          title: const Text('Bitrate'),
                        ),
                        Row(
                          children: [
                            Slider(
                              value: (widget.params.video.bitrate / 1024)
                                  .toDouble(),
                              onChanged: (newValue) {
                                setState(() {
                                  widget.params.video.bitrate =
                                      (newValue.roundToDouble() * 1024).toInt();
                                });
                              },
                              min: 500,
                              max: 10000,
                            ),
                            Text('${widget.params.video.bitrate}')
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('Audio'),
                tiles: [
                  SettingsTile(
                    title: const Text('Number of channels'),
                    value: Text(widget.params.getChannelToString()),
                    onPressed: (BuildContext context) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return PickerScreen(
                                title: 'Pick the number of channels',
                                initialValue:
                                    widget.params.getChannelToString(),
                                values: getChannelsMap());
                          }).then((value) {
                        if (value != null) {
                          setState(() {
                            widget.params.audio.channel = value;
                          });
                        }
                      });
                    },
                  ),
                  SettingsTile(
                    title: const Text('Bitrate'),
                    value: Text(widget.params.getBitrateToString()),
                    onPressed: (BuildContext context) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return PickerScreen(
                                title: 'Pick a bitrate',
                                initialValue:
                                    widget.params.getChannelToString(),
                                values: audioBitrateList.toMap(
                                    valueTransformation: (int e) =>
                                        bitrateToPrettyString(e)));
                          }).then((value) {
                        if (value != null) {
                          setState(() {
                            widget.params.audio.bitrate = value;
                          });
                        }
                      });
                    },
                  ),
                  SettingsTile(
                    title: const Text('Sample rate'),
                    value: Text(widget.params.getSampleRateToString()),
                    onPressed: (BuildContext context) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return PickerScreen(
                                title: 'Pick a sample rate',
                                initialValue:
                                    widget.params.getSampleRateToString(),
                                values: getSampleRatesMap());
                          }).then((value) {
                        if (value != null) {
                          setState(() {
                            widget.params.audio.sampleRate = value;
                          });
                        }
                      });
                    },
                  ),
                  SettingsTile.switchTile(
                    title: const Text('Enable echo canceler'),
                    initialValue: widget.params.audio.enableEchoCanceler,
                    onToggle: (bool value) {
                      setState(() {
                        widget.params.audio.enableEchoCanceler = value;
                      });
                    },
                  ),
                  SettingsTile.switchTile(
                    title: const Text('Enable noise suppressor'),
                    initialValue: widget.params.audio.enableNoiseSuppressor,
                    onToggle: (bool value) {
                      setState(() {
                        widget.params.audio.enableNoiseSuppressor = value;
                      });
                    },
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('Endpoint'),
                tiles: [
                  SettingsTile(
                      title: const Text('RTMP endpoint'),
                      value: Text(widget.params.rtmpUrl),
                      onPressed: (BuildContext context) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return EditTextScreen(
                                  title: 'Enter RTMP endpoint URL',
                                  initialValue: widget.params.rtmpUrl,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.params.rtmpUrl = value;
                                    });
                                  });
                            });
                      }),
                  SettingsTile(
                      title: const Text('Stream key'),
                      value: Text(widget.params.streamKey),
                      onPressed: (BuildContext context) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return EditTextScreen(
                                  title: 'Enter stream key',
                                  initialValue: widget.params.streamKey,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.params.streamKey = value;
                                    });
                                  });
                            });
                      }),
                ],
              )
            ],
          )),
    );
  }
}

class PickerScreen extends StatelessWidget {
  const PickerScreen({
    Key? key,
    required this.title,
    required this.initialValue,
    required this.values,
  }) : super(key: key);

  final String title;
  final dynamic initialValue;
  final Map<dynamic, String> values;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text(title),
            tiles: values.keys.map((e) {
              final value = values[e];

              return SettingsTile(
                title: Text(value!),
                onPressed: (_) {
                  Navigator.of(context).pop(e);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class EditTextScreen extends StatelessWidget {
  const EditTextScreen(
      {Key? key,
      required this.title,
      required this.initialValue,
      required this.onChanged})
      : super(key: key);

  final String title;
  final String initialValue;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SettingsList(
        sections: [
          SettingsSection(title: Text(title), tiles: [
            CustomSettingsTile(
              child: TextField(
                  controller: TextEditingController(text: initialValue),
                  onChanged: onChanged),
            ),
          ]),
        ],
      ),
    );
  }
}

class LiveInputAPIDemoPage extends StatefulWidget {
  const LiveInputAPIDemoPage({Key? key}) : super(key: key);

  @override
  _LiveInputAPIDemoPageState createState() => _LiveInputAPIDemoPageState();
}

enum FileSource {
  path,
  bytes,
}

enum UploadType {
  singleHttp,
  tus,
}

class _LiveInputAPIDemoPageState extends State<LiveInputAPIDemoPage> {
  static const int doCreateLiveInput = 1;
  static const int doStartLiveStreaming = 2;
  static const int doStopLiveStreaming = 3;
  static const int doWatchLiveStreaming = 4;
  CloudflareStreamVideo? cloudflareStreamVideo;
  CloudflareLiveInput? cloudflareLiveInput;
  bool awaitingToBeReadyToStream = false;
  bool streamingRequestStarted = false;
  ChewieController? chewieControllerFromUrl;
  Timer? awaitingToBeReadyToStreamTimer;

  bool loading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
  }

  Widget videoFromUrlView(CloudflareStreamVideo video) {
    // String url = video.preview; // Cloudflare video previews doesn't allow Range header which is required in iOS with https://pub.dev/packages/video_player
    String url = video.playback?.hls ?? '';
    if (chewieControllerFromUrl?.videoPlayerController.dataSource != url) {
      // clearVideoControllers()
      chewieControllerFromUrl = ChewieController(
        autoPlay: true,
        allowPlaybackSpeedChanging: false,
        isLive: true,
        placeholder: const Center(
            child: Icon(
          Icons.flutter_dash,
          size: 48,
          color: Colors.lightBlue,
        )),
        videoPlayerController: VideoPlayerController.networkUrl(
          Uri.parse(url),
        )..initialize().then((_) {
            errorMessage = null;
          }).onError((error, stackTrace) {
            errorMessage = error?.toString();
            clearVideoControllers();
          }).whenComplete(() {
            setState(() {});
          }),
      );
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: chewieControllerFromUrl!.videoPlayerController.value.isInitialized
          ? AspectRatio(
              key: ValueKey(
                  'video-from-url-${chewieControllerFromUrl!.videoPlayerController.dataSource}'),
              aspectRatio: MediaQuery.of(context).size.shortestSide > 600
                  ? 3
                  : chewieControllerFromUrl!
                      .videoPlayerController.value.aspectRatio,
              child: Chewie(
                controller: chewieControllerFromUrl!,
              ),
            )
          : const CircularProgressIndicator(),
    );
  }

  Widget button({
    VoidCallback? onPressed,
    Color? color,
    required String text,
  }) =>
      ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            return states.contains(WidgetState.disabled) ? null : color;
          }),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      );

  Widget get loadingView => loading
      ? const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        )
      : const SizedBox();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Input API Demo'),
      ),
      body: Center(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (cloudflareLiveInput == null)
                  button(
                    text: 'Create Live Input',
                    color: Colors.blue,
                    onPressed:
                        loading ? null : () => onClick(doCreateLiveInput),
                  ),
                if (cloudflareLiveInput != null && !streamingRequestStarted)
                  button(
                    text: 'Start Live Streaming',
                    color: Colors.green,
                    onPressed:
                        loading ? null : () => onClick(doStartLiveStreaming),
                  ),
                if (streamingRequestStarted) ...[
                  SizedBox(
                    height: 500,
                    child: LiveStreamingView(
                        cloudflareLiveInput: cloudflareLiveInput!),
                  ),
                  const SizedBox(height: 8),
                  button(
                    text: 'Stop Live Streaming',
                    color: Colors.red,
                    onPressed:
                        loading ? null : () => onClick(doStopLiveStreaming),
                  ),
                  const SizedBox(height: 8),
                  button(
                    text: 'Watch Live Streaming',
                    color: Colors.orange,
                    onPressed:
                        loading ? null : () => onClick(doWatchLiveStreaming),
                  ),
                ],
                if (errorMessage?.isNotEmpty ?? false)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$errorMessage',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 18, color: Colors.red.shade900),
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                    ],
                  ),
                loadingView,
                if (streamingRequestStarted &&
                    cloudflareStreamVideo != null) ...[
                  const SizedBox(height: 8),
                  videoFromUrlView(cloudflareStreamVideo!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createLiveInput() async {
    showLoading();
    try {
      CloudflareHTTPResponse<CloudflareLiveInput?> response =
          await cloudflare.liveInputAPI.create(
        data: CloudflareLiveInput(
            meta: {'name': 'Live stream flutter example ${DateTime.now()}'},
            recording:
                LiveInputRecording(mode: LiveInputRecordingMode.automatic)),
      );

      if (response.isSuccessful && response.body != null) {
        cloudflareLiveInput = response.body;
      } else {
        if (response.error is CloudflareErrorResponse &&
            (response.error as CloudflareErrorResponse).messages.isNotEmpty) {
          errorMessage =
              (response.error as CloudflareErrorResponse).messages.first;
        } else {
          errorMessage = response.error?.toString();
        }
      }
    } catch (e) {
      errorMessage = e.toString();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> watchLiveInput() async {
    showLoading();
    try {
      cloudflareStreamVideo = null;
      final response = await cloudflare.liveInputAPI.get(
        liveInput: cloudflareLiveInput,
      );

      if (response.isSuccessful && response.body != null) {
        cloudflareLiveInput = response.body;
        if (cloudflareLiveInput?.status?.current?.isConnected ?? false) {
          final liveInputVideosResponse =
              await cloudflare.liveInputAPI.getVideos(
            liveInput: cloudflareLiveInput,
          );
          if (liveInputVideosResponse.isSuccessful &&
              liveInputVideosResponse.body != null) {
            for (final video in liveInputVideosResponse.body!) {
              if (video.status.state == MediaProcessingState.liveInProgress) {
                cloudflareStreamVideo = video;
                break;
              }
            }
            if (cloudflareStreamVideo == null) {
              errorMessage =
                  'No live video available to watch for this streaming. Try to watch again.';
            }
          } else {
            if (liveInputVideosResponse.error is CloudflareErrorResponse &&
                (liveInputVideosResponse.error as CloudflareErrorResponse)
                    .messages
                    .isNotEmpty) {
              errorMessage =
                  (liveInputVideosResponse.error as CloudflareErrorResponse)
                      .messages
                      .first;
            } else {
              errorMessage = liveInputVideosResponse.error?.toString();
            }
          }
        } else {
          errorMessage =
              'Live streaming not connected. Check you are already streaming and try to watch again.';
        }
      } else {
        if (response.error is CloudflareErrorResponse &&
            (response.error as CloudflareErrorResponse).messages.isNotEmpty) {
          errorMessage =
              (response.error as CloudflareErrorResponse).messages.first;
        } else {
          errorMessage = response.error?.toString();
        }
      }
    } catch (e) {
      errorMessage = e.toString();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void onClick(int id) async {
    errorMessage = null;
    try {
      switch (id) {
        case doCreateLiveInput:
          await createLiveInput();
          break;
        case doStartLiveStreaming:
          setState(() {
            streamingRequestStarted = true;
          });
          break;
        case doStopLiveStreaming:
          await clearVideoControllers();
          setState(() {
            streamingRequestStarted = false;
            cloudflareStreamVideo = null;
          });
          break;
        case doWatchLiveStreaming:
          await watchLiveInput();
          break;
      }
    } catch (e) {
      print(e);
      loading = false;
      setState(() => errorMessage = e.toString());
    } finally {
      if (loading) hideLoading();
    }
  }

  void showLoading() => setState(() => loading = true);

  void hideLoading() => setState(() => loading = false);

  Future<void> clearVideoControllers() async {
    await chewieControllerFromUrl?.videoPlayerController.dispose();
    chewieControllerFromUrl?.dispose();
    chewieControllerFromUrl = null;
  }

  @override
  void dispose() {
    clearVideoControllers();
    super.dispose();
  }
}

class LiveStreamingView extends StatefulWidget {
  final CloudflareLiveInput cloudflareLiveInput;
  const LiveStreamingView({Key? key, required this.cloudflareLiveInput})
      : super(key: key);

  @override
  _LiveStreamingViewState createState() => _LiveStreamingViewState();
}

class _LiveStreamingViewState extends State<LiveStreamingView>
    with WidgetsBindingObserver {
  final ButtonStyle buttonStyle =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
  Params config = Params();
  late final LiveStreamController _controller;
  late final Future<int> textureId;

  @override
  void dispose() {
    disposeController();
    super.dispose();
  }

  void disposeController() {
    _controller.stop();
  }

  @override
  void initState() {
    _ambiguate(WidgetsBinding.instance)?.addObserver(this);

    config.rtmpUrl = widget.cloudflareLiveInput.rtmps.url;
    config.streamKey = widget.cloudflareLiveInput.rtmps.streamKey;

    _controller = initLiveStreamController();

    textureId = _controller
        .create(
          initialAudioConfig: config.audio,
          initialVideoConfig: config.video,
        )
        .whenComplete(() => Future.delayed(
            const Duration(milliseconds: 500), onStartStreamingButtonPressed));
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _controller.stop();
    } else if (state == AppLifecycleState.resumed) {
      _controller.startPreview();
    }
  }

  LiveStreamController initLiveStreamController() {
    return LiveStreamController(onConnectionSuccess: () {
      print('Connection succeeded');
    }, onConnectionFailed: (error) {
      print('Connection failed: $error');
      _showDialog(context, 'Connection failed', error);
      if (mounted) {
        setState(() {});
      }
    }, onDisconnection: () {
      showInSnackBar('Disconnected');
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Center(
                child: buildPreview(controller: _controller),
              ),
            ),
          ),
          _controlRowWidget()
        ],
      ),
    );
  }

  void _awaitResultFromSettingsFinal(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SettingsScreen(params: config)));
    _controller.setVideoConfig(config.video);
    _controller.setAudioConfig(config.audio);
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _controlRowWidget() {
    final LiveStreamController? liveStreamController = _controller;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.cameraswitch),
          color: Colors.deepOrange,
          onPressed:
              liveStreamController != null ? onSwitchCameraButtonPressed : null,
        ),
        IconButton(
          icon: const Icon(Icons.mic_off),
          color: Colors.deepOrange,
          onPressed: liveStreamController != null
              ? onToggleMicrophoneButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.fiber_manual_record),
          color: Colors.red,
          onPressed:
              liveStreamController != null && !liveStreamController.isStreaming
                  ? onStartStreamingButtonPressed
                  : null,
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          color: Colors.red,
          onPressed:
              liveStreamController != null && liveStreamController.isStreaming
                  ? onStopStreamingButtonPressed
                  : null,
        ),
        IconButton(
          icon: const Icon(Icons.menu),
          color: Colors.red,
          onPressed: () {
            _awaitResultFromSettingsFinal(context);
          },
        ),
      ],
    );
  }

  void showInSnackBar(String message) {
    // ignore: deprecated_member_use
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> switchCamera() async {
    final LiveStreamController? liveStreamController = _controller;

    if (liveStreamController == null) {
      showInSnackBar('Error: create a camera controller first.');
      return;
    }

    try {
      liveStreamController.switchCamera();
    } catch (error) {
      if (error is PlatformException) {
        _showDialog(
            context, 'Error', 'Failed to switch camera: ${error.message}');
      } else {
        _showDialog(context, 'Error', 'Failed to switch camera: $error');
      }
    }
  }

  Future<void> toggleMicrophone() async {
    final LiveStreamController? liveStreamController = _controller;

    if (liveStreamController == null) {
      showInSnackBar('Error: create a camera controller first.');
      return;
    }

    try {
      liveStreamController.toggleMute();
    } catch (error) {
      if (error is PlatformException) {
        _showDialog(
            context, 'Error', 'Failed to toggle mute: ${error.message}');
      } else {
        _showDialog(context, 'Error', 'Failed to toggle mute: $error');
      }
    }
  }

  Future<void> startStreaming() async {
    final LiveStreamController? liveStreamController = _controller;

    if (liveStreamController == null) {
      showInSnackBar('Error: create a camera controller first.');
      return;
    }

    try {
      await liveStreamController.startStreaming(
          streamKey: config.streamKey, url: config.rtmpUrl);
    } catch (error) {
      if (error is PlatformException) {
        print('Error: failed to start stream: ${error.message}');
      } else {
        print('Error: failed to start stream: $error');
      }
    }
  }

  Future<void> stopStreaming() async {
    final LiveStreamController? liveStreamController = _controller;

    if (liveStreamController == null) {
      showInSnackBar('Error: create a camera controller first.');
      return;
    }

    try {
      liveStreamController.stopStreaming();
    } catch (error) {
      if (error is PlatformException) {
        _showDialog(
            context, 'Error', 'Failed to stop stream: ${error.message}');
      } else {
        _showDialog(context, 'Error', 'Failed to stop stream: $error');
      }
    }
  }

  void onSwitchCameraButtonPressed() {
    switchCamera().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void onToggleMicrophoneButtonPressed() {
    toggleMicrophone().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void onStartStreamingButtonPressed() {
    startStreaming().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void onStopStreamingButtonPressed() {
    stopStreaming().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Widget buildPreview({required LiveStreamController controller}) {
    // Wait for [LiveStreamController.create] to finish.
    return FutureBuilder<int>(
        future: textureId,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (!snapshot.hasData) {
            // while data is loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return CameraPreview(controller: controller);
          }
        });
  }
}

Future<void> _showDialog(
    BuildContext context, String title, String description) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(description),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Dismiss'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
