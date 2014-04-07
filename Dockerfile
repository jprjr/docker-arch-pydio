FROM jprjr/php-fpm

MAINTAINER John Regan <john@jrjrtech.com>

RUN pacman -Syy --noconfirm --quiet > /dev/null

RUN pacman -S --noconfirm --quiet --needed rsync \
    imagemagick ghostscript git >/dev/null 2>/dev/null

RUN pear install channel://pear.php.net/VersionControl_Git-0.4.4

RUN sed -i '/^file_uploads/c \
file_uploads = On' /etc/php/php.ini

RUN sed -i '/^post_max_size/c \
post_max_size = 2G' /etc/php/php.ini

RUN sed -i '/^upload_max_filesize/c \
upload_max_filesize = 2G' /etc/php/php.ini

RUN sed -i '/^max_file_uploads/c \
max_file_uploads = 20000' /etc/php/php.ini

RUN sed -i '/^output_buffering/c \
output_buffering = Off' /etc/php/php.ini

RUN sed -i '/^open_basedir/c \
open_basedir = /srv/http/:/tmp/:/usr/share/pear/:/var/lib/pydio/' /etc/php/php.ini

RUN cd /srv/http && \
    mkdir -p /var/lib/pydio &&  \
    mkdir -p /usr/share/pydio && \
    curl -R -L \
    "http://downloads.sourceforge.net/project/ajaxplorer/pydio/stable-channel/5.2.3/pydio-core-5.2.3.tar.gz" \
    | tar xz && \
    mv pydio-core-5.2.3/data /usr/share/pydio/data-5.2.3  && \
    ln -s /srv/http/pydio-core-5.2.3 /srv/http/pydio && \
    ln -s /var/lib/pydio/data /srv/http/pydio/data && \
    chown -R http:http /srv/http && \
    chown -R http:http /var/lib/pydio && \
    chown -R http:http /usr/share/pydio 
    
ADD init_data_folder.sh /opt/init_data_folder.sh

# Volume to export
VOLUME /srv/http/pydio
VOLUME /var/lib/pydio/data
