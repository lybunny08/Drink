// ignore_for_file: file_names, unnecessary_string_interpolations, unused_field

import 'package:drink/widgets/drink_concept.dart';
import 'package:flutter/material.dart';

const _duration = Duration(milliseconds: 300);

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final _pageTextController = PageController();
  final _pageDrinkController = PageController(viewportFraction: 0.35);
  double _currentPage = 0.0;
  double _textPage = 0.0;

  void _drinkScrollListener() {
    setState(() {
      _currentPage = _pageDrinkController.page!;
    });
  }

  void _textScrollListener() {
    setState(() {
      _textPage = _currentPage;
    });
  }

  @override
  void initState() {
    _pageDrinkController.addListener(_drinkScrollListener);
    _pageTextController.addListener(_textScrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _pageDrinkController.removeListener(_drinkScrollListener);
    _pageTextController.removeListener(_textScrollListener);
    _pageDrinkController.dispose();
    _pageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Transform.scale(
            scale: 1.2,
            alignment: Alignment.bottomCenter,
            child: PageView.builder(
                controller: _pageDrinkController,
                scrollDirection: Axis.vertical,
                itemCount: drinks.length + 1,
                onPageChanged: (value) {
                  if (value < drinks.length) {
                    _pageTextController.animateToPage(value,
                        duration: _duration, curve: Curves.easeOut);
                  }
                },
                itemBuilder: ((context, index) {
                  if (index == 0) {
                    return const SizedBox.shrink();
                  }
                  final drink = drinks[index - 1];
                  final result = _currentPage - index + 1;
                  final value = -0.4 * result + 1;
                  final opacity = value.clamp(1.0, 1.0);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 20),
                    child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..translate(
                              0.0,
                              MediaQuery.of(context).size.height /
                                  2.6 *
                                  (1 - value).abs()),
                        child: Opacity(
                            opacity: opacity,
                            child: Image.asset(
                              drink.image,
                              fit: BoxFit.fitHeight,
                            ))),
                  );
                })),
          ),
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: 100,
              child: Column(
                children: [
                  Expanded(
                      child: PageView.builder(
                          itemCount: drinks.length,
                          controller: _pageTextController,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final opacity =
                                (1 - (index - _textPage).abs()).clamp(0.0, 1.0);
                            return Opacity(
                                opacity: opacity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Text(
                                    drinks[index].name,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ));
                          })),
                  AnimatedSwitcher(
                      key: Key(drinks[_currentPage.toInt()].image),
                      duration: _duration,
                      child: const Text(
                        '',
                        style: TextStyle(fontSize: 30),
                      ))
                ],
              )),
        ],
      ),
    );
  }
}
