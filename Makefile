SHELL=/bin/bash
MANIFEST=./manifest
NAME=file-log
NAMESPACE=default
LOCAL_REGISTRY=10.254.0.50:5000
TAG=v1
IMAGE=centos:7
IMAGE_PULL_POLICY=IfNotPresent
LABELS_KEY=app
LABELS_VALUE=${NAME}
LOG=access.log

all: deploy

build:
	@docker build -t ${IMAGE} .

push:
	@docker push ${IMAGE}

cp:
	@find ${MANIFEST} -type f -name "*.sed" | sed s?".sed"?""?g | xargs -I {} cp {}.sed {}

sed:
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.name}}"?"${NAME}"?g
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.namespace}}"?"${NAMESPACE}"?g
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.image}}"?"${IMAGE}"?g
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.log}}"?"${LOG}"?g
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.image.pull.policy}}"?"${IMAGE_PULL_POLICY}"?g
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.labels.key}}"?"${LABELS_KEY}"?g
	@find ${MANIFEST} -type f -name "*.yaml" | xargs sed -i s?"{{.labels.value}}"?"${LABELS_VALUE}"?g

deploy: OP=create 
deploy: cp sed
deploy:
	@kubectl ${OP} -f ${MANIFEST}/.

clean: OP=delete
clean:
	@kubectl ${OP} -n ${NAMESPACE} all,cm -l ${LABELS_KEY}=${LABELS_VALUE} 
