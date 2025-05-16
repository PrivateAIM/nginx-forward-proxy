A simple forward proxy based on nginx for testing purposes.
Based on the [`ngx_http_proxy_connect_module`](https://github.com/chobits/ngx_http_proxy_connect_module) project.

# Build and run

```
docker build -t nginx-forward-proxy:latest .
docker run --rm -p 3128:3128 nginx-forward-proxy:latest
```

By default, the proxy binds to port 3128.
You can check if it works using `curl -x http://localhost:3128 https://privateaim.de`.
