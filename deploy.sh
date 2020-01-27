# to build images
docker build -t jesszhang/multi-client:latest -t jesszhang/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t jesszhang/multi-server:latest -t jesszhang/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t jesszhang/multi-worker:latest -t jesszhang/multi-worker:$SHA -f ./worker/Dockerfile ./worker


# push them to docker. we have already logged in to docker with travis.
docker push jesszhang/multi-client:latest
docker push jesszhang/multi-server:latest
docker push jesszhang/multi-worker:latest

docker push jesszhang/multi-client:SHA
docker push jesszhang/multi-server:SHA
docker push jesszhang/multi-worker:SHA

# apply all configs in k8s 
kubectl apply -f k8s
# Imperatively set latest images versions without specifying the version every time
kubectl set image deployments/server-deployment server=jesszhang/multi-server:$SHA  # the name property from the server-deployment.yaml
kubectl set image deployments/client-deployment client=jesszhang/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=jesszhang/multip-worker:$SHA

