# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set environment variables
ENV PYTHONUNBUFFERED 1
ENV DJANGO_SETTINGS_MODULE notification_system.settings

# Set the working directory
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt /app/

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the current directory contents into the container at /app/
COPY . /app/

# Expose the port that the application will run on
EXPOSE 8000

# Start the application with Gunicorn
RUN apt update \
    && apt install -y wget \
    && apt install -y unzip \
    && apt install -y vim \
    && apt install -y openssh-client
RUN wget https://releases.hashicorp.com/terraform/0.15.4/terraform_0.15.4_linux_amd64.zip 
RUN unzip terraform_0.15.4_linux_amd64.zip 
RUN mv terraform /usr/local/bin/
RUN terraform version
CMD ["gunicorn", "--workers=2", "--bind", "0.0.0.0:8000", "notification_system.wsgi:application"]
