from pdf2image import convert_from_path
import pytesseract
from PIL import Image
import os

PDF_PATH = 'pdfs/1-A_t.pdf'
IMG_DIR = 'pdfs/ocr_images'
TXT_DIR = 'pdfs/ocr_texts'

os.makedirs(IMG_DIR, exist_ok=True)
os.makedirs(TXT_DIR, exist_ok=True)

def pdf_to_images(pdf_path, out_dir):
    images = convert_from_path(pdf_path)
    img_paths = []
    for i, img in enumerate(images):
        img_path = os.path.join(out_dir, f'page_{i+1}.png')
        img.save(img_path)
        img_paths.append(img_path)
    return img_paths

def ocr_images(img_paths, out_dir):
    for img_path in img_paths:
        img = Image.open(img_path)
        text = pytesseract.image_to_string(img, lang='jpn')
        base = os.path.splitext(os.path.basename(img_path))[0]
        txt_path = os.path.join(out_dir, f'{base}.txt')
        with open(txt_path, 'w', encoding='utf-8') as f:
            f.write(text)
        print(f'OCR done: {txt_path}')

def main():
    print('Converting PDF to images...')
    img_paths = pdf_to_images(PDF_PATH, IMG_DIR)
    print('Running OCR on images...')
    ocr_images(img_paths, TXT_DIR)
    print('All done!')

if __name__ == '__main__':
    main() 