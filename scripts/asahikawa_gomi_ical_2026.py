from datetime import datetime, timedelta
import calendar

ICS_PATH = 'asahikawa_gomi_2026.ics'
YEAR = 2026

# ゴミ種別とルール
RULES = [
    {
        'summary': '燃やせるごみ',
        'weekday': [0, 3],  # 月曜(0), 木曜(3)
        'interval': 1,
    },
    {
        'summary': '燃やせないごみ',
        'weekday': [1],  # 火曜(1)
        'interval': 2,   # 隔週
        'offset': 0,     # 1月最初の火曜から
    },
    {
        'summary': 'ダンボール',
        'weekday': [1],  # 火曜(1)
        'interval': 2,   # 隔週
        'offset': 1,     # 1月2週目の火曜から
    },
    {
        'summary': '空き缶',
        'weekday': [2],  # 水曜(2)
        'interval': 1,
    },
    {
        'summary': 'プラスチック製容器包装',
        'weekday': [4],  # 金曜(4)
        'interval': 1,
    },
]


def get_dates(year, weekday, interval=1, offset=0):
    dates = []
    dt = datetime(year, 1, 1)
    # 最初の該当曜日まで進める
    while dt.weekday() != weekday:
        dt += timedelta(days=1)
    # オフセット（隔週のズレ）
    dt += timedelta(weeks=offset)
    while dt.year == year:
        dates.append(dt)
        dt += timedelta(weeks=interval)
    return dates


def generate_ics(rules, year):
    ics = [
        'BEGIN:VCALENDAR',
        'VERSION:2.0',
        'PRODID:-//asahikawa_gomi_calendar//EN'
    ]
    for rule in rules:
        for wd in rule['weekday']:
            interval = rule.get('interval', 1)
            offset = rule.get('offset', 0)
            dates = get_dates(year, wd, interval, offset)
            for dt in dates:
                dtstart = dt.replace(hour=7, minute=0, second=0)
                dtend = dtstart + timedelta(hours=1)
                ics.extend([
                    'BEGIN:VEVENT',
                    f'SUMMARY:{rule["summary"]}',
                    f'DTSTART;TZID=Asia/Tokyo:{dtstart.strftime("%Y%m%dT%H%M%S")}',
                    f'DTEND;TZID=Asia/Tokyo:{dtend.strftime("%Y%m%dT%H%M%S")}',
                    f'DESCRIPTION:{rule["summary"]}の回収日です。',
                    'END:VEVENT'
                ])
    ics.append('END:VCALENDAR')
    return '\n'.join(ics)


def main():
    ics_str = generate_ics(RULES, YEAR)
    with open(ICS_PATH, 'w', encoding='utf-8') as f:
        f.write(ics_str)
    print(f'ICS file generated: {ICS_PATH}')

if __name__ == '__main__':
    main() 