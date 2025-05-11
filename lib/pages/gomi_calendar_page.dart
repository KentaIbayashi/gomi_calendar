import 'package:flutter/material.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/services.dart' show rootBundle;

const String ICS_PATH = 'assets/ics/asahikawa_gomi_2026.ics';

class GomiCalendarPage extends StatefulWidget {
  const GomiCalendarPage({super.key});

  @override
  State<GomiCalendarPage> createState() => _GomiCalendarPageState();
}

class _GomiCalendarPageState extends State<GomiCalendarPage> {
  Map<DateTime, List<Map<String, dynamic>>> gomiEvents = {};
  CalendarFormat _calendarFormat = CalendarFormat.month;
  bool _icsLoaded = false;
  String? _error;
  DateTime _selectedDay = DateTime(2026, 1, 1);

  @override
  void initState() {
    super.initState();
    parseIcsFromFile();
  }

  Future<void> parseIcsFromFile() async {
    try {
      final icsString = await rootBundle.loadString(ICS_PATH);
      final calendar = ICalendar.fromString(icsString);
      final events =
          calendar.data.where((item) => item['type'] == 'VEVENT').toList();
      setState(() {
        gomiEvents = {};
        for (final event in events) {
          final dtObj = event['dtstart'];
          DateTime? dt;
          if (dtObj is IcsDateTime) {
            dt = dtObj.toDateTime();
          } else if (dtObj is DateTime) {
            dt = dtObj;
          }
          if (dt != null) {
            final date = DateTime(dt.year, dt.month, dt.day);
            gomiEvents.putIfAbsent(date, () => []).add(event);
          }
        }
        _icsLoaded = true;
      });
    } catch (e) {
      setState(() {
        _error = 'ICSファイルの読み込みに失敗しました: $e';
        _icsLoaded = true;
      });
    }
  }

  List<Map<String, dynamic>> filterGomiEvents(
      List<Map<String, dynamic>> events) {
    // icsの全イベントを返す（フィルタ不要ならこのまま）
    return events;
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return gomiEvents[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    if (!_icsLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('ゴミカレンダー')),
        body: Center(child: Text(_error!)),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('ゴミカレンダー')),
      body: Column(
        children: [
          TableCalendar<Map<String, dynamic>>(
            firstDay: DateTime.utc(2026, 1, 1),
            lastDay: DateTime.utc(2026, 12, 31),
            focusedDay: _selectedDay,
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: _getEventsForDay,
            calendarStyle: const CalendarStyle(
              markerDecoration:
                  BoxDecoration(color: Colors.green, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: _getEventsForDay(_selectedDay)
                  .map((event) => ListTile(
                        title: Text(event['summary'] ?? ''),
                        subtitle: Text(event['dtstart']?.toString() ?? ''),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
