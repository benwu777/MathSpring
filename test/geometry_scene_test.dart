import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mathspring/main.dart';
import 'package:mathspring/models/geometry_scene.dart';

Map<String, dynamic> sampleParams() => <String, dynamic>{
      'kind': 'geometry_scene',
      'bounds': {'minX': 0, 'minY': 0, 'maxX': 6, 'maxY': 6},
      'points': [
        {'name': 'A', 'x': 0, 'y': 6, 'pos': 'tl'},
        {'name': 'C', 'x': 6, 'y': 0, 'pos': 'br'},
        {'name': 'F', 'x': 4, 'y': 2, 'pos': 'r'},
      ],
      'segments': [
        {'from': 'A', 'to': 'C', 'style': 'construction'},
      ],
      'polygons': [
        {
          'vertices': ['A', 'F', 'C'],
          'fill': 'shaded'
        },
      ],
      'arcs': [
        {'cx': 0, 'cy': 5, 'r': 5, 'from': 0, 'to': 180},
      ],
      'angleMarks': [
        {'at': 'A', 'from': 'C', 'to': 'F', 'label': '40°'},
      ],
      'rightAngles': [
        {'at': 'F', 'from': 'A', 'to': 'C'},
      ],
      'equalTicks': [
        {
          'segments': [
            ['A', 'F'],
            ['F', 'C']
          ],
          'count': 1
        },
      ],
    };

void main() {
  test('parses named points into math coordinates', () {
    final GeometryScene scene = GeometryScene.fromParams(sampleParams());
    expect(scene.points['A'], const Offset(0, 6));
    expect(scene.points['C'], const Offset(6, 0));
    expect(scene.points['F'], const Offset(4, 2));
  });

  test('keeps construction-only points out of the visible point layer', () {
    final Map<String, dynamic> params = sampleParams();
    (params['points'] as List).add(
      {'name': 'M', 'x': 3, 'y': 3, 'visible': false},
    );

    final GeometryScene scene = GeometryScene.fromParams(params);

    expect(scene.points['M'], const Offset(3, 3));
    expect(scene.pointIsVisible['M'], isFalse);
    expect(scene.pointIsVisible['A'], isTrue);
  });

  test('parses all primitive collections', () {
    final GeometryScene scene = GeometryScene.fromParams(sampleParams());
    expect(scene.segments, hasLength(1));
    expect(scene.segments.single.style, GeometryLineStyle.construction);
    expect(scene.polygons.single.vertices, <String>['A', 'F', 'C']);
    expect(scene.arcs, hasLength(1));
    expect(scene.angleMarks.single.label, '40°');
    expect(scene.rightAngles, hasLength(1));
    expect(scene.equalTicks.single.count, 1);
  });

  test('toScreen flips y and scales within square bounds', () {
    final GeometryScene scene = GeometryScene.fromParams(sampleParams());
    const Size size = Size(100, 100);
    final Offset a = scene.toScreen(const Offset(0, 6), size, padding: 10);
    final Offset c = scene.toScreen(const Offset(6, 0), size, padding: 10);
    expect(a.dx, closeTo(10, 0.01));
    expect(a.dy, closeTo(10, 0.01));
    expect(c.dx, closeTo(90, 0.01));
    expect(c.dy, closeTo(90, 0.01));
  });

  test('toScreen centers content for non-square bounds', () {
    final Map<String, dynamic> params = sampleParams();
    params['bounds'] = {'minX': -6, 'minY': 0, 'maxX': 6, 'maxY': 8};
    final GeometryScene scene = GeometryScene.fromParams(params);
    const Size size = Size(120, 120);
    final Offset bl = scene.toScreen(const Offset(-6, 0), size, padding: 0);
    final Offset tr = scene.toScreen(const Offset(6, 8), size, padding: 0);
    // width 12, height 8, scale=min(120/12,120/8)=10 -> content 120x80, vertical pad 20
    expect(bl.dx, closeTo(0, 0.01));
    expect(bl.dy, closeTo(100, 0.01));
    expect(tr.dx, closeTo(120, 0.01));
    expect(tr.dy, closeTo(20, 0.01));
  });

  test('pointToScreen resolves a point by name', () {
    final GeometryScene scene = GeometryScene.fromParams(sampleParams());
    const Size size = Size(100, 100);
    final Offset byName = scene.pointToScreen('C', size, padding: 10);
    final Offset byCoord =
        scene.toScreen(const Offset(6, 0), size, padding: 10);
    expect(byName, byCoord);
  });

  testWidgets('GeometryScenePainter renders a full scene without throwing',
      (WidgetTester tester) async {
    final GeometryScene scene = GeometryScene.fromParams(sampleParams());
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: CustomPaint(painter: GeometryScenePainter(scene: scene)),
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });
}
