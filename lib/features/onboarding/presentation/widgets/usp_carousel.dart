/// The self-scrolling USP strip behind designs 1b–1e.
library;

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../domain/usp_slide.dart';
import '../onboarding_palette.dart';
import 'page_dots.dart';
import 'usp_illustration.dart';

/// A looping carousel of USP cards that scrolls itself, one card per screen.
///
/// Each card takes the full width, so a single USP owns the screen — nothing
/// from its neighbours shows until the strip is actually moving. The strip
/// never dead-ends: after the fourth card it comes back round to the first
/// for as long as the screen is open. Nothing here advances the flow; the
/// only decision on the screen is the Continue button below.
///
/// The handover is choreographed rather than a flat slide: the leaving card
/// sinks back as the arriving one builds itself up in order — artwork first,
/// then the headline, then the body — while the artwork drifts a beat behind
/// the card for depth. All of it is driven by the scroll position, so a drag
/// plays the same choreography under the finger and there is nothing left
/// animating once the strip is at rest.
///
/// Dragging takes over: auto-scroll pauses for the drag, the strip snaps to
/// whole cards, and the timer picks up again from wherever it settles.
class UspCarousel extends StatefulWidget {
  /// Creates a carousel over [slides].
  const UspCarousel({
    super.key,
    required this.slides,
    this.slideDuration = const Duration(milliseconds: 2500),
  });

  /// Cards to show, in order, repeated as the strip loops.
  final List<UspSlide> slides;

  /// How long a card is held before the strip moves to the next one.
  final Duration slideDuration;

  @override
  State<UspCarousel> createState() => _UspCarouselState();
}

class _UspCarouselState extends State<UspCarousel> {
  /// How long a card takes to glide into place. Kept snappy so the auto-
  /// advance feels lively without the eye losing the card mid-transition.
  static const Duration _glide = Duration(milliseconds: 450);

  /// Breathing room between two cards, seen only mid-glide as one screen
  /// hands over to the next.
  static const double _cardGap = 12;

  final ScrollController _controller = ScrollController();

  /// Which slide is centred, published on its own so the dots can follow the
  /// strip without rebuilding the cards on every scroll frame.
  final ValueNotifier<int> _active = ValueNotifier<int>(0);

