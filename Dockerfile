# Use Ubuntu 20.04 as the base image
FROM python:3.11

# Set the maintainer label
LABEL maintainer="Your Name <your.email@example.com>"

# Set the working directory inside the container
WORKDIR /app

# Update package lists and install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        gcc \
        build-essential \
        libpq-dev \
        python3 \
        python3-pip \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt /app/requirements.txt
RUN pip3 install --no-cache-dir -r /app/requirements.txt

# Copy the rest of the application code into the container
COPY . /app

# Copy the dbt profiles.yml to the appropriate directory
RUN mkdir -p /root/.dbt
COPY .dbt/profiles.yml /root/.dbt/profiles.yml

# Set the default command to run when the container starts
CMD ["dbt", "run"]
RUN echo "Starting pip install"
RUN pip3 install --no-cache-dir -r /app/requirements.txt || echo "Failed to install requirements"
RUN echo "Completed pip install"
