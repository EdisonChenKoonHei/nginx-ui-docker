# nginx-ui-docker
base openresty Build nginx-ui (from 0xJacky/nginx-ui)

# 对比原本改变
尽可能复用原有项目的gitlab ci
替换了基础镜像为调优后的openresty(相当于nginx+lua)
调整nginx.conf


sites-available
sites-enabled
ssl
stream.conf.d
streams-available
streams-enabled