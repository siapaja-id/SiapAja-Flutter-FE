flutter run -d linux
Waiting for another flutter command to release the startup lock...
Launching lib/main.dart on Linux in debug mode...
Building Linux application...                                           
✓ Built build/linux/x64/debug/bundle/siapaja_flutter_fe
Gdk-Message: 15:05:45.410: Unable to load  from the cursor theme
Syncing files to device Linux...                                     208ms

Flutter run key commands.
r Hot reload. 🔥🔥🔥
R Hot restart.
h List all available interactive commands.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).

A Dart VM Service on Linux is available at:
http://127.0.0.1:44721/lPmqPgBtj8c=/
The Flutter DevTools debugger and profiler on Linux is available
at:
http://127.0.0.1:44721/lPmqPgBtj8c=/devtools/?uri=ws://127.0.0.1:4
4721/lPmqPgBtj8c=/ws

══╡ EXCEPTION CAUGHT BY RENDERING LIBRARY
╞═════════════════════════════════════════════════════════
The following assertion was thrown during performLayout():
BoxConstraints forces an infinite width.
These invalid constraints were provided to RenderPositionedBox's
layout() function by the following
function, which probably computed the invalid constraints in
question:
  RenderFractionallySizedOverflowBox.performLayout
(package:flutter/src/rendering/shifted_box.dart:1298:14)
The offending constraints were:
  BoxConstraints(w=Infinity, 0.0<=h<=Infinity)

The relevant error-causing widget was:
  FractionallySizedBox
  FractionallySizedBox:file:///home/realme-book/Project/code/siapa
  ja-flutter-FE/lib/features/feed/pages/feed_page.dart:535:20

When the exception was thrown, this was the stack:
#0      BoxConstraints.debugAssertIsValid.<anonymous
closure>.throwError (package:flutter/src/rendering/box.dart:549:9)
#1      BoxConstraints.debugAssertIsValid.<anonymous closure>
(package:flutter/src/rendering/box.dart:611:11)
#2      BoxConstraints.debugAssertIsValid
(package:flutter/src/rendering/box.dart:619:6)
#3      RenderObject.layout
(package:flutter/src/rendering/object.dart:2668:19)
#4      RenderFractionallySizedOverflowBox.performLayout
(package:flutter/src/rendering/shifted_box.dart:1298:14)
#5      RenderObject.layout
(package:flutter/src/rendering/object.dart:2768:7)
#6      RenderStack.layoutPositionedChild
(package:flutter/src/rendering/stack.dart:549:11)
#7      RenderStack.performLayout
(package:flutter/src/rendering/stack.dart:691:13)
#8      RenderObject.layout
(package:flutter/src/rendering/object.dart:2768:7)
#9      RenderConstrainedBox.performLayout
(package:flutter/src/rendering/proxy_box.dart:296:14)
#10     RenderObject.layout
(package:flutter/src/rendering/object.dart:2768:7)
#11     ChildLayoutHelper.layoutChild
(package:flutter/src/rendering/layout_helper.dart:62:11)
#12     RenderFlex._computeSizes
(package:flutter/src/rendering/flex.dart:1237:28)
#13     RenderFlex.performLayout
(package:flutter/src/rendering/flex.dart:1329:32)
#14     RenderObject.layout
(package:flutter/src/rendering/object.dart:2768:7)
#15     RenderPadding.performLayout
(package:flutter/src/rendering/shifted_box.dart:262:12)
#16     RenderObject.layout
(package:flutter/src/rendering/object.dart:2768:7)
#17     RenderProxyBoxMixin.performLayout
(package:flutter/src/rendering/proxy_box.dart:118:18)
#18     RenderObject.layout
(package:flutter/src/rendering/object.dart:2768:7)
#19     RenderProxyBoxMixin.performLayout
(package:flutter/src/rendering/proxy_box.dart:118:18)
#20     RenderObject.layout
(package:flutter/src/rendering/object.dart:2768:7)
#21     RenderProxyBoxMixin.performLayout
(package:flutter/src/rendering/proxy_box.dart:118:18)
#22     _RenderCustomClip.performLayout
(package:flutter/src/rendering/proxy_box.dart:1549:11)
#23     RenderObject.layout
(package:flutter/src/rendering/object.dart:2768:7)
#24     RenderConstrainedBox.performLayout
(package:flutter/src/rendering/proxy_box.dart:296:14)
#25     RenderObject.layout
(package:flutter/src/rendering/object.dart:2768:7)
#26     RenderProxyBoxMixin.performLayout
(package:flutter/src/rendering/proxy_box.dart:118:18)
#27     RenderObject.layout
(package:flutter/src/rendering/object.dart:2768:7)
#28     RenderStack.layoutPositionedChild
(package:flutter/src/rendering/stack.dart:549:11)
#29     RenderStack.performLayout
(package:flutter/src/rendering/stack.dart:691:13)
#30     RenderObject.layout
(package:flutter/src/rendering/object.dart:2768:7)
(package:flutter/src/rendering/object.dart:1174:18)
#134    PipelineOwner.flushLayout
(package:flutter/src/rendering/object.dart:1187:15)
#135    RendererBinding.drawFrame
(package:flutter/src/rendering/binding.dart:629:23)
#136    WidgetsBinding.drawFrame
(package:flutter/src/widgets/binding.dart:1304:13)
#137    RendererBinding._handlePersistentFrameCallback
(package:flutter/src/rendering/binding.dart:495:5)
#138    SchedulerBinding._invokeFrameCallback
(package:flutter/src/scheduler/binding.dart:1430:15)
#139    SchedulerBinding.handleDrawFrame
(package:flutter/src/scheduler/binding.dart:1345:9)
#140    SchedulerBinding.scheduleWarmUpFrame.<anonymous closure>
(package:flutter/src/scheduler/binding.dart:1055:9)
#141    PlatformDispatcher.scheduleWarmUpFrame.<anonymous closure>
(dart:ui/platform_dispatcher.dart:906:16)
#145    _RawReceivePort._handleMessage
(dart:isolate-patch/isolate_patch.dart:193:12)
(elided 3 frames from class _Timer and dart:async-patch)

