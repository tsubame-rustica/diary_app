#!/bin/bash
set -e

# サーバー起動時にpidファイルが残っているとエラーになるため削除
rm -f /myapp/tmp/pids/server.pid

# DockerfileのCMDを実行
exec "$@"