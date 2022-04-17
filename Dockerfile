FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=Asia/Seoul
ENV LANG=ko_KR.UTF-8
ENV LANGUAGE=ko_KR.UTF-8
ENV LC_ALL=ko_KR.UTF-8
ENV PYTHONIOENCODING=UTF-8

RUN sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list\
  && apt update -q -y \
  && apt install -q -y wget git vim python3-pip jq libssl-dev \
    telnet \
    language-pack-ko locales \
    ca-certificates curl gnupg lsb-release \
    build-essential libffi-dev libbz2-dev zlib1g-dev libreadline-dev libsqlite3-dev \
  && apt-get clean \ 
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN localedef -f UTF-8 -i ko_KR ko_KR.UTF-8 \
  && export LANG=ko_KR.utf8 \
  && export LC_ALL=ko_KR.utf8

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
  && echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
  && apt update -q -y \
  && apt install -q -y docker-ce docker-ce-cli containerd.io \
  && apt-get clean \ 
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -fsSL "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
  && chmod +x /usr/local/bin/docker-compose \
  && ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

RUN curl -k -fsSL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash \
  && echo '\n\
export PYENV_ROOT="$HOME/.pyenv"\n\
export PATH="$PYENV_ROOT/bin:$PATH"\n\
if command -v pyenv 1>/dev/null 2>&1; then\n\
  eval "$(pyenv init --path)"\n\
  eval "$(pyenv virtualenv-init -)"\n\
fi\n\n\
export HISTSIZE=10000\n\
export HISTFILESIZE=10000\n\
export HISTTIMEFORMAT="[%Y-%m-%d %H:%M:%S] "\n\n\
export PS1="\[\e[33m\]\u\[\e[m\]\[\e[37m\]@\[\e[m\]\[\e[34m\]\h\[\e[m\]:\[\033[01;31m\]\W\[\e[m\]$ "\n' \
    >> ~/.bashrc \
  && /root/.pyenv/bin/pyenv install 3.7.13 \
  && /root/.pyenv/bin/pyenv global 3.7.13

RUN pip3 install --upgrade pip setuptools wheel \
  && pip3 install awscli \
  && pip3 install asn1crypto \
  && pip3 install bcrypt \
  && pip3 install boto3 \
  && pip3 install botocore \
  && pip3 install certifi \
  && pip3 install cffi \
  && pip3 install Fabric3 \
  && pip3 install ipcalc \
  && pip3 install Jinja2 \
  && pip3 install paramiko \
  && pip3 install requests \
  && pip3 install rsa \
  && pip3 install stormssh \
  && pip3 install termcolor \
  && pip3 install typing \
  && pip3 install urllib3

RUN git clone https://github.com/anti1346/fabric.git /root/fabric-ctl

WORKDIR /root/fabric-ctl

VOLUME ["/root/fabric-ctl"]

ENTRYPOINT ["/bin/bash"]
