# Changelog

All notable changes to this documentation will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-12-16
### Added
- 開発者向けドキュメントの初版を作成。
- `docs/developer` ディレクトリを作成し、ドキュメントの構成を定義。
- `development.md` にブランチの命名規則を記載。
- `development.md` の作業ブランチ一覧に `docs/` ブランチを追加。
- アプリケーション本体と開発ドキュメントの CHANGELOG 運用方針を分離し、`development.md` に記載。
### Changed
- `docs/development.md`:
    - ディレクトリ構成（1. ディレクトリ構成）を更新。
    - .dev-tools配下のファイルをルートディレクトリに再配置（開発体験向上のため構造を簡素化）。
    - 既存の「1. 開発ワークフローとブランチ戦略」以降を章番号2以降に繰り下げ。
    - ブランチ戦略のセクションを再構成。
        - 開発フローの全体像（Mermaid図）を追加。
        - ブランチの命名規則を独立したセクションに分離。

[Unreleased]: https://github.com/your-org/your-repo/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/your-org/your-repo/releases/tag/v1.0.0