The following RenderObject was being processed when the exception
was fired: RenderFractionallySizedOverflowBox#9a7b8
relayoutBoundary=up3 NEEDS-LAYOUT NEEDS-PAINT
NEEDS-COMPOSITING-BITS-UPDATE:
  creator: FractionallySizedBox ← Positioned ← AnimatedPositioned
  ← Stack ← SizedBox ← _TabBar ← Row ←
    Padding ← DecoratedBox ← Container ← BackdropFilter ← ClipRect
    ← ⋯
  parentData: bottom=0.0; left=0.0; offset=Offset(0.0, 0.0) (can
  use size)
  constraints: BoxConstraints(unconstrained)
  size: MISSING
  alignment: Alignment.center
  textDirection: ltr
  widthFactor: 0.5
  heightFactor: pass-through
This RenderObject had the following descendants (showing up to
depth 5):
    child: RenderPositionedBox#91486 NEEDS-LAYOUT NEEDS-PAINT
    NEEDS-COMPOSITING-BITS-UPDATE
      child: RenderConstrainedBox#0f52c NEEDS-LAYOUT NEEDS-PAINT
      NEEDS-COMPOSITING-BITS-UPDATE
        child: RenderDecoratedBox#f910f NEEDS-LAYOUT NEEDS-PAINT
        NEEDS-COMPOSITING-BITS-UPDATE
          child: RenderPadding#053bb NEEDS-LAYOUT NEEDS-PAINT
══════════════════════════════════════════════════════════════════
══════════════════════════════════

Another exception was thrown: RenderBox was not laid out:
RenderFractionallySizedOverflowBox#9a7b8 relayoutBoundary=up3
NEEDS-PAINT NEEDS-COMPOSITING-BITS-UPDATE
Another exception was thrown:
'package:flutter/src/rendering/object.dart': Failed assertion:
line 5737 pos 14: '!childSemantics.renderObject._needsLayout': is
not true.
Another exception was thrown:
'package:flutter/src/rendering/object.dart': Failed assertion:
line 5493 pos 14: '!semantics.parentDataDirty': is not true.
Another exception was thrown:
'package:flutter/src/rendering/object.dart': Failed assertion:
line 5493 pos 14: '!semantics.parentDataDirty': is not true.
Another exception was thrown:
'package:flutter/src/rendering/object.dart': Failed assertion:
line 5493 pos 14: '!semantics.parentDataDirty': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line

'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/rendering/object.dart': Failed assertion:
line 5493 pos 14: '!semantics.parentDataDirty': is not true.
Another exception was thrown:
'package:flutter/src/rendering/object.dart': Failed assertion:
line 5493 pos 14: '!semantics.parentDataDirty': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/rendering/object.dart': Failed assertion:
line 5493 pos 14: '!semantics.parentDataDirty': is not true.
Another exception was thrown:
'package:flutter/src/rendering/object.dart': Failed assertion:
line 5493 pos 14: '!semantics.parentDataDirty': is not true.
Another exception was thrown:
'package:flutter/src/rendering/object.dart': Failed assertion:
line 5493 pos 14: '!semantics.parentDataDirty': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.

1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/rendering/object.dart': Failed assertion:
line 5493 pos 14: '!semantics.parentDataDirty': is not true.
Another exception was thrown:
'package:flutter/src/rendering/object.dart': Failed assertion:
line 5493 pos 14: '!semantics.parentDataDirty': is not true.
Another exception was thrown:
'package:flutter/src/rendering/object.dart': Failed assertion:
line 5493 pos 14: '!semantics.parentDataDirty': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/rendering/object.dart': Failed assertion:
line 5493 pos 14: '!semantics.parentDataDirty': is not true.
Another exception was thrown:
'package:flutter/src/rendering/object.dart': Failed assertion:
line 5493 pos 14: '!semantics.parentDataDirty': is not true.
Another exception was thrown:
'package:flutter/src/rendering/object.dart': Failed assertion:
line 5493 pos 14: '!semantics.parentDataDirty': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line
1280 pos 16: 'debugFrameWasSentToEngine': is not true.
Another exception was thrown:
'package:flutter/src/widgets/binding.dart': Failed assertion: line