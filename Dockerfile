FROM binhex/arch-base
MAINTAINER binhex

# install application
#####################

# update package databases for arch
RUN pacman -Sy --noconfirm

# run pacman to install application
RUN pacman -S deluge python2-mako --noconfirm

# docker settings
#################

# map /config to host defined config path (used to store configuration from app)
VOLUME /config

# map /data to host defined data path (used to store data from app)
VOLUME /data

# expose port for http
EXPOSE 8112

# expose port for https
EXPOSE 8122

# expose port for torrent data
EXPOSE 53160
EXPOSE 53160/udp

# expose port for deluge daemon
EXPOSE 58846

# set permissions
#################

# change owner
RUN chown nobody:users /usr/bin/deluged
RUN chown nobody:users /usr/bin/deluge-web

# set permissions
RUN chmod 775 /usr/bin/deluged
RUN chmod 775 /usr/bin/deluge-web

# add conf file
###############

ADD deluge.conf /etc/supervisor/conf.d/deluge.conf

# run supervisor
################

# run supervisor
CMD ["supervisord", "-c", "/etc/supervisor.conf", "-n"]