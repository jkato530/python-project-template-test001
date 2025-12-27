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

### 1. PythonとNode.jsのバージョン

本プロジェクトではPython `3.13` およびNode.js `24.12.0`を使用します。
それぞれのバージョンは、ルートディレクトリにある `.python-version` と `.nvmrc` ファイルで定義されています。

-   **Python**: `uv` は `.python-version` を参照して適切なPythonインタプリタを使用します。
-   **Node.js**: `nvm` は `.nvmrc` を参照して適切なNode.jsバージョンをインストール・使用します。

### 2. Node.jsのインストール

Node.jsのバージョン管理には `nvm` を使用します。

1.  `nvm`がインストールされていない場合は、[公式リポジトリ](https://github.com/nvm-sh/nvm)を参考にインストールします。
    ```bash
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    source ~/.bashrc
    ```

2.  `.nvmrc` に記載されたバージョンのNode.jsをインストールします。
    ```bash
    nvm install
    ```

> [!NOTE]
> `.nvmrc`ファイルがあるため、バージョンを指定する必要はありません。

3.  プロジェクトで使うNode.jsのバージョンを有効にします。
    ```bash
    nvm use
    ```

4.  対象バージョンがインストールされていることを確認します。
    ```bash
    node --version
    # v24.12.0 と表示されます
    ```

### 3. Python依存関係のインストール

パッケージ管理には `uv` を使用します。以下のコマンドで、開発に必要なライブラリをインストールしてください。

```bash
# uvのインストール
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc

# 仮想環境の作成と有効化
uv venv
source .venv/bin/activate

# 依存関係のインストール
uv sync
```

### 4. Node.jsツールのインストール

コミットメッセージのチェックにはNode.jsベースのツールを使用します。`pnpm` を使って依存関係をインストールしてください。

```bash
# pnpmのインストール (npmの場合)
npm install -g pnpm

# 依存関係のインストール
pnpm install
```

### 5. Gitフックのセットアップ

本プロジェクトでは、コード品質の自動チェックとコミットメッセージの自動生成のためにGitフックを利用します。以下のコマンドを一度だけ実行して、フックを有効化してください。

```bash
# pre-commit (コード整形) と commit-msg (メッセージ規約) フックの有効化
pre-commit install --hook-type pre-commit --hook-type commit-msg

# opencommitフック (コミットメッセージ自動生成) の有効化
pnpm oco hook set
```

### 6. OpenCommitの設定

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

初めて`opencommit`を使う際に、以下のコマンドを実行してグローバル設定を行ってください。これにより、ホームディレクトリ配下の`~/.opencommit`に設定が保存されます。

```bash
pnpm oco config set OCO_AI_PROVIDER=gemini
pnpm oco config set OCO_MODEL=gemini-2.0-flash
pnpm oco config set OCO_API_KEY=<発行したキー>
pnpm oco config set OCO_GITPUSH=false
```

>[!CAUTION]
>`<発行したキー>`の部分は、ご自身で発行したGeminiのAPIキーに置き換えてください。

**APIキーの発行手順**
- 任意のGoogle Cloudプロジェクトで、APIキーを作成してください（APIキーは、Generative Language APIが許可されている必要があります）。
- 取得したAPIキーを、`OCO_API_KEY`に貼り付けてください。

### 7. GitHubリポジトリの初期設定

リポジトリをGitHubで管理する場合、以下の設定を行ってください。

#### A. ブランチ保護ルールの設定

`main`ブランチの品質を保つため、ブランチ保護ルールを設定します。

1. GitHubリポジトリページで、**Settings** > **Branches** に移動
2. **Branch protection rules** セクションで **Add rule** をクリック
3. **Branch name pattern** に `main` を入力
4. 以下のオプションを有効化：
   - ✅ **Require a pull request before merging**
   - ✅ **Require status checks to pass before merging**
   - ✅ **Require branches to be up to date before merging**
5. **Save changes** をクリック

詳細は [開発ガイドライン - ブランチ保護ルール](./docs/development.md#243-ブランチ保護ルールの設定) を参照してください。

#### B. 初回リリースの準備

プロジェクトの初回リリースを行う場合、以下の方法でバージョンタグを設定します：

**releaseブランチを使用**

1. `release/v1.0.0`ブランチを作成
2. Pull Requestを作成してマージ
3. ワークフローが自動的に`v1.0.0`タグを作成し、GitHub Releaseを生成

## 詳細な開発ガイドライン

コーディング規約やコミットのワークフローなど、より詳細な開発ルールについては、以下のドキュメントを参照してください。

-   [**開発ガイドライン (docs/development.md)**](./docs/development.md)


## ドキュメント構成

`docs` ディレクトリには、本プロジェクトに関する全てのドキュメントが格納されています。ドキュメントは対象読者に応じて、以下の2つの場所に分けて管理されます。

## `docs/` (ルート)

**対象読者**: アプリケーションの利用者

このディレクトリの直下には、アプリケーションの基本的な使い方、APIリファレンス、チュートリアルなど、**利用者向けのドキュメント**を配置します。

## `docs/developer/`

**対象読者**: 開発者

このサブディレクトリには、開発環境のセットアップ、ブランチ戦略、コーディング規約、アーキテクチャの解説など、**プロジェクトの開発に参加する人向けのドキュメント**を配置します。
