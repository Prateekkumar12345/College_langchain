# Use official Python 3.12 image
FROM python:3.12-slim

# Prevent Python from writing pyc files & buffering stdout
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Working directory
WORKDIR /app

# Install system dependencies (for pandas, openpyxl, sqlite)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        libpq-dev \
        libssl-dev \
        libffi-dev \
        curl \
        && rm -rf /var/lib/apt/lists/*

# Copy requirements first for caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy the app code
COPY . .

# Expose FastAPI port
EXPOSE 8000

# Environment variables (optional)
ENV DB_PATH=/app/chatbot.db
ENV EXCEL_PATH=/app/colleges.xlsx
# Set OPENAI_API_KEY at runtime via docker run -e OPENAI_API_KEY=...

# Default command to run FastAPI app with uvicorn
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
