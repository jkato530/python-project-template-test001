# Pythonプロジェクトテンプレート

モダンなPythonプロジェクトのためのテンプレートリポジトリです。

このテンプレートは、フォーマット、リンティング、型チェック、そして自動コミットメッセージ生成のためのツールが事前に設定された、堅牢な開発環境を提供します。これにより、高品質なコードと一貫したワークフローが保証されます。

## 特徴 (Features)

- **開発環境**: 高速なパッケージ管理とPythonのバージョン管理のため、`uv`を使用します。
- **リンティング & フォーマット**: 超高速なリンター兼フォーマッターである[Ruff](https://github.com/astral-sh/ruff)が設定済みです。
- **型チェック**: 静的型チェックのための[MyPy](http://mypy-lang.org/)が含まれています。
- **自動チェック**: コミット前にチェックを自動実行するため、[pre-commit](https://pre-commit.com/)を使用します。
- **標準化されたコミット**:
  - [OpenCommit](https://github.com/di-sukharev/opencommit)が、AI（Gemini）を使用してコミットメッセージを自動生成します。
  - [commitlint](https://commitlint.js.org/)が、すべてのコミットメッセージがConventional Commits標準に準拠していることを保証します。

## 使い方 (How to Use)

### A) 新しいプロジェクトを作成する場合

1.  このページの上部にある「**Use this template**」ボタンをクリックして、新しいリポジトリを作成します。
2.  作成したリポジトリをローカルにクローンし、下記のセットアップ手順に進みます。

### B) 既存のプロジェクトに適用する場合

1.  既存のプロジェクトのディレクトリで、このテンプレートリポジトリを`remote`として追加します。
    ```bash
    git remote add template https://github.com/jkato530/python-project-template
    ```
2.  テンプレートのコンテンツを取得します。
    ```bash
    git fetch template
    ```
3.  テンプレートの`main`ブランチを、現在のブランチにマージします。
    ```bash
    # 履歴が繋がっていないため --allow-unrelated-histories が必要になる場合があります
    git merge template/main --allow-unrelated-histories
    ```
4.  コンフリクトがあれば解決し、下記のセットアップ手順に進みます。

---

## 開発環境のセットアップ (Development Environment Setup)

### 1. Pythonのバージョン

本プロジェクトではPython `3.13` を使用します。`.python-version` ファイルにバージョンが定義されており、`uv`はこのファイルを自動的に尊重して適切なPythonインタプリタを使用します。

### 2. 依存関係のインストール

パッケージ管理には `uv` を使用します。以下のコマンドで、開発に必要なライブラリをインストールしてください。

```bash
# uvのインストール (pipの場合)
pip install uv

# 仮想環境の作成と有効化
uv venv
source .venv/bin/activate

# 依存関係のインストール
uv sync
```

### 3. Node.jsツールのインストール

コミットメッセージのチェックにはNode.jsベースのツールを使用します。`pnpm` を使って依存関係をインストールしてください。

```bash
# pnpmのインストール (npmの場合)
npm install -g pnpm

# 依存関係のインストール
pnpm install
```

### 4. Gitフックのセットアップ

本プロジェクトでは、コード品質の自動チェックとコミットメッセージの自動生成のためにGitフックを利用します。以下のコマンドを一度だけ実行して、フックを有効化してください。

```bash
# pre-commit (コード整形) と commit-msg (メッセージ規約) フックの有効化
pre-commit install --hook-type pre-commit --hook-type commit-msg

# opencommitフック (コミットメッセージ自動生成) の有効化
pnpm oco hook set
```

### 5. OpenCommitの設定

`opencommit`を動作させるために、プロジェクト固有の設定と、マシンごとのグローバル設定が必要です。

#### A. プロジェクト固有の設定 (.envファイル)

プロジェクトのルートディレクトリに`.env`という名前のファイルを作成し、以下の内容を記述してください。このファイルはプロジェクト内での`opencommit`の挙動を制御します。

```
#----------------------------------------#
# OpenCommit (for development)
#----------------------------------------#
OCO_PROMPT_MODULE=@commitlint
OCO_ONE_LINE_COMMIT=true
```

#### B. グローバル設定 (初回のみ)

お使いのマシンで初めて`opencommit`を使う際に、以下のコマンドを実行してグローバル設定を行ってください。これにより、ホームディレクトリ配下の`~/.opencommit`に設定が保存されます。

**注意**: `<発行したキー>`の部分は、ご自身で発行したGeminiのAPIキーに置き換えてください。

```bash
oco config set OCO_AI_PROVIDER=gemini
oco config set OCO_MODEL=gemini-2.0-flash
oco config set OCO_API_KEY=<発行したキー>
oco config set OCO_GITPUSH=false
```

## 詳細な開発ガイドライン

コーディング規約やコミットのワークフローなど、より詳細な開発ルールについては、以下のドキュメントを参照してください。

-   [**開発ガイドライン (docs/development.md)**](./docs/development.md)
