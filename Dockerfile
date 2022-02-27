FROM python:3.7-stretch

ARG USERNAME=lead-score

# Install FreeTDS and dependencies
RUN apt-get update && \
    apt-get install -y \
        unixodbc \
        unixodbc-dev \
        freetds-dev \
        freetds-bin \
        tdsodbc \
    && apt-get install --reinstall build-essential -y

# Populate "ocbcinst.ini"
RUN echo "[FreeTDS]\n\
Description = FreeTDS unixODBC Driver\n\
Driver = /usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so\n\
Setup = /usr/lib/x86_64-linux-gnu/odbc/libtdsS.so" >> /etc/odbcinst.ini

RUN useradd --create-home ${USERNAME}
USER ${USERNAME}
WORKDIR /app

ADD --chown=${USERNAME} leadscore /app/leadscore
ADD --chown=${USERNAME} close_train.py /app/close_train.py
ADD --chown=${USERNAME} requirements.txt /app/requirements.txt

#RUN mkdir -p /app/encoding

RUN pip install --no-cache-dir \
    -r requirements.txt \
    -r /app/leadscore/training/requirements.txt
ENTRYPOINT ["python3"]
