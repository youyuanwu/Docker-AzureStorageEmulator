REPO ?= farmer1992
NAME = azure-storage-emulator
BaseImageTag = ltsc2016

$(info ${REPO}/${NAME})

image-ltsc2019: BaseImageTag := ltsc2019
image-ltsc2019:
	docker build --build-arg BaseImageTag=${BaseImageTag} \
		-t ${REPO}/${NAME}:windowsservercore-${BaseImageTag} \
		-t ${REPO}/${NAME}:latest \
		-f Dockerfile .

image-ltsc2016: BaseImageTag := ltsc2016
image-ltsc2016:
	docker build --build-arg BaseImageTag=${BaseImageTag} \
		-t ${REPO}/${NAME}:windowsservercore-${BaseImageTag} \
		-t ${REPO}/${NAME}:latest \
		-f Dockerfile .

run:
	mkdir -p data
	docker run -it --rm --name ${NAME} ${REPO}/${NAME}:latest