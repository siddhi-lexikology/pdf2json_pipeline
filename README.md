# pdf2json_pipeline

pdf2json_pipeline converts JEE exam page images into structured JSON using:

- Tesseract OCR
- Google Gemini (Vision model)
- A Python bulk extraction pipeline (one JSON per exam folder)

This pipeline works on image files (PNG/JPG/JPEG), not PDFs.
You will receive a ZIP containing the required exam image folders.

------------------------------------------------------------

## 1. Input Format

Your ZIP will contain:

- Each exam is a subfolder inside data/input/.
- Each exam folder must contain all page images.
- The last page contains the MathonGo-style answer key such as:

When the pipeline runs, one JSON file will be created in data/output/ for each exam.

------------------------------------------------------------

## 2. Requirements

To run using Docker you need:

1. Docker installed
2. Your own Google Gemini API key

No need to install Python or Tesseract locally.

------------------------------------------------------------

## 3. Project Files

pdf2json_pipeline/
  README.md
  Dockerfile
  requirements.txt
  src/
    pipeline.py
  data/
    input/     <-- exam folders (provided to you)
    output/    <-- JSON files will appear here

------------------------------------------------------------

## 4. Build the Docker Image

Inside the pdf2json_pipeline folder, open a terminal and run:

docker build -t pdf2json_pipeline .

This builds a container including:
- Tesseract OCR
- Python dependencies
- The extraction script
- Default input/output folders at /app/data/input and /app/data/output

------------------------------------------------------------

## 5. Input Data (Important)

You will be provided a ZIP that contains:

data/input/   (exam image folders)
data/output/  (empty)

Simply unzip it next to the project.
No manual setup is required.

------------------------------------------------------------

## 6. Run the Pipeline (Docker Only)

Use your own Gemini API key.

### Windows (PowerShell / CMD):

docker run --rm ^
  -e GEMINI_API_KEY=YOUR_GEMINI_API_KEY_HERE ^
  -v %cd%/data/input:/app/data/input ^
  -v %cd%/data/output:/app/data/output ^
  pdf2json_pipeline

### Linux / macOS:

docker run --rm \
  -e GEMINI_API_KEY=YOUR_GEMINI_API_KEY_HERE \
  -v "$PWD/data/input:/app/data/input" \
  -v "$PWD/data/output:/app/data/output" \
  pdf2json_pipeline

Replace YOUR_GEMINI_API_KEY_HERE with your actual Gemini API key.

------------------------------------------------------------

## 7. What Happens During Processing

For each exam folder:

1. Pages are sorted numerically
2. Last page → answer key extracted
3. Each page is OCR processed
4. Page + OCR text is sent to Gemini
5. Questions are merged and normalized
6. Missing correct_option values filled from answer key
7. Invalid questions (question_number <= 0) removed
8. JSON saved into data/output/<exam_name>.json

------------------------------------------------------------

## 8. Troubleshooting

- Error: GEMINI_API_KEY environment variable is not set  
  → Ensure -e GEMINI_API_KEY=... is included.

- No JSON files created  
  → Confirm exam folders exist in data/input/.
  → Confirm volume mapping paths are correct.

- "No images found, skipping this folder"  
  → Ensure exam folders contain PNG or JPG files.

------------------------------------------------------------

Pipeline workflow:
Docker build → Docker run → JSON files appear in data/output.
