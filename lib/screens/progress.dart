import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstapp/models/user.dart';
import 'package:firstapp/screens/diary.dart';
import 'package:firstapp/services/user.dart';
import 'package:firstapp/services/utils.dart';
// import 'package:firstapp/widgets/calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:firstapp/widgets/graph.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Progress extends StatefulWidget {
  @override
  _Progress createState() => _Progress();
}

class _Progress extends State<Progress> {
  String formattedDate = DateFormat('MM/dd/yyyy').format(DateTime.now());

  var selectedDateMessage = "Select a date";
  late final ValueNotifier<List<Event>> _selectedEvents;
  String graphType = "Weight";
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  void _setGraphType(String selectedGraphType) {
    Navigator.pop(context);
    setState(() {
      graphType = selectedGraphType;
    });
  }

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      // String date = formattedDate.replaceAll("/", "_");
      // String formattedFocusedDay = DateFormat('MM/dd/yyyy').format(focusedDay);
      // formattedFocusedDay.replaceAll("/", "_");
      // DatabaseService(uid: uid).buildEventFromDatabase(formattedFocusedDay);
      String date = formattedDate.replaceAll("/", "_");
      DatabaseService(uid: uid).buildEventFromDatabase(date);
      setState(() {});

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
        stream: UserService(uid: uid).getUserInfo(uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserModel? userData = snapshot.data;

            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Stack(
                  children: <Widget>[
                    NotificationListener<OverscrollIndicatorNotification>(
                      onNotification:
                          (OverscrollIndicatorNotification overScroll) {
                        overScroll.disallowGlow();
                        return false;
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              color: Colors.transparent,
                              height: 400,
                              width: 500,
                              child: Card(
                                elevation: 0,
                                color: Colors.grey.shade100,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: TableCalendar(
                                  calendarStyle: CalendarStyle(
                                    selectedDecoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle),
                                    todayDecoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        shape: BoxShape.circle),
                                    markerDecoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle),
                                    markersMaxCount: 1,
                                  ),
                                  rangeStartDay: _rangeStart,
                                  rangeEndDay: _rangeEnd,
                                  rangeSelectionMode: _rangeSelectionMode,
                                  eventLoader: _getEventsForDay,
                                  headerStyle: const HeaderStyle(
                                    titleCentered: true,
                                    formatButtonVisible: false,
                                  ),
                                  focusedDay: _focusedDay,
                                  firstDay: DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month - 12,
                                      DateTime.now().day),
                                  lastDay: DateTime(DateTime.now().year,
                                      DateTime.now().month, DateTime.now().day),
                                  startingDayOfWeek: StartingDayOfWeek.monday,
                                  selectedDayPredicate: (day) =>
                                      isSameDay(_selectedDay, day),
                                  onDaySelected: _onDaySelected,
                                  onPageChanged: (focusedDay) {
                                    focusedDay = focusedDay;
                                  },
                                  calendarFormat: _calendarFormat,
                                ),
                              ),
                            ),

                            // Container(
                            //     height: 200,
                            //     width: 200,
                            //     child: ValueListenableBuilder<List<Event>>(
                            //         valueListenable: _selectedEvents,
                            //         builder: (context, value, _) {
                            //           return ListView.builder(
                            //             itemCount: value.length,
                            //             itemBuilder: (context, index) {
                            //               return Container(
                            //                 margin: const EdgeInsets.symmetric(
                            //                   horizontal: 12.0,
                            //                   vertical: 4.0,
                            //                 ),
                            //                 decoration: BoxDecoration(
                            //                   border: Border.all(),
                            //                   borderRadius:
                            //                       BorderRadius.circular(12.0),
                            //                 ),
                            //                 child: ListTile(
                            //                   onTap: () =>
                            //                       print('${value[index]}'),
                            //                   title: Text('${value[index]}'),
                            //                 ),
                            //               );
                            //             },
                            //           );
                            //         })),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  const Text(
                                    "Select a date",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => diary(),
                                        ),
                                      );
                                      setState(() {});
                                    },
                                    child: const Text(
                                      "Edit Workout",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              child: Card(
                                color: Colors.grey.shade100,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Card(
                                      elevation: 0,
                                      color: Colors.grey.shade100,
                                      child: Container(
                                        child: ValueListenableBuilder<
                                                List<Event>>(
                                            valueListenable: _selectedEvents,
                                            builder: (context, value, _) {
                                              return ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: value.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    child: value[index]
                                                                .exerciseType ==
                                                            ""
                                                        ? Text("test")
                                                        : Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  "${value[index].exerciseType}",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          18)),
                                                              Text(
                                                                  "${value[index].sets}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey
                                                                          .shade700))
                                                            ],
                                                          ),
                                                  );
                                                },
                                              );
                                            }),
                                      )),
                                ),
                              ),
                            ),
                            // Container(
                            //   margin: const EdgeInsets.symmetric(
                            //       horizontal: 20, vertical: 15),
                            //   color: Colors.transparent,
                            //   width: 500,
                            //   child: Card(
                            //     shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(20)),
                            //     elevation: 0,
                            //     color: Colors.grey.shade100,
                            //     child: Column(
                            //       children: [
                            //         TextButton(
                            //           style: TextButton.styleFrom(
                            //             splashFactory: NoSplash.splashFactory,
                            //           ),
                            //           onPressed: () {
                            //             showModalBottomSheet(
                            //               shape: new RoundedRectangleBorder(
                            //                   borderRadius:
                            //                       new BorderRadius.circular(
                            //                           20)),
                            //               context: context,
                            //               builder: (context) {
                            //                 return Container(
                            //                   decoration: BoxDecoration(
                            //                     color: Theme.of(context)
                            //                         .canvasColor,
                            //                     borderRadius:
                            //                         const BorderRadius.only(
                            //                       topLeft: Radius.circular(20),
                            //                       topRight: Radius.circular(20),
                            //                     ),
                            //                   ),
                            //                   child: Column(
                            //                     mainAxisSize: MainAxisSize.min,
                            //                     mainAxisAlignment:
                            //                         MainAxisAlignment.center,
                            //                     children: [
                            //                       ListTile(
                            //                           title:
                            //                               const Text('Weight'),
                            //                           onTap: () =>
                            //                               _setGraphType(
                            //                                   'Weight')),
                            //                       ListTile(
                            //                           title: const Text(
                            //                               'Bench Press'),
                            //                           onTap: () =>
                            //                               _setGraphType(
                            //                                   'Bench Press')),
                            //                       ListTile(
                            //                           title: const Text(
                            //                               'Tricep Extension'),
                            //                           onTap: () => _setGraphType(
                            //                               'Tricep Extension')),
                            //                     ],
                            //                   ),
                            //                 );
                            //               },
                            //             );
                            //           },
                            //           child: Row(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.center,
                            //             children: [
                            //               Text(graphType,
                            //                   style: TextStyle(
                            //                     color: Colors.grey.shade700,
                            //                     fontWeight: FontWeight.bold,
                            //                     fontSize: 20,
                            //                   )),
                            //               Icon(
                            //                 Icons.arrow_drop_down_outlined,
                            //                 color: Colors.grey.shade700,
                            //               )
                            //             ],
                            //           ),
                            //         ),
                            //         const Graph(),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
