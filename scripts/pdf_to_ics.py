import re
from datetime import datetime, timedelta
from PyPDF2 import PdfReader

PDF_PATH = 'pdfs/1-A_t.pdf'
ICS_PATH = 'output.ics'

# ゴミ種別のキーワード例（必要に応じて追加）
GOMI_TYPES = [
    '燃えるゴミ', '燃えないゴミ', '資源ごみ', 'プラ', 'ペットボトル', '缶', 'ビン', '古紙', '容器包装', '有害ごみ'
]

# 日付パターン例: 6/10(月) など
DATE_PATTERN = r'(\d{1,2})/(\d{1,2})[\(（][^\)）]+[\)）]'


def extract_text_from_pdf(pdf_path):
    reader = PdfReader(pdf_path)
    text = ''
    for page in reader.pages:
        text += page.extract_text() + '\n'
    return text


def find_gomi_events(text):
    events = []
    for gomi_type in GOMI_TYPES:
        # 例: "燃えるゴミ 6/10(月) 6/17(月) ..."
        pattern = rf'{gomi_type}[^\d]*(.*)'
        matches = re.findall(pattern, text)
        for match in matches:
            # 各日付を抽出
            dates = re.findall(DATE_PATTERN, match)
            for month, day in dates:
                events.append({
                    'type': gomi_type,
                    'month': int(month),
                    'day': int(day)
                })
    return events


def generate_ics(events, year=None):
    if year is None:
        year = datetime.now().year
    ics = [
        'BEGIN:VCALENDAR',
        'VERSION:2.0',
        'PRODID:-//gomi_calendar//EN'
    ]
    for event in events:
        dt = datetime(year, event['month'], event['day'], 7, 0, 0)
        dtend = dt + timedelta(hours=1)
        ics.extend([
            'BEGIN:VEVENT',
            f'SUMMARY:{event["type"]}',
            f'DTSTART;TZID=Asia/Tokyo:{dt.strftime("%Y%m%dT%H%M%S")}',
            f'DTEND;TZID=Asia/Tokyo:{dtend.strftime("%Y%m%dT%H%M%S")}',
            f'DESCRIPTION:{event["type"]}の回収日です。',
            'END:VEVENT'
        ])
    ics.append('END:VCALENDAR')
    return '\n'.join(ics)


def main():
    text = extract_text_from_pdf(PDF_PATH)
    events = find_gomi_events(text)
    if not events:
        print('No events found.')
        return
    ics_str = generate_ics(events)
    with open(ICS_PATH, 'w', encoding='utf-8') as f:
        f.write(ics_str)
    print(f'ICS file generated: {ICS_PATH}')

if __name__ == '__main__':
    main() 