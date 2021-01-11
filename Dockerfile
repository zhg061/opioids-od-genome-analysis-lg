FROM ucsdets/scipy-ml-notebook:2020.2.9

USER root

# install samtools
RUN apt-get install --yes ncurses-dev libbz2-dev liblzma-dev && \
    cd /teams/DSC180A_FA20_A00/b04genetics/group_4/opioids-od-genome-analysis/opt && \
    wget -q https://github.com/samtools/samtools/releases/download/1.10/samtools-1.10.tar.bz2 && \
    tar xvfj samtools-1.10.tar.bz2 && \
    cd samtools-1.10 && \
    ./configure && \
    make && \
    make install

# install bcftools
RUN apt-get install --yes ncurses-dev libbz2-dev liblzma-dev && \
    cd /teams/DSC180A_FA20_A00/b04genetics/group_4/opioids-od-genome-analysis/opt && \
    wget -q https://github.com/samtools/bcftools/releases/download/1.10.2/bcftools-1.10.2.tar.bz2 && \
    tar xvfj bcftools-1.10.2.tar.bz2 && \
    cd bcftools-1.10.2 && \
    ./configure && \
    make && \
    make install

# FastQC
RUN wget http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.5.zip -P /teams/DSC180A_FA20_A00/b04genetics/group_4/opioids-od-genome-analysis/tmp && \
    unzip /teams/DSC180A_FA20_A00/b04genetics/group_4/opioids-od-genome-analysis/tmp/fastqc_v0.11.5.zip && \
    mv FastQC /teams/DSC180A_FA20_A00/b04genetics/group_4/opioids-od-genome-analysis/opt/ && \
    rm -rf /teams/DSC180A_FA20_A00/b04genetics/group_4/opioids-od-genome-analysis/tmp/fastqc_* && \
    chmod 777 /teams/DSC180A_FA20_A00/b04genetics/group_4/opioids-od-genome-analysis/opt/FastQC/fastqc

# Kallisto
RUN wget https://github.com/pachterlab/kallisto/releases/download/v0.42.4/kallisto_linux-v0.42.4.tar.gz -P /teams/DSC180A_FA20_A00/b04genetics/group_4/opioids-od-genome-analysis/tmp && \
    tar -xvf /teams/DSC180A_FA20_A00/b04genetics/group_4/opioids-od-genome-analysis/tmp/kallisto_linux-v0.42.4.tar.gz && \
    mv kallisto_* /teams/DSC180A_FA20_A00/b04genetics/group_4/opioids-od-genome-analysis/opt/ && \
    rm /teams/DSC180A_FA20_A00/b04genetics/group_4/opioids-od-genome-analysis/tmp/kallisto_linux-v0.42.4.tar.gz

# HTSeq
RUN pip install HTSeq

RUN rm -rf /teams/DSC180A_FA20_A00/b04genetics/group_4/opioids-od-genome-analysis/opt/*.bz2 && \
    chmod -R +x /teams/DSC180A_FA20_A00/b04genetics/group_4/opioids-od-genome-analysis/opt/*

# DESeq & QuASAR
COPY r-bio.yaml /teams/DSC180A_FA20_A00/b04genetics/group_4/opioids-od-genome-analysis/tmp
RUN conda env create --file /teams/DSC180A_FA20_A00/b04genetics/group_4/opioids-od-genome-analysis/tmp/r-bio.yaml && \
    rm -rf /teams/DSC180A_FA20_A00/b04genetics/group_4/opioids-od-genome-analysis/opt/conda/bin/R /teams/DSC180A_FA20_A00/b04genetics/group_4/opioids-od-genome-analysis/opt/conda/lib/R && \
    ln -s /teams/DSC180A_FA20_A00/b04genetics/group_4/opioids-od-genome-analysis/opt/conda/envs/r-bio/bin/R /teams/DSC180A_FA20_A00/b04genetics/group_4/opioids-od-genome-analysis/opt/conda/bin/R && \
    ln -s /teams/DSC180A_FA20_A00/b04genetics/group_4/opioids-od-genome-analysis/opt/conda/envs/r-bio/lib/R /teams/DSC180A_FA20_A00/b04genetics/group_4/opioids-od-genome-analysis/opt/conda/lib/R
    
# Install WGCNA    
RUN mkdir /teams/DSC180A_FA20_A00/b04genetics/group_4/opioids-od-genome-analysis/opt/iterativeWGCNA && \
    git clone https://github.com/cstoeckert/iterativeWGCNA.git && \
    cd /teams/DSC180A_FA20_A00/b04genetics/group_4/opioids-od-genome-analysis/opt/iterativeWGCNA && \
    python setup.py install
    
    
USER $NB_UID
