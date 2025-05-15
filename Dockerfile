###########
# BUILDER #
###########

# pull official base image
FROM python:3.10.9-slim as builder

# set work directory
WORKDIR /app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt update 
RUN apt install curl wget htop -y

######################################################################################################################## 
                                                #Setting up PSE Requirements
######################################################################################################################## 
COPY pse.crt /usr/local/share/ca-certificates/pse.crt
RUN update-ca-certificates

ARG ir_proxy
ARG host_ip
ARG SCAN_ID
ENV http_proxy=${ir_proxy}
ENV https_proxy=${ir_proxy}
ENV HTTP_PROXY=${ir_proxy}
ENV HTTPS_PROXY=${ir_proxy}
RUN echo "Value of https_proxy: $https_proxy"
# For pip specifically, you might also need:
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
ENV NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

######################################################################################################################## 
######################################################################################################################## 

RUN apt update
RUN apt install ansible

# RUN apk update 
# RUN apk upgrade 
# RUN apk add postgresql-dev gcc python3-dev musl-dev

# install dependencies

RUN pip install --upgrade pip && apk add --no-cache --virtual .build-deps build-base curl-dev

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --upgrade pip


# #########
# # FINAL #
# #########

# # pull official base image
# FROM python:3.10.9-alpine

# # create directory for the user
# RUN mkdir -p /home/apiuser

# # create the user
# RUN addgroup -S apiuser && adduser -S apiuser -G apiuser

# # create the appropriate directories
# ENV HOME=/home/apiuser
# ENV APP_HOME=/home/apiuser/fuel-api
# RUN mkdir $APP_HOME
# RUN mkdir $APP_HOME/staticfiles
# RUN mkdir $APP_HOME/mediafiles
# WORKDIR $APP_HOME


# ######################################################################################################################## 
#                                                 #Setting up PSE Requirements
# ######################################################################################################################## 
# ARG ir_proxy
# ARG host_ip
# ARG SCAN_ID
# ENV http_proxy=${ir_proxy}
# ENV https_proxy=${ir_proxy}
# ENV HTTP_PROXY=${ir_proxy}
# ENV HTTPS_PROXY=${ir_proxy}


# RUN echo "Value of https_proxy: $https_proxy"


# # For pip specifically, you might also need:
# ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
# ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
# ENV NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt
# ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
    

# COPY --from=builder /usr/local/share/ca-certificates/pse.crt /usr/local/share/ca-certificates/pse.crtdest
# RUN update-ca-certificates

# ######################################################################################################################## 
# ######################################################################################################################## 

# COPY --from=builder /app/requirements.txt requirements.txt


# RUN apk update 
# RUN apk upgrade 
# RUN apk add libpq libexpat=2.6.4-r0 
# RUN apk add --no-cache --virtual .build-deps build-base curl-dev 
# RUN pip install --upgrade pip  
# RUN pip install --upgrade setuptools


# RUN pip install --no-cache-dir -r requirements.txt

# RUN apk add docker htop 

# RUN env

# RUN rm -f /usr/local/share/ca-certificates/pse.crt && update-ca-certificates --fresh

# RUN ls /usr/local/share/ca-certificates/

# # Reset environment variables to default
# ENV http_proxy ""
# ENV https_proxy ""
# ENV HTTP_PROXY ""
# ENV HTTPS_PROXY ""
# ENV REQUESTS_CA_BUNDLE ""
# ENV SSL_CERT_FILE ""
# ENV NODE_EXTRA_CA_CERTS ""

# RUN env

# #ENTRYPOINT ["./entrypoint.sh"]
