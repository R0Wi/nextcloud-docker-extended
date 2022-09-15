ARG BASE_IMAGE=nextcloud

FROM ${BASE_IMAGE}

RUN apt-get update && \
    apt-get install -y ocrmypdf smbclient tesseract-ocr-eng tesseract-ocr-deu && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

