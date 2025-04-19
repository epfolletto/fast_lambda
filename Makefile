run:
	poetry run uvicorn main:app --reload

image-build: 
	docker build -t fast_lambda .

image-push:
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 932769097131.dkr.ecr.us-east-1.amazonaws.com
	docker tag fast_lambda:latest 932769097131.dkr.ecr.us-east-1.amazonaws.com/evandro:latest
	docker push 932769097131.dkr.ecr.us-east-1.amazonaws.com/evandro:latest	

image-update-lambda:
	aws lambda update-function-code \
		--function-name fast_lambda \
		--image-uri 932769097131.dkr.ecr.us-east-1.amazonaws.com/evandro:latest

image-deploy: image-build image-push image-update-lambda