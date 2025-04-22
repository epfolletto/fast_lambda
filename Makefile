include .env

run:
	poetry run uvicorn main:app --reload

image-build: 
	docker build -t fast_lambda .

image-push:
	aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin 932769097131.dkr.ecr.${REGION}.amazonaws.com
	docker tag fast_lambda:latest ${USER_ID}.dkr.ecr.${REGION}.amazonaws.com/evandro:latest
	docker push ${USER_ID}.dkr.ecr.${REGION}.amazonaws.com/evandro:latest

image-update-lambda:
	aws lambda update-function-code \
		--function-name fast_lambda \
		--image-uri ${USER_ID}.dkr.ecr.${REGION}.amazonaws.com/evandro:latest

deploy: image-build image-push image-update-lambda