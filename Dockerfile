#
# PX4 ROS2 development environment
# Based from container under https://github.com/osrf/docker_images/tree/master/ros2/source/devel
#

FROM px4io/px4-dev-ros2-eloquent:2020-03-16
LABEL maintainer="Karl Stich <karl-johannes.stich@atos.net>"

# setup environment
ENV ROS1_DISTRO melodic
ENV ROS2_DISTRO eloquent

RUN rosdep fix-permissions
RUN rosdep update

# Intall foonathan_memory from source as it is required to Fast-RTPS >= 1.9
RUN mkdir -p /opt/px4 \
        && git clone https://github.com/PX4/Firmware.git /opt/px4/firmware \
        && cd /opt/px4/firmware \
        && git checkout v1.10.1 \
        && make px4_sitl_default
        # && make px4_sitl_default none_iris

COPY ./entrypoint.sh /usr/local/bin/
COPY ./start-px4-sitl.sh /opt/px4/firmware/

CMD /opt/px4/firmware/start-px4-sitl.sh
