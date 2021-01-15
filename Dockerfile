FROM ghcr.io/opensafely/base-docker

RUN \
  apt-get update --fix-missing && \
  apt-get install -y python3.8 python3.8-dev python3-pip git curl unixodbc-dev && \
  update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1

# Install mssql tools
RUN \
  apt-get install -y gnupg && \
  curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
  curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
  apt-get update && \
  ACCEPT_EULA=Y apt-get install -y msodbcsql17 && \
  ACCEPT_EULA=Y apt-get install -y mssql-tools

ENV PATH=$PATH:/opt/mssql-tools/bin

# Copy in app code and install requirements
RUN \
  mkdir /app && \
  mkdir /workspace
COPY . /app
RUN \
  python -m pip install --upgrade pip && \
  python -m pip install --requirement /app/requirements.txt && \
  python -m pip install --editable /app

WORKDIR /workspace

# It's helpful to see output immediately
ENV PYTHONUNBUFFERED=True

ENTRYPOINT ["cohortextractor"]
