#!/bin/sh
# vim:sw=4:ts=4:et

# 设置Shell，如果任何命令以非零状态退出，则立即退出
set -e

# 定义用于记录日志的函数，仅在未设置NGINX_ENTRYPOINT_QUIET_LOGS时打印日志
entrypoint_log() {
    if [ -z "${NGINX_ENTRYPOINT_QUIET_LOGS:-}" ]; then
        echo "$@"
    fi
}

if /usr/bin/find "/docker-entrypoint.d/" -mindepth 1 -maxdepth 1 -type f -print -quit 2>/dev/null | read v; then
    entrypoint_log "$0: /docker-entrypoint.d/ 不为空，将尝试进行配置"

    entrypoint_log "$0: 在/docker-entrypoint.d/中查找Shell脚本"
    
    # 查找/docker-entrypoint.d/中的所有文件并处理它们
    find "/docker-entrypoint.d/" -follow -type f -print | sort -V | while read -r f; do
        case "$f" in
            *.envsh)
                # 如果文件具有执行权限，则源文件
                if [ -x "$f" ]; then
                    entrypoint_log "$0: 正在源化 $f"
                    . "$f"
                else
                    # 如果文件不可执行，则发出警告
                    entrypoint_log "$0: 忽略 $f，不可执行"
                fi
                ;;
            *.sh)
                # 如果文件具有执行权限，则启动它
                if [ -x "$f" ]; then
                    entrypoint_log "$0: 启动 $f"
                    "$f"
                else
                    # 如果文件不可执行，则发出警告
                    entrypoint_log "$0: 忽略 $f，不可执行"
                fi
                ;;
            *) 
                # 忽略不匹配模式的文件
                entrypoint_log "$0: 忽略 $f"
                ;;
        esac
    done

    entrypoint_log "$0: 配置完成；启动"
else
    # 在/docker-entrypoint.d/中未找到文件，跳过配置
    entrypoint_log "$0: 在/docker-entrypoint.d/中未找到文件，跳过配置"
fi

# 执行传递给脚本的参数作为命令
# exec "$@"
