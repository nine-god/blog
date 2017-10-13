    FROM ruby:2.4.1
    MAINTAINER cym2017 191176233@qq.com

    # 使用rubychina gems源
    RUN gem source -a https://gems.ruby-china.org
    RUN gem install rails5
  

