FROM python:3.11-slim

# Install Tesseract OCR
RUN apt-get update && apt-get install -y --no-install-recommends \
    tesseract-ocr \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install Python deps
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy code
COPY src/ /app/src/

# Create data dirs
RUN mkdir -p /app/data/input /app/data/output

# Default paths inside container
ENV ROOT_IMAGE_DIR=/app/data/input
ENV OUTPUT_DIR=/app/data/output

CMD ["python", "-u", "src/pipeline.py"]
