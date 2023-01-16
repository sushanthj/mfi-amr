FROM osrf/ros:foxy-desktop
MAINTAINER Sush sush@cmu.edu

# Necessary to source things
SHELL ["/bin/bash", "-c"]

RUN apt-get update --fix-missing && \
    apt-get install -y \
    git \
    nano \
    python3-pip \
    tmux \
    python3-matplotlib \
    python3-ipdb \
    unzip \
    wget \
    zip

RUN pip3 install numpy
RUN pip3 install wandb

# create a ws for tutorials or trial scripts
RUN mkdir /home/dev_ws 
RUN cd /home/dev_ws/ && git clone https://github.com/ros/ros_tutorials.git -b foxy-devel

# clone the main repo
# RUN cd /home/ && git clone git@github.com:sushanthj/mfi-amr.git
# WORKDIR /home/mfi-amr

RUN source /opt/ros/foxy/setup.bash && \
    apt-get install python3-rosdep -y && \
    rosdep init && \
    rosdep update && \
    rosdep install -i --from-path src --rosdistro foxy -y && \
    apt install python3-colcon-common-extensions -y

# copy all contents of current dir (mfi-amr repo files) into docker
RUN mkdir /home/mfi-amr
COPY . /home/mfi-amr

# cleanup
RUN apt-get -qy autoremove

ADD .bashrc /root/.bashrc
echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc

# source setup.bash in WORKDIR
WORKDIR '/home/mfi-amr'
RUN source /opt/ros/foxy/setup.bash

ENTRYPOINT["/bin/bash"]
