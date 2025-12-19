# ベースイメージにUbuntu 22.04を指定
FROM ubuntu:22.04

# Rubyのバージョン指定
ARG RUBY_VERSION=3.3.0
# インストール時の対話入力をスキップさせる設定
ENV DEBIAN_FRONTEND=noninteractive

# 1. 必要なパッケージのインストール
# git, curl: ツール
# build-essential, libssl-dev等: Rubyのビルドに必要
# libmysqlclient-dev: MySQL接続(mysql2 gem)に必要
# libyaml-dev: psych gemに必要
RUN apt-get update -qq && apt-get install -y \
    git \
    curl \
    build-essential \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    libffi-dev \
    libyaml-dev \
    libmysqlclient-dev \
    tzdata \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. ruby-buildを使ってRubyをインストール
# rbenvは使わず、直接 /usr/local にインストールして全ユーザーが使えるようにします
RUN git clone https://github.com/rbenv/ruby-build.git /tmp/ruby-build && \
    /tmp/ruby-build/install.sh && \
    ruby-build ${RUBY_VERSION} /usr/local && \
    rm -rf /tmp/ruby-build

# 3. Bundlerのインストール
RUN gem update --system && gem install bundler

# 4. 作業ディレクトリの設定
WORKDIR /myapp

# 5. Gemfileのコピーとインストール
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install

# 6. エントリーポイントの設定
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# 7. ポートと起動コマンド
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]