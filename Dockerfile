FROM python:3.9-slim-buster

COPY ./deepbnb/ /app/deepbnb
COPY ./requirements.txt /app
COPY scrapy.cfg /app

ARG API_KEY="d306zoyjsyarp7ifhu67rjxn52tv0t20"
ARG QUERY="Minneapolis, MN"
ARG OUT="Minneapolis.xlsx"

RUN cd /app && pip install -r requirements.txt

RUN cp /app/deepbnb/settings.py.dist /app/deepbnb/settings.py

RUN apt-get update \
  && apt-get upgrade \
  && apt-get -y install wget \
  && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
  && apt-get -y install ./google-chrome-stable_current_amd64.deb \
  && rm google-chrome-stable_current_amd64.deb

WORKDIR /app

RUN scrapy crawl airbnb -a query=${QUERY} -o ${OUT}


#scrapy crawl airbnb -a query="Minneapolis, MN" -o mpls.csv
#docker build --build-arg user=what_user .



