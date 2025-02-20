FROM debian:stretch

RUN set -ex \
	&& apt-get update \
	&& apt-get install -y python-mapnik python-pip \
	&& pip install tilestache gunicorn pyyaml

WORKDIR /server

ADD fonts /usr/share/fonts/truetype
ADD themes themes
ADD shapefiles shapefiles

ADD tilestache.yaml .
ADD wsgi.py .
ADD providers.py .

VOLUME /server/cache

CMD ["gunicorn", "wsgi:application", "-w", "8", "-t", "4", "-b", "0.0.0.0:80", "--access-logfile", "-"]
