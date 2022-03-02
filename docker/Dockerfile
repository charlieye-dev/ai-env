ARG BASE_IMG
From $BASE_IMG

RUN apt-get update && \
    apt install -y \
        sudo \
        openssh-server \
        vim \
        git \
        curl \
        wget \
        tree \
        zip \
        ctags \
        ack

# Add user 'tf'
RUN useradd -rm -s /bin/bash -g root -G sudo -u 1000 tf && \
    echo 'tf:testpass' | chpasswd

USER tf
WORKDIR /home/tf

#RUN wget https://raw.githubusercontent.com/yechenglin-dev/autovim/master/install.sh && \
#    bash install.sh && \
#    rm -f install.sh

# Configure anaconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash ./Miniconda3-latest-Linux-x86_64.sh -b -p /home/tf/miniconda && \
    eval "$(/home/tf/miniconda/bin/conda shell.bash hook)" && \
    conda init && \
    rm -f Miniconda3-latest-Linux-x86_64.sh

# Create python3.7 environment
RUN eval "$(/home/tf/miniconda/bin/conda shell.bash hook)" && \
    conda create -n py3.7 python=3.7 -y && \
    conda activate py3.7 && \
    conda install -y \
                  tensorflow-gpu \
                  pandas \
                  matplotlib \
                  scikit-learn \
                  pillow && \
    conda install -y -c conda-forge jupyterlab

# Set default environment
RUN echo "export PATH=/usr/local/cuda/bin:$PATH" >> .bashrc && \
    echo "export LD_LIBRARY_PATH=/usr/local/cuda/lib64" >> .bashrc && \
    echo "conda activate py3.7" >> .bashrc

# Generate jupyter server startup script
RUN echo '# Start jupyter-lab server\n\
jupyter-lab --ip 0.0.0.0 --no-browser >/dev/null 2>&1 &\n\
sleep 1\n\
jupyter-lab list' > run-jupyter.sh

# Config autoVim
ARG AUTO_VIM
RUN if [ ! x$AUTO_VIM = x"" ]; then \
        wget https://raw.githubusercontent.com/yechenglin-dev/autovim/master/install.sh && \
        bash install.sh && \
        rm -f install.sh; \
    fi

USER root

# Configure sshd
RUN service ssh start
EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
