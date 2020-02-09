# to build images
docker build -t jesszhang/multi-client:latest -t jesszhang/multi-client:$SHA -f ./client/Dockerfile ./client  #two tags applied to the images. git sha. we will use this to indicate a new image and triger the new build.
docker build -t jesszhang/multi-server:latest -t jesszhang/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t jesszhang/multi-worker:latest -t jesszhang/multi-worker:$SHA -f ./worker/Dockerfile ./worker


# push them to docker. we have already logged in to docker with travis. both tags so if another person downloads this code and run it locally the images will still be good.
docker push jesszhang/multi-client:latest
docker push jesszhang/multi-server:latest
docker push jesszhang/multi-worker:latest

docker push jesszhang/multi-client:$SHA
docker push jesszhang/multi-server:$SHA
docker push jesszhang/multi-worker:$SHA

# apply all configs in k8s.  in travis.yml we have installed kubectl to travis.
kubectl apply -f k8s
# Imperatively set latest images versions without specifying the version every time
kubectl set image deployments/server-deployment server=jesszhang/multi-server:$SHA  # the name property from the server-deployment.yaml
kubectl set image deployments/client-deployment client=jesszhang/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=jesszhang/multi-worker:$SHA

