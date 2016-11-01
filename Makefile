default: build

build: buildfinal

run: buildfinal
	docker run --rm --net=host --volume $$(PWD)/.env:/app/.env mariocarrion/small-go-docker-skeleton

clean:
	rm -rf ca-certificates.crt main && \
		docker rmi $$(docker images -f "dangling=true" -q)

buildfinal: builddocker
	docker run --tty mariocarrion/small-go-docker-skeleton:build /bin/true && \
		docker cp `docker ps -q -n=1`:/main . && \
		docker cp `docker ps -q -n=1`:/etc/ssl/certs/ca-certificates.crt . && \
		chmod 755 ./main && \
		docker rm `docker ps -q -n=1` && \
		docker build --rm --tag mariocarrion/small-go-docker-skeleton --file ./Dockerfile.static .

builddocker:
	docker build --tag mariocarrion/small-go-docker-skeleton:build --file ./Dockerfile.build .

gobuild:
	CGO_ENABLED=0 GOOS=linux go build \
							--ldflags="-s" -a -installsuffix cgo -o main ./go/src/github.com/MarioCarrion/small-go-docker-skeleton


