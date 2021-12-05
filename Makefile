.DEFAULT_GOAL := build

ifndef APP
	APP=example
endif

ifndef TAG
	TAG := 0.0.0
endif

ifndef IMAGE_REPO
	IMAGE_REPO=$(USER)/$(APP)
endif


print:
	@echo "\n$(APP) $(TAG)"

build: mac-build
run: mac-run
clean:
	@echo "\nClean workspace"
	rm -f $(APP)-*
	go clean -modcache
	go clean -testcache


mac-build: env-mac-darwin go-build
	@echo "\nMac Build for Application: $(APP) Version: $(TAG) Completed"
mac-run: env-mac-darwin go-run
	@echo "\nMac Run for Application: $(APP) Version: $(TAG) Completed"

linux-build: env-linux-amd64 go-build docker-build docker-push
	@echo "\nLinux Build for Application: $(APP) Version: $(TAG) Completed"
linux-run: env-linux-amd64 go-run
	@echo "\nLinux Run for Application: $(APP) Version: $(TAG) Completed"


env-mac-darwin:
	@echo "\nSet environment for Mac"
	GOOS=linux GOARCH=amd64
env-linux-amd64:
	@echo "\nSet environment for Linux"
	GOOS=linux GOARCH=amd64

go-build:
	@echo "\nBuilding Go Binary"
	go clean -modcache
	go clean -testcache
	echo ${GOOS} ${GOARCH}
	go build -o $(APP)-$(TAG)
go-run: go-build
	@echo "\nStarting Go Binary"
	# go run ./...
	./$(APP)-$(TAG)

docker-build:
	@echo "\nRemove if duplicate docker image"
	docker image rm --force $(APP):$(TAG) 2> /dev/null
	@echo "\nBuild docker image"
	docker build --no-cache --rm --build-arg app=$(APP) --tag $(APP):$(TAG) .

docker-push: env-linux-amd64 docker-build
	@echo "\nPush docker image to repository"
	# docker tag $(APP):$(TAG) $(IMAGE_REPO):$(TAG)
	# docker tag $(APP):$(TAG) $(IMAGE_REPO):latest
	# docker push $(IMAGE_REPO):$(TAG)
	# docker push $(IMAGE_REPO):latest
