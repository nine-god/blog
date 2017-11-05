FROM ruby:2.4.1
MAINTAINER cym2017 191176233@qq.com

RUN apt-get update
# 安装 JS runtime，一定要装
RUN apt-get install -y nodejs

# 将 Dockerfile 目录下所有内容复制到容器工作目录
 COPY . .

# 安装 Rails 环境
# 使用rubychina gems源
RUN gem source -a https://gems.ruby-china.org
RUN bundle config mirror.https://rubygems.org https://gems.ruby-china.org
RUN bundle install
