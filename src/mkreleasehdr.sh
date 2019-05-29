#!/bin/sh

## 获取GIT 本地提交的一个 commit hash
GIT_SHA1=`(git show-ref --head --hash=8 2> /dev/null || echo 00000000) | head -n1`

## 获取差异 并输出差异行数 [https://git-scm.com/docs/git-diff]
GIT_DIRTY=`git diff --no-ext-diff 2> /dev/null | wc -l`

## 机器用户名 与时间戳 作buildID
BUILD_ID=`uname -n`"-"`date +%s`

## 检测文件是否存在 如果不存在 则 生成该文件
test -f release.h || touch release.h

## 检测该文件中 上述值 是否和检测值一致 都一致 则 结束
(cat release.h | grep SHA1 | grep $GIT_SHA1) && \
(cat release.h | grep DIRTY | grep $GIT_DIRTY) && exit 0 # Already up-to-date

## 如不一致 则重新写入 版本信息
echo "#define REDIS_GIT_SHA1 \"$GIT_SHA1\"" > release.h
echo "#define REDIS_GIT_DIRTY \"$GIT_DIRTY\"" >> release.h
echo "#define REDIS_BUILD_ID \"$BUILD_ID\"" >> release.h

## 访问时间戳 重置
touch release.c # Force recompile of release.c