  Timer? _autoScroll;
  double _cardExtent = 0;
  bool _motionAllowed = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_syncActive);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // A carousel that moves on its own is exactly what "reduce motion" is for,
    // so under that setting the strip only moves when the user drags it.
    _motionAllowed = !MediaQuery.disableAnimationsOf(context);
    _restartAutoScroll();
  }

  @override
  void didUpdateWidget(covariant UspCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.slideDuration != oldWidget.slideDuration) {
      _restartAutoScroll();
    }
  }

  @override
  void dispose() {
    _autoScroll?.cancel();
    _controller.removeListener(_syncActive);
    _controller.dispose();
    _active.dispose();
    super.dispose();
  }

  /// True once the strip has been laid out and can be measured.
  bool get _measurable =>
      _cardExtent > 0 &&
      _controller.hasClients &&
      _controller.position.hasPixels;

  /// Index of the card currently sitting in the middle of the strip.
  int get _centredCard => (_controller.offset / _cardExtent).round();

  void _restartAutoScroll() {
    _autoScroll?.cancel();

    if (!_motionAllowed) {
      return;
    }

    _autoScroll = Timer.periodic(widget.slideDuration, (Timer _) => _advance());
  }

  void _advance() {
    if (!mounted || !_measurable) {
      return;
    }

    _controller.animateTo(
      (_centredCard + 1) * _cardExtent,
      duration: _glide,
      curve: Curves.easeInOutCubic,
    );
  }

  void _syncActive() {
    if (!_measurable) {
      return;
    }

    _active.value = _centredCard % widget.slides.length;
  }

  /// Holds the timer for the length of a drag so the strip is never pulled out
  /// from under the user's finger, then hands control back once it settles.
  bool _onScroll(ScrollNotification notification) {
    if (notification is ScrollStartNotification &&
        notification.dragDetails != null) {
      _autoScroll?.cancel();
    } else if (notification is ScrollEndNotification) {
      _restartAutoScroll();
    }

    return false;
  }

  /// 1 for the card in the middle of the strip, falling to 0 for one a full
  /// card away.
  double _focusOf(int index) {
    if (!_measurable) {
      return index == 0 ? 1 : 0;
    }

    return (1 - ((_controller.offset / _cardExtent) - index).abs()).clamp(
      0.0,
      1.0,
    );
  }

  /// Signed distance of a card from centre, in cards, clamped to one either
  /// way — the parallax input.
  double _shiftOf(int index) {
    if (!_measurable) {
      return 0;
    }

    return ((_controller.offset / _cardExtent) - index).clamp(-1.0, 1.0);
  }

  Widget _buildCard(BuildContext context, int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? _) {
        final double focus = _focusOf(index);

        // The leaving card sinks back and dims while the arriving one grows
        // to full presence, so mid-glide the eye is handed from one to the
        // other rather than asked to track a flat slide.
        return Opacity(
          opacity: 0.35 + 0.65 * focus,
          child: Transform.scale(
            scale: 0.92 + 0.08 * focus,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: _cardGap),
              child: _UspCard(
                slide: widget.slides[index % widget.slides.length],
                focus: focus,
                shift: _shiftOf(index),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              _cardExtent = constraints.maxWidth;

              return NotificationListener<ScrollNotification>(
                onNotification: _onScroll,
                child: ListView.builder(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  itemExtent: _cardExtent,
                  physics: _CardSnapPhysics(cardExtent: _cardExtent),
                  // No item count: the four slides repeat for as long as the
                  // screen is open, so the pitch never runs out.
                  itemBuilder: _buildCard,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        ValueListenableBuilder<int>(
          valueListenable: _active,
          builder: (BuildContext context, int active, Widget? child) {
            return PageDots(count: widget.slides.length, activeIndex: active);
          },
        ),
      ],
    );
  }
}

/// One card of the strip: artwork, headline, body, arriving in that order.
class _UspCard extends StatelessWidget {
  const _UspCard({
    required this.slide,
    required this.focus,
    required this.shift,
  });

  final UspSlide slide;

  /// 1 with the card centred, 0 a full screen away — the master clock for the
  /// card's entrance.
  final double focus;

  /// Signed distance from centre in cards; drives the artwork's parallax.
  final double shift;

  /// Height held back for the headline and body before the artwork takes what
  /// is left, so short screens give the picture up rather than the words.
  static const double _copyRoom = 200;

  /// How far the artwork trails the card mid-glide.
  static const double _parallax = 28;

  /// One leg of the entrance: nothing before [start], settled after [end],
  /// eased in between — art, headline and body each get their own leg so they
  /// arrive in turn.
  Widget _reveal(
    double start,
    double end, {
    required Widget child,
    double rise = 22,
  }) {
    final double t = Curves.easeOutCubic.transform(
      ((focus - start) / (end - start)).clamp(0.0, 1.0),
    );

    return Opacity(
      opacity: t,
      child: Transform.translate(
        offset: Offset(0, rise * (1 - t)),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // The artwork is square, so the panel is too: a taller slot would only
        // add white margin around a drawing that cannot grow past the card's
        // width. Every card gets the same slot, so the panels line up as the
        // strip moves.
        final double artworkSize = math.min(
          constraints.maxWidth,
          math.max(140, constraints.maxHeight - _copyRoom),
        );

        // Scrolls only if the copy outgrows the card — at large text sizes the
        // slide gives way rather than clipping the sentence.
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              // Centred rather than stacked from the top: whatever height the
              // copy comes to, the card sits balanced instead of leaving a
              // hole between the last line and the dots.
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _reveal(
                  0.0,
                  0.55,
                  rise: 26,
                  child: Center(
                    // The panel drifts a beat behind the card while the strip
                    // moves, giving the handover a little depth. At rest the
                    // shift is zero, so nothing sits displaced.
                    child: Transform.translate(
                      offset: Offset(-_parallax * shift, 0),
                      child: SizedBox.square(
                        dimension: artworkSize,
                        child: UspIllustration(
                          assetPath: slide.imageAsset,
                          description: slide.imageDescription,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                _reveal(
                  0.25,
                  0.8,
                  child: Text(
                    slide.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      color: AppPalette.ink,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _reveal(
                  0.45,
                  1.0,
                  child: Text(
                    slide.body,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.55,
                      color: OnboardingPalette.uspBody,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Card-by-card snapping for the strip.
///
/// Equivalent to page physics while the cards fill the viewport, but written
/// against the card extent so the snap stays correct if the two ever differ
/// again.
class _CardSnapPhysics extends ScrollPhysics {
  const _CardSnapPhysics({required this.cardExtent, super.parent});

  /// Width of one card, including its gutter.
  final double cardExtent;

  @override
  _CardSnapPhysics applyTo(ScrollPhysics? ancestor) {
    return _CardSnapPhysics(
      cardExtent: cardExtent,
      parent: buildParent(ancestor),
    );
  }

  /// The offset that leaves the nearest card centred, carried one card further
  /// when the drag was thrown rather than dropped.
  double _snapTarget(
    ScrollMetrics position,
    Tolerance tolerance,
    double velocity,
  ) {
    double card = position.pixels / cardExtent;

    if (velocity < -tolerance.velocity) {
      card -= 0.5;
    } else if (velocity > tolerance.velocity) {
      card += 0.5;
    }

    return (card.roundToDouble() * cardExtent).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    // Leave overscroll at the head of the strip to the platform's own physics.
    if ((velocity <= 0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }

    final Tolerance tolerance = toleranceFor(position);
    final double target = _snapTarget(position, tolerance, velocity);

    if ((target - position.pixels).abs() < tolerance.distance) {
      return null;
    }

    return ScrollSpringSimulation(
      spring,
      position.pixels,
      target,
      velocity,
      tolerance: tolerance,
    );
  }

  @override
  bool get allowImplicitScrolling => false;
}
