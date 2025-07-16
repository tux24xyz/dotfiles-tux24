#!/bin/bash

# dotfiles 快速更新腳本
# 使用方法: ./update-dots.sh "commit 訊息"

set -e  # 遇到錯誤立即停止

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置變數（請根據你的設定修改）
GITHUB_REPO="tux24xyz/dotfiles-tux24"

# 函數：輸出彩色訊息
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 檢查參數
if [ $# -eq 0 ]; then
    COMMIT_MSG="Update dotfiles: $(date '+%Y-%m-%d %H:%M:%S')"
else
    COMMIT_MSG="$1"
fi

log_info "開始 dotfiles 更新流程..."
log_info "Commit 訊息: $COMMIT_MSG"

# 1. 檢查是否有未提交的變更
log_info "檢查 Git 狀態..."
if ! git diff --quiet || ! git diff --cached --quiet; then
    log_info "發現未提交的變更，準備提交..."
    
    # 顯示變更內容
    echo "=== 變更內容 ==="
    git status --short
    echo "=================="
    
    # 添加所有變更
    git add .
    
    # 提交變更
    git commit -m "$COMMIT_MSG"
    log_success "本地提交完成"
else
    log_warning "沒有發現新的變更"
fi

# 2. 推送到 GitHub
log_info "推送到 GitHub..."
if git push origin main; then
    log_success "推送到 GitHub 成功"
else
    log_error "推送到 GitHub 失敗"
    exit 1
fi

