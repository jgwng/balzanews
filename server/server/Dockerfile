FROM python:3.7

# Install required dependencies, including flask-cors
RUN pip install flask gunicorn flask-cors requests
# Copy the application files
COPY src/ app/
WORKDIR /app

# Expose the application port
EXPOSE 8080

# Run the application using Gunicorn
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 app:app