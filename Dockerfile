FROM continuumio/anaconda3:latest

RUN apt-get update && apt-get install -y automake \
                                         libtool \
                                         build-essential \
                                         libncurses5-dev
                                         
ENV BUILD_DIR=/home/build
ENV HOME_DIR=/home/shared
ENV WORK_DIR=${HOME_DIR}/workspace

RUN mkdir -p ${BUILD_DIR}
RUN mkdir -p ${HOME_DIR}
RUN mkdir -p ${WORK_DIR}

RUN conda install -y numpy h5py lxml pandas matplotlib jsonschema scipy

# Install NEURON for BioNet
RUN conda install -y -c kaeldai neuron

### Install the bmtk
RUN cd ${BUILD_DIR}; \
    git clone https://github.com/AllenInstitute/bmtk.git; \
    cd bmtk; \
    python setup.py install

ENV NB_USER mizzou
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

# Pre-compile mechanisms
# RUN cd ${HOME}/my_bmtk_model/biophys_components/mechanisms; \
# nrnivmodl modfiles/

# Start Flask
# source env/bin/activate
# honcho start -f Local
