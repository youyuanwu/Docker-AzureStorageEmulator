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

PWD_WIN := $(shell cmd.exe /c 'echo %cd%')
run:
	mkdir -p data
	docker run -it --rm -v '${PWD_WIN}\data':'C:\data' --name ${NAME} ${REPO}/${NAME}:latest

clean:
	rm -rf data