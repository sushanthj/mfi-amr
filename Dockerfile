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
# RUN mkdir /home/dev_ws 
# RUN cd /home/dev_ws/ && git clone https://github.com/ros/ros_tutorials.git -b foxy-devel

# copy all contents of current dir (mfi-amr repo files) into docker
RUN mkdir /home/mfi-amr
COPY . /home/mfi-amr

# cleanup
RUN apt-get -qy autoremove

#ADD .bashrc /root/.bashrc
RUN echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc

# create a beginner workspace for now
WORKDIR /home/dev_ws/src
RUN git clone https://github.com/ros/ros_tutorials.git -b foxy-devel
WORKDIR /home/dev_ws

# after workspace is defined, run the 
RUN apt-get install python3-rosdep -y
RUN rosdep update
RUN rosdep install -i --from-path src --rosdistro foxy -y
RUN apt install python3-colcon-common-extensions -y

# source setup.bash in WORKDIR
WORKDIR '/home/mfi-amr'
RUN source /opt/ros/foxy/setup.bash

ENTRYPOINT ["/bin/bash"]
RUN source /opt/ros/foxy/setup.bash
