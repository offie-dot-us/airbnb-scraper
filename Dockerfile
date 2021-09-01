FROM python:3.9-slim-buster

#############################################################
# Get Build Args
#############################################################
ARG API_KEY="d306zoyjsyarp7ifhu67rjxn52tv0t20"
ARG QUERY="Minneapolis, MN"
ARG OUT="Minneapolis.csv"

#############################################################
# Get Resources into container
#############################################################
COPY ./deepbnb/ /app/deepbnb
COPY ./requirements.txt /app
COPY ./scrapy.cfg /app

#############################################################
# Install dependencies
#############################################################
RUN cd /app && pip install -r requirements.txt \
  && cp /app/deepbnb/settings.py.dist /app/deepbnb/settings.py\ 
  && apt-get -y update \
  && apt-get -y upgrade \
  && apt-get -y install wget \
  && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
  && apt-get -y install ./google-chrome-stable_current_amd64.deb \
  && rm google-chrome-stable_current_amd64.deb

#############################################################
# Entry Point 
WORKDIR /app

ENV QUERY=${QUERY}
ENV OUT=${OUT}

# Create venv
# RUN python -m venv env

# Install required packages
# RUN pip install -Ur requirements.txt

# CMD "python3 scrapy -a query='${QUERY}' -o ${OUT}"

ENV SPIDER_NAME=deepbnb
ENV CRAWLER_FOLDER=/app
ENV USER=deepbnb
ENV SPIDER_NAME=airbnb

COPY init.sh /init.sh
ENTRYPOINT [ "/init.sh" ]
#############################################################


#ENTRYPOINT [ scrapy crawl airbnb -a query=${QUERY} -o ${OUT} ]

#############################################################
# Command with build args injected
#############################################################
# scrapy crawl airbnb -a query="Minneapolis, MN" -o mpls.csv
# docker build --build-arg user=what_user .



