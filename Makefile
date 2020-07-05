.PHONY:build
build:
	sudo docker build --force-rm=true -t mkl_on_docker .

.PHONY: run
run:
	xhost + local:root
	sudo docker run -it \
    --network="host" \
	--env=DISPLAY=$(DISPLAY) \
	--env=QT_X11_NO_MITSHM=1 \
	--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	--volume="$(CURDIR)/src:/app/src" \
	 mkl_on_docker /bin/bash
