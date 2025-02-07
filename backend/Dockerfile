# Use an official Python runtime as a parent image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install FastAPI dependencies
RUN pip install --no-cache-dir fastapi uvicorn google-cloud-vision Pillow requests

# Expose the FastAPI port
EXPOSE 8000

# Command to run FastAPI
CMD exec uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}
