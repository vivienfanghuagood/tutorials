FROM rocm/vllm:latest

# Set environment variables to reduce prompts and enable UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python packages
RUN pip install --upgrade pip && \
    pip install accelerate==1.10.0 librosa soundfile numpy==1.26.4 && \
    pip install --no-deps moshi==0.2.11 && \
    pip install sentence_transformers==5.1.0 && \
    pip install 'sphn<0.2' && \
    pip install diffusers peft==0.17.0 matplotlib jupyter

# Replace modeling_utils.py with custom version
RUN wget -O /usr/local/lib/python3.12/dist-packages/transformers/modeling_utils.py \
https://gist.githubusercontent.com/vivienfanghuagood/ec4066bdffbc1bce635d1ab6e63bfd72/raw/dadfc8a36eeaf31655ef884c3e2c4d5b95c960e5/modeling_utils.py && mkdir -p /root/.ipython/profile_default/startup

COPY disable_shell.py disable_shell.py /root/.ipython/profile_default/startup
COPY patch_diffusers.py patch_diffusers.py /root/.ipython/profile_default/startup
