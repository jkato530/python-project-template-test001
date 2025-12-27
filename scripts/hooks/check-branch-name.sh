#!/bin/bash
# ブランチ名のバリデーションスクリプト
# Conventional Branch 1.0.0に基づいた命名規則をチェック

# 現在のブランチ名を取得
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

# main, develop ブランチは除外
if [[ "$BRANCH_NAME" == "main" ]] || [[ "$BRANCH_NAME" == "develop" ]]; then
    exit 0
fi

# 許可されるtype
VALID_TYPES="feature|bugfix|hotfix|release|docs|chore"

# Conventional Branch形式: <type>/<description>
# description: 小文字英数字、ハイフン、ドット（releaseのみ）
# 記号を連続させない、先頭・末尾に記号を使わない

if [[ ! "$BRANCH_NAME" =~ ^($VALID_TYPES)/ ]]; then
    echo "[ERROR] ブランチ名のエラー: '$BRANCH_NAME'"
    echo ""
    echo "ブランチ名は以下のフォーマットに従う必要があります:"
    echo "  <type>/<description>"
    echo ""
    echo "許可されるtype:"
    echo "  - feature  : 新機能の開発"
    echo "  - bugfix   : バグ修正"
    echo "  - hotfix   : 本番環境の緊急修正"
    echo "  - release  : リリース準備"
    echo "  - docs     : ドキュメントのみの変更"
    echo "  - chore    : 雑務（ビルド設定等）"
    echo ""
    echo "例: feature/add-login-page"
    exit 1
fi

# typeを抽出
TYPE=$(echo "$BRANCH_NAME" | cut -d'/' -f1)
DESCRIPTION=$(echo "$BRANCH_NAME" | cut -d'/' -f2-)

# descriptionの検証
# releaseブランチの場合はvX.Y.Z形式を強制
if [[ "$TYPE" == "release" ]]; then
    # release/vX.Y.Z形式をチェック (vで始まることを強制)
    if [[ ! "$DESCRIPTION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "[ERROR] ブランチ名のエラー: '$BRANCH_NAME'"
        echo ""
        echo "releaseブランチは 'release/vX.Y.Z' の形式で作成する必要があります。"
        echo "例: release/v1.0.0, release/v0.1.0"
        exit 1
    fi
elif [[ "$TYPE" == "hotfix" ]]; then
    # hotfix/description形式を許可（説明的な名前）
    # バージョンは最新タグから自動でインクリメントされるため、ブランチ名には不要
    if [[ ! "$DESCRIPTION" =~ ^[a-z0-9]+[a-z0-9-]*[a-z0-9]+$ ]] && [[ ! "$DESCRIPTION" =~ ^[a-z0-9]+$ ]]; then
        echo "[ERROR] ブランチ名のエラー: '$BRANCH_NAME'"
        echo ""
        echo "descriptionは小文字英数字とハイフンのみ使用できます。"
        echo "記号を連続させたり、先頭・末尾に使用することはできません。"
        echo "例: hotfix/security-patch, hotfix/critical-bug"
        exit 1
    fi
else
    # 通常のブランチはドット不可
    if [[ ! "$DESCRIPTION" =~ ^[a-z0-9]+[a-z0-9-]*[a-z0-9]+$ ]] && [[ ! "$DESCRIPTION" =~ ^[a-z0-9]+$ ]]; then
        echo "[ERROR] ブランチ名のエラー: '$BRANCH_NAME'"
        echo ""
        echo "descriptionは小文字英数字とハイフンのみ使用できます。"
        echo "記号を連続させたり、先頭・末尾に使用することはできません。"
        exit 1
    fi
fi

echo "[OK] ブランチ名チェック: OK ($BRANCH_NAME)"
exit 0
