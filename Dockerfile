# Use official Python 3.10 slim image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install system dependencies required for Pillow and rembg
RUN apt-get update && apt-get install -y \
    build-essential \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    wget \
 && rm -rf /var/lib/apt/lists/*

# Copy requirements first for caching
COPY requirements.txt .

# Upgrade pip and install Python dependencies
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Pre-download U-2-Net model for rembg
RUN python -c "from rembg import remove; from PIL import Image; import io; remove(Image.new('RGB', (64,64)))"

# Expose port
EXPOSE 5000

# Start the Flask app using Gunicorn
CMD gunicorn --bind 0.0.0.0:$PORT app:app --workers=2 --threads=2

