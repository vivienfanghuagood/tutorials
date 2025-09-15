FROM rocm/vllm:latest

# Set environment variables to reduce prompts and enable UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python packages
RUN pip install --upgrade pip && \
    git clone -b rocm_enabled https://github.com/ROCm/bitsandbytes && cd bitsandbytes && cmake -DCOMPUTE_BACKEND=hip -S . -DBNB_ROCM_ARCH="gfx90a;gfx942" && make && pip install . && \
    pip install --upgrade --force-reinstall --no-cache-dir --no-deps git+https://github.com/vivienfanghuagood/unsloth.git && \
    pip install --upgrade --force-reinstall --no-cache-dir --no-deps git+https://github.com/unslothai/unsloth-zoo.git

RUN pip install trl peft transformers==4.56.1 matplotlib jupyter

# Replace modeling_utils.py with custom version
# RUN wget -O /usr/local/lib/python3.12/dist-packages/transformers/modeling_utils.py \
# https://gist.githubusercontent.com/vivienfanghuagood/ec4066bdffbc1bce635d1ab6e63bfd72/raw/9d3854aa8009aa2125eeff95871ecfe73e6dc105/modeling_utils.py && mkdir -p /root/.ipython/profile_default/startup

COPY disable_shell.py disable_shell.py /root/.ipython/profile_default/startup/
# COPY patch_diffusers.py patch_diffusers.py /root/.ipython/profile_default/startup/
COPY download.sh download.sh /app/

RUN cd /app && bash download.sh
