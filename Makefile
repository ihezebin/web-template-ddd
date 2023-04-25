#BRANCH ?= `git rev-parse --abbrev-ref HEAD`
#COMMIT ?= `git rev-parse --short HEAD`
TAG ?= `git describe --tags --always`
PROJECT_ROOT = `pwd`
PROJECT_NAME = 'go-template-ddd'
DOCKER_REGISTRY = registry.cn-chengdu.aliyuncs.com
DOCKER_USER ?= test-user
DOCKER_PWD ?= test-pwd
DOCKER_TAG ?= $(DOCKER_REGISTRY)/hezebin/$(PROJECT_NAME):$(TAG)

package: tag clean

tag: init test build
	docker login --username=$(DOCKER_USER) --password=$(DOCKER_PWD) $(DOCKER_REGISTRY)
	docker build -t $(DOCKER_TAG) -f Dockerfile .
	docker push $(DOCKER_TAG)
	echo $(DOCKER_TAG)


init:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64

test:
	go test -tags=unit -timeout 30s -short -v `go list ./...`

build:
	go build -o ./dist/$(PROJECT_NAME) $(PKG_ROOT)

clean:
	rm -rf ./dist;

