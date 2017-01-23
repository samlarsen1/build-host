
docker stop temp
docker rm temp
docker rmi nginx-test
exec docker build -t nginx-test images/nginx/ --no-cache
exec docker run --name temp -p 80:80 nginx-test
exec docker ps 
