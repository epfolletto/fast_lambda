include .env

run:
	poetry run uvicorn main:app --reload

image-build: 
	docker build -t ${IMAGE_NAME} .

image-push:
	aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${USER_ID}.dkr.ecr.${REGION}.amazonaws.com
	docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${USER_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPOSITORY_NAME}:${REPOSITORY_TAG}
	docker push ${USER_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPOSITORY_NAME}:${REPOSITORY_TAG}

image-update-lambda:
	aws lambda update-function-code \
		--function-name ${IMAGE_NAME} \
		--image-uri ${USER_ID}.dkr.ecr.${REGION}.amazonaws.com/${REPOSITORY_NAME}:${REPOSITORY_TAG}

deploy: image-build image-push image-update-lambda