# 日記アプリ

## 手順
1. リポジトリをクローンする

2. ビルドする
    ```bash
    docker compose build
    ```

3. セットアップ
    ```bash
    docker compose run --rm web rails db:setup
    ```

4. 起動
    ```bash
    docker compose up
    ```