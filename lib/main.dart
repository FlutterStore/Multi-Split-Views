// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:multi_split_view/multi_split_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiSplitViewExample(),
    );
  }
}

class MultiSplitViewExample extends StatefulWidget {
  const MultiSplitViewExample({super.key});

  @override
  _MultiSplitViewExampleState createState() => _MultiSplitViewExampleState();
}

class _MultiSplitViewExampleState extends State<MultiSplitViewExample> {
  static const int _max = 40;
  static const int _initial = 3;

  late final List<RandomColorBox> _boxes;

  final MultiSplitViewController _controller = MultiSplitViewController();

  @override
  void initState() {
    super.initState();
    _boxes = List.generate(
      _initial, (_) 
      {
        return  RandomColorBox(
          key: UniqueKey(),
          onRemove: _removeBox,
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget buttons = Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Horizontal widgets: ${_boxes.length} / $_max'),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                setState(
                  () => _boxes.insert(
                    0, 
                    RandomColorBox(
                      key: UniqueKey(),
                      onRemove: _removeBox,
                    )
                  )
                );
              }, 
              child: const Text('Add')
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                if (_boxes.isNotEmpty) {
                  _removeBox(_boxes.first);
                }
              },
              child: const Text('Remove')
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                if (_controller.areas.length >= 2) {
                  _controller.areas = [Area(), Area(weight: .1)];
                }
              },
              child: const Text('Change second area weight')
            )
          ]
        ),
      )
    );

    final List<Widget> children = _boxes;

    return Scaffold(
      appBar: AppBar(title: const Text('Multi Split View Example')),
      body: Column(
        children: [
          buttons, 
          Expanded(
            // child: theme
            child: MultiSplitViewTheme(
              data: MultiSplitViewThemeData(
                dividerPainter: DividerPainters.grooved2()
              ),
              child: MultiSplitView(
                onDividerTap: (dividerIndex) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 1),
                      content: Text("Tap on divider: $dividerIndex"),
                    )
                  );
                },
                onDividerDoubleTap: (dividerIndex) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: const Duration(seconds: 1),
                      content: Text("Double tap on divider: $dividerIndex"),
                    )
                  );
                },
                controller: _controller,
                children: children
              )
            )
          )
        ]
      )
    );
  }

  void _removeBox(RandomColorBox box) {
    setState(() => _boxes.remove(box));
  }
}

class RandomColorBox extends StatefulWidget {
  const RandomColorBox({
    required this.onRemove,
    Key? key,
  }) : super(key: key);

  final void Function(RandomColorBox box) onRemove;

  @override
  State<RandomColorBox> createState() => _RandomColorBoxState();
}

class _RandomColorBoxState extends State<RandomColorBox> {
  late Color _color;

  @override
  void initState() {
    super.initState();
    _color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onRemove(widget),
      child: ColoredBox(
        color: _color,
      ),
    );
  }
}