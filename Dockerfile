ARG BASE_IMAGE=nextcloud

FROM ${BASE_IMAGE}

RUN apt-get update && \
    apt-get install -y ocrmypdf smbclient tesseract-ocr-eng tesseract-ocr-deu tesseract-ocr-fra tesseract-ocr-ita tesseract-ocr-nld tesseract-ocr-pol && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

