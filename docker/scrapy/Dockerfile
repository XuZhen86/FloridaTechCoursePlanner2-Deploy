FROM python:slim

# Install Cron
RUN apt-get update
RUN apt-get install -y --no-install-recommends cron

# Install Scrapy
RUN apt-get install -y --no-install-recommends gcc python3-dev make
RUN pip install --no-cache-dir scrapy
