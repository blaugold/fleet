import 'package:fleet/fleet.dart';

export 'package:flutter/material.dart'
    hide
        Align,
        Center,
        ColoredBox,
        Column,
        Container,
        Flex,
        Opacity,
        Padding,
        Positioned,
        PositionedDirectional,
        Row,
        SizedBox,
        SliverOpacity,
        SliverPadding,
        Transform;

/// Fleet drop-in replacement for [Align].
typedef Align = FleetAlign;

/// Fleet drop-in replacement for [Center].
typedef Center = FleetCenter;

/// Fleet drop-in replacement for [ColoredBox].
typedef ColoredBox = FleetColoredBox;

/// Fleet drop-in replacement for [Column].
typedef Column = FleetColumn;

/// Fleet drop-in replacement for [Container].
typedef Container = FleetContainer;

/// Fleet drop-in replacement for [Flex].
typedef Flex = FleetFlex;

/// Fleet drop-in replacement for [Opacity].
typedef Opacity = FleetOpacity;

/// Fleet drop-in replacement for [Padding].
typedef Padding = FleetPadding;

/// Fleet drop-in replacement for [Positioned].
typedef Positioned = FleetPositioned;

/// Fleet drop-in replacement for [PositionedDirectional].
typedef PositionedDirectional = FleetPositionedDirectional;

/// Fleet drop-in replacement for [Row].
typedef Row = FleetRow;

/// Fleet drop-in replacement for [SizedBox].
typedef SizedBox = FleetSizedBox;

/// Fleet drop-in replacement for [SliverOpacity].
typedef SliverOpacity = FleetSliverOpacity;

/// Fleet drop-in replacement for [SliverPadding].
typedef SliverPadding = FleetSliverPadding;

/// Fleet drop-in replacement for [Transform].
typedef Transform = FleetTransform;