{ nixpkgs-unstable, nixpkgs-default, config, ... }:
{
    sops.secrets = {
      "singbox/sub/url_unburn" = { };
      "singbox/hy2/server" = { };
      "singbox/hy2/server_port" = { };
      "singbox/hy2/password" = { };
      "singbox/hy2/server_name" = { };
      "singbox/vless/server" = { };
      "singbox/vless/uuid" = { };
      "singbox/vless/server_name" = { };
      "singbox/vless/path" = { };
    };

    sops.templates."suburl_unburn".content =
    ''${config.sops.placeholder."singbox/sub/url_unburn"}'';
    
    sops.templates."self-hosts".content =
        ''
            {
                "tag": "my_hy2",
                "type": "hysteria2",
                "server": "${config.sops.placeholder."singbox/hy2/server"}",
                "server_port": ${config.sops.placeholder."singbox/hy2/server_port"},
                "up_mbps": 20,
                "down_mbps": 50,
                "password": "${config.sops.placeholder."singbox/hy2/password"}",
                "tls": {
                    "enabled": true,
                    "server_name": "${config.sops.placeholder."singbox/hy2/server_name"}",
                    "insecure": true
                }
            },
            {
                "tag": "my_vless_reality",
                "type": "vless",
                "server": "${config.sops.placeholder."singbox/vless/server"}",
                "server_port": 443,
                "uuid": "${config.sops.placeholder."singbox/vless/uuid"}",
                "tls": {
                    "enabled": true,
                    "server_name": "${config.sops.placeholder."singbox/vless/server_name"}",
                    "utls": {
                        "enabled": true,
                        "fingerprint": "chrome"
                    }
                },
                "transport": {
                    "type": "ws",
                    "path": "${config.sops.placeholder."singbox/vless/path"}"
            }
        '';
    
    # Install sing-box package
    environment.systemPackages = [ nixpkgs-unstable.sing-box ];

    # 订阅链接更新服务，把标准订阅链接和非标准放在一起，通过注释和取消注释来选择使用哪一个，避免同时更新。
    # 因为有的订阅是阅后即焚不支持重复刷新，而有的链接又必须定时更新
    # Systemd service to download sing-box configuration from subscription URL
    # 独立的配置下载服务，与 sing-box 主服务解耦
    systemd.services.singbox-unburn-sub-update = {
      description = "Update Sing-box Subscription from Subscription URL";
      after = ["network-online.target" "time-synced.target"];
      requires = ["network-online.target"];
      startLimitIntervalSec = 0;
      # 使用 systemd 内置的重试机制，比自己写 shell 脚本更优雅
      serviceConfig = {
        Type = "oneshot";
        User = "root";

        # 重试配置：失败后自动重试，使用指数退避
        Restart = "on-failure";
        RestartSec = "30"; # 初始重试间隔 30 秒
      };

      script = ''
        set -euo pipefail

        # 标准订阅链接
        SUB_URL_UNBURN="$(cat ${config.sops.templates."suburl_unburn".path})"


        # Create config directory if it doesn't exist
        mkdir -p /etc/sing-box

        # 临时文件，下载成功后再替换正式配置
        TEMP_SUBURLS="/etc/sing-box/suburls_unburn.tmp"
        UNBURN_SUB="/etc/sing-box/unburn_sub.txt"

        rm -f "$TEMP_SUBURLS"

        echo "Downloading sing-box configuration from subscription URL..."

        # Download configuration with retry and timeout
        # -f: fail silently on HTTP errors
        # -S: show error even with -s
        # -L: follow redirects
        # --retry 3: retry 3 times on transient errors
        # --retry-delay 5: wait 5 seconds between retries
        # --retry-max-time 60: max 60 seconds for all retries
        # --connect-timeout 30: connection timeout 30 seconds
        # --max-time 120: max total time 120 seconds
        ${nixpkgs-default.curl}/bin/curl -fsSL \
            --retry 3 \
            --retry-delay 5 \
            --retry-max-time 60 \
            --connect-timeout 30 \
            --max-time 120 \
            "$SUB_URL_UNBURN" \
            -o "$TEMP_SUBURLS"
        ${nixpkgs-default.coreutils}/bin/base64 -d "$TEMP_SUBURLS" > "$UNBURN_SUB"
        rm -f "$TEMP_SUBURLS"

        echo "Sing-box subscription updated successfully"
      '';
    };
    systemd.services.singbox-burn-sub-update = {
      description = "Update Sing-box Subscription from Subscription URL";
      requires = ["network-online.target"];
      startLimitIntervalSec = 0;
      # 使用 systemd 内置的重试机制，比自己写 shell 脚本更优雅
      serviceConfig = {
        Type = "oneshot";
        User = "root";

        # 重试配置：失败后自动重试，使用指数退避
        Restart = "on-failure";
        RestartSec = "30"; # 初始重试间隔 30 秒
      };

      script = ''
        set -euo pipefail

        # Read subscription URL from secret
        # 阅后即焚的链接
        SUB_URL_BURN=$(cat "/etc/sing-box/sub.txt")
        # Create config directory if it doesn't exist
        mkdir -p /etc/sing-box

        # 临时文件，下载成功后再替换正式配置
        TEMP_SUBURLS="/etc/sing-box/suburls_burn.tmp"
        BURN_SUB="/etc/sing-box/burn_sub.txt"

        rm -f "$TEMP_SUBURLS"

        echo "Downloading sing-box configuration from subscription URL..."

        # Download configuration with retry and timeout
        # -f: fail silently on HTTP errors
        # -S: show error even with -s
        # -L: follow redirects
        # --retry 3: retry 3 times on transient errors
        # --retry-delay 5: wait 5 seconds between retries
        # --retry-max-time 60: max 60 seconds for all retries
        # --connect-timeout 30: connection timeout 30 seconds
        # --max-time 120: max total time 120 seconds
        ${nixpkgs-default.curl}/bin/curl -fsSL \
            --retry 3 \
            --retry-delay 5 \
            --retry-max-time 60 \
            --connect-timeout 30 \
            --max-time 120 \
            "$SUB_URL_BURN" \
            -o "$TEMP_SUBURLS"
        ${nixpkgs-default.coreutils}/bin/base64 -d "$TEMP_SUBURLS" > "$BURN_SUB"
        rm -f "$TEMP_SUBURLS"
        
        echo "Sing-box subscription updated successfully"
      '';
    };
    ######################################################################
    # 非标订阅链接更新服务
    # 暂时非标支持


    systemd.services.singbox-config-update = {
      description = "Update Sing-box Configuration from Subscription URL";
      # 使用 systemd 内置的重试机制，比自己写 shell 脚本更优雅
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    script = ''
        set -euo pipefail
        # 共用的临时文件和配置文件路径
        TEMP_CONFIG="/etc/sing-box/config.json.tmp"
        TEMP_CONFIG_JQ="/etc/sing-box/config_jq.json.tmp"
        CONFIG_FILE="/etc/sing-box/config.json"
        TEMP_FILE="/etc/sing-box/sub.tmp"
        TEMP_TAGS="/etc/sing-box/tags.tmp"
        # 标准订阅
        BURN_SUB="/etc/sing-box/burn_sub.txt"
        UNBURN_SUB="/etc/sing-box/unburn_sub.txt"
        SUBURLS="/etc/sing-box/suburls.txt"

        rm -f "$TEMP_CONFIG"
        rm -f "$TEMP_CONFIG_JQ"
        rm -f "$TEMP_FILE"
        rm -f "$TEMP_TAGS"

        cat "$BURN_SUB" > "$SUBURLS"
        echo "" >> "$SUBURLS"
        cat "$UNBURN_SUB" >> "$SUBURLS"

        parse_shadowsocks_url() {
            local url="$1"

            # 提取协议类型 (ss:// 或 ssr://)
            local protocol=$(echo "$url" | cut -d':' -f1)
            local url_body=$(echo "$url" | cut -d':' -f2- | sed 's/^\/\///')

            # 提取订阅类型。现阶段先按JMS和非JMS区分，后续可以扩展更多类型
            # 判断protocol为ss的url_body中是否包含"JMS-"，包含则为JMS订阅，否则为非JMS订阅
            # 判断protocol为vmess的url_body中是否包含"@"，包含则为非JMS订阅，否则为JMS订阅
            # 其他任何protocol都为非JMS订阅
            local supplier=""
            case "$protocol" in
                "ss")
                    if echo "$url_body" | grep -q "JMS-"; then
                        supplier="JMS"
                    else
                        supplier="non-JMS"
                    fi
                    ;;
                "vmess")
                    if echo "$url_body" | grep -q "@"; then
                        supplier="non-JMS"
                    else
                        supplier="JMS"
                    fi
                    ;;
                *)
                    supplier="non-JMS"
                    ;;
            esac

            # 设置type字段
            local type=""
            case "$protocol" in
                "ss")
                    type="shadowsocks"
                    ;;
                "vmess")
                    type="vmess"
                    ;;
                "anytls")
                    type="anytls"
                    ;;
                *)
                    type="unknown"
                    ;;
            esac
            if [ "$supplier" = "JMS" ]; then
                if [ "$protocol" = "ss" ]; then
                    local base64_part=$(echo "$url_body" | cut -d'#' -f1)
                    local tag=$(echo "$url_body" | cut -d'#' -f2-)
                    local decoded=$(printf "%s" "$base64_part" | ${nixpkgs-default.coreutils}/bin/base64 -d 2>/dev/null || echo "decode_failed")
                    if [ "$decoded" != "decode_failed" ]; then
                        local method=$(echo "$decoded" | cut -d':' -f1)
                        local password=$(echo "$decoded" | cut -d':' -f2- | cut -d'@' -f1)
                        local server=$(echo "$decoded" | cut -d'@' -f2 | cut -d':' -f1)
                        local port=$(echo "$decoded" | cut -d'@' -f2 | cut -d':' -f2)
                    else
                        echo "错误: 解码JMS订阅的base64部分失败: $url" >&2
                        return 1
                    fi

                    printf '{"tag":"%s","type":"%s","server":"%s","server_port":%s,"method":"%s","password":"%s"},' \
                            "$tag" "$type" "$server" "$port" "$method" "$password" >> "$TEMP_FILE"
                    printf '"%s",\n' "$tag" >> "$TEMP_TAGS"
                elif [ "$protocol" = "vmess" ]; then
                    local decoded=$(printf "%s" "$url_body" | ${nixpkgs-default.coreutils}/bin/base64 -d 2>/dev/null || echo "decode_failed")
                    if [ "$decoded" != "decode_failed" ]; then
                        local server=$(echo "$decoded" | ${nixpkgs-default.jq}/bin/jq -r '.add')
                        local port=$(echo "$decoded" | ${nixpkgs-default.jq}/bin/jq -r '.port')
                        local tag=$(echo "$decoded" | ${nixpkgs-default.jq}/bin/jq -r '.ps')
                        local uuid=$(echo "$decoded" | ${nixpkgs-default.jq}/bin/jq -r '.id')
                        local alter_id=$(echo "$decoded" | ${nixpkgs-default.jq}/bin/jq -r '.aid')

                        printf '{"tag":"%s","type":"%s","server":"%s","server_port":%s,"uuid":"%s","alter_id":%s},' \
                            "$tag" "$type" "$server" "$port" "$uuid" "$alter_id" >> "$TEMP_FILE"
                        printf '"%s",\n' "$tag" >> "$TEMP_TAGS"
                    else
                        echo "错误: 解码JMS订阅的base64部分失败: $url" >&2
                        return 1
                    fi
                else
                    echo "错误: JMS订阅不支持协议: $protocol" >&2
                fi
            else
                # 对于SS协议，继续解析
                if [ "$protocol" = "ss" ]; then
                    # 分割base64部分和服务器部分
                    local base64_part=$(echo "$url_body" | cut -d'@' -f1)
                    local server_part=$(echo "$url_body" | cut -d'@' -f2-)

                    # Base64解码（添加padding）
                    base64_part=$(printf "%s" "$base64_part" | sed 's/./&/g' | ${nixpkgs-default.gawk}/bin/awk '{
                        len=length($0);
                        pad=(4-len%4)%4;
                        printf "%s", $0;
                        for(i=0;i<pad;i++) printf "="
                    }')

                    local decoded=$(printf "%s" "$base64_part" | ${nixpkgs-default.coreutils}/bin/base64 -d 2>/dev/null || echo "decode_failed")

                    if [ "$decoded" != "decode_failed" ]; then
                        # 提取方法和密码
                        local method=$(echo "$decoded" | cut -d':' -f1)
                        local password=$(echo "$decoded" | cut -d':' -f2-)

                        # 提取服务器和端口
                        local server=$(echo "$server_part" | cut -d'/' -f1 | cut -d':' -f1)
                        local port=$(echo "$server_part" | cut -d'/' -f1 | cut -d':' -f2)

                        # 提取标签（URL解码）
                        local tag_encoded=$(echo "$server_part" | grep -o '#[^#]*$' | sed 's/^#//')
                        local tag=""
                        if [ -n "$tag_encoded" ]; then
                            # URL解码
                            tag=$(echo "$tag_encoded" | sed 's/%/\\x/g')
                            tag=$(printf "%b" "$tag" 2>/dev/null || echo "$tag_encoded")
                            # 只保留竖线之后的部分
                            tag=$(echo "$tag" |  sed 's/^[^丨]*丨//' | tr -d '\n\r')
                        fi

                        # 提取插件参数
                        local plugin_opts=$(echo "$server_part" | grep -o 'plugin=.*' | cut -d'=' -f2- | cut -d'#' -f1 | sed 's/%3B/;/g' | sed 's/%3D/=/g')
                        local plugin=$(echo "$plugin_opts" | cut -d';' -f1)

                        # 构建plugin_opts（移除插件名和tfo参数）
                        local plugin_opts_clean=$(echo "$plugin_opts" | sed "s/$plugin;//" | sed 's/;tfo=1//' | sed 's/tfo=1;//' | sed 's/tfo=1//')

                        # 输出JSON到临时文件
                        printf '{"tag":"%s","type":"%s","server":"%s","server_port":%s,"method":"%s","password":"%s","plugin":"%s","plugin_opts":"%s"},' \
                            "$tag" "$type" "$server" "$port" "$method" "$password" "$plugin" "$plugin_opts_clean" >> "$TEMP_FILE"

                        # 保存tag到临时文件，确保格式正确
                        printf '"%s",\n' "$tag" >> "$TEMP_TAGS"
                    else
                        echo "错误: 解码base64部分失败: $url" >&2
                    fi
                elif [ "$protocol" = "anytls" ]; then
                    local tag=$(echo "$url_body" | cut -d'#' -f2-)
                    local password=$(echo "$url_body" | cut -d'@' -f1)
                    local server_port=$(echo "$url_body" | cut -d'@' -f2- | cut -d'?' -f1)
                    local server=$(echo "$server_port" | cut -d':' -f1)
                    local port=$(echo "$server_port" | cut -d':' -f2)
                    local query=$(echo "$url_body" | cut -d'?' -f2- | cut -d'#' -f1)
                    # insecure 需要转换成 true/false
                    local insecure=$(echo "$query" | grep -o 'insecure=[^&]*' | cut -d'=' -f2)
                    if [ "$insecure" = "1" ]; then
                        insecure=true
                    else
                        insecure=false
                    fi
                    local sni=$(echo "$query" | grep -o 'sni=[^&]*' | cut -d'=' -f2)

                    printf '{"tag":"%s","type":"%s","server":"%s","server_port":%s,"password":"%s", "idle_session_check_interval": "30s", "idle_session_timeout": "30s", "min_idle_session": 5, "tls": { "enabled": true, "insecure":%s,"server_name":"%s"}},' \
                        "$tag" "$type" "$server" "$port" "$password" "$insecure" "$sni" >> "$TEMP_FILE"
                    printf '"%s",\n' "$tag" >> "$TEMP_TAGS"
                else
                    echo "错误: 不支持的协议: $protocol" >&2
                fi
            fi
        }

        # 初始化输出文件
        echo '
            {
        ' > "$TEMP_CONFIG"

        # 日志控制
        echo '
            "log": {
                "disabled": false,
                "level": "error",
                "timestamp": true
            },
        ' >> "$TEMP_CONFIG"
        # 边缘的功能，不指定ui资源，没必要，之间使用https://yacd.haishan.me/访问就行，会直接拉9090端口的后端
        echo '
            "experimental": {
                "clash_api": {
                "external_controller": "127.0.0.1:9090",
                "default_mode": "Rule",
                "access_control_allow_origin": [
                    "*"
                ],
                "access_control_allow_private_network": false
                },
                "cache_file": {
                "enabled": true,
                "path": "cache.db",
                "store_fakeip": false,
                "rdrc_timeout": "1d"
                }
            },
        ' >> "$TEMP_CONFIG"

        # dns 控制 基于规则的
        # 
        #        {
        #            "rule_set": [
        #            "GeoSite-CN",
        #            "GeoIP-CN"
        #            ],
        #            "server": "Local-DNS"
        #        },
        echo '
            "dns": {
                "servers": [
                {
                    "tag": "Remote-DNS",
                    "type": "https",
                    "server": "1.1.1.1",
                    "detour": "使用节点"
                },
                {
                    "tag": "Google-DNS",
                    "type": "https",
                    "server": "8.8.8.8",
                    "detour": "使用节点"
                },
                {
                    "tag": "Local-DNS",
                    "type": "https",
                    "server": "223.5.5.5"
                },
                {
                    "tag": "fakeip",
                    "type": "fakeip",
                    "inet4_range": "198.18.0.0/15",
                    "inet6_range": "fc00::/18"
                }
                ],
                "rules": [
                {
                    "query_type": "HTTPS",
                    "action": "reject"
                },
                {
                    "action": "route",
                    "clash_mode": "Direct",
                    "server": "Local-DNS"
                },
                {
                    "action": "route",
                    "clash_mode": "Global",
                    "server": "fakeip"
                },
                {
                    "query_type": [
                    "A",
                    "AAAA"
                    ],
                    "server": "fakeip",
                    "rewrite_ttl": 1
                }
                ],
                "final": "Remote-DNS",
                "independent_cache": true
            },
        ' >> "$TEMP_CONFIG"
        # 入站
        echo '
            "inbounds": [
                {
                "tag": "tun-in",
                "type": "tun",
                "interface_name": "singbox-tun",
                "address": [
                    "172.18.0.1/30",
                    "fdfe:dcba:9876::1/126"
                ],
                "stack": "mixed",
                "route_address": [
                    "0.0.0.0/1",
                    "128.0.0.0/1",
                    "::/1",
                    "8000::/1"
                ],
                "auto_route": true,
                "auto_redirect": true,
                "strict_route": true,
                "platform": {
                    "http_proxy": {
                    "enabled": true,
                    "server": "127.0.0.1",
                    "server_port": 2080
                    }
                }
                },
                {
                "tag": "mixed-in",
                "type": "mixed",
                "listen": "127.0.0.1",
                "listen_port": 2080,
                "tcp_fast_open": false,
                "tcp_multi_path": false,
                "udp_fragment": false,
                "users": []
                }
            ],
        ' >> "$TEMP_CONFIG"

        # 出站选择器，可以通过selector.default制定默认出站，默认使用第一个出站，合理做法是先节点选择，节点选择默认是自动，然后自动的出站使用urltest
        echo '
            "outbounds": [
                {
                "type": "selector",
                "tag": "使用节点",
                "default": "自动选择",
                "interrupt_exist_connections": false,
                "outbounds": [
                    "自动选择",
                    "my_hy2",
                    "my_vless_reality",
        ' >> "$TEMP_CONFIG"

        # 为出站选择器增加所有的出站tag
        # 处理输入文件
        line_count=0
        total_lines=$(wc -l < "$SUBURLS")

        while IFS= read -r line; do
            [ -z "$line" ] && continue

            parse_shadowsocks_url "$line"
            line_count=$((line_count + 1))

        done < "$SUBURLS"

        # 处理tags文件 - 移除最后一行的逗号
        if [ -s "$TEMP_TAGS" ]; then
            sed -i '$ s/,$//' "$TEMP_TAGS"
            # 确保文件以换行符结尾
            echo "" >> "$TEMP_TAGS"
            cat "$TEMP_TAGS" >> "$TEMP_CONFIG"
        fi

        # 封底闭合出站选择器
        echo '
            ]
            },
        ' >> "$TEMP_CONFIG"

        # 自动测速选择器,自动选择的出站变更时"interrupt_exist_connections": false,使用不断开连接，这样能当只是延迟波动时先不断开连接，除非手动在选择换节点，避免网络波动时频繁断开
        echo '
            {
                "type": "urltest",
                "tag": "自动选择",
                "url": "http://cp.cloudflare.com/generate_204",
                "interval": "3m",
                "tolerance": 150,
                "interrupt_exist_connections": false,
                "outbounds": [
                    "my_hy2",
                    "my_vless_reality",
        ' >> "$TEMP_CONFIG"

        cat "$TEMP_TAGS" >> "$TEMP_CONFIG"
        # 封底闭合自动测速选择器
        echo '
            ]
            },
        ' >> "$TEMP_CONFIG"
        # 为出站自动测速选择器增加所有的出站tag
        # 添加解析的配置
        if [ -s "$TEMP_FILE" ]; then
            cat "$TEMP_FILE" >> "$TEMP_CONFIG"
        fi
        # 增加自建的节点
        cat ${config.sops.templates."self-hosts".path} >> "$TEMP_CONFIG"
        # 封闭
        echo "
        },
        " >> "$TEMP_CONFIG"

        # 补充其他选择器
        echo '
            {
            "type": "selector",
            "tag": "未被规则处理",
            "default": "直连",
            "interrupt_exist_connections": false,
            "outbounds": [
                "使用节点",
                "直连"
            ]
            },
            {
            "tag": "GLOBAL",
            "type": "selector",
            "default": "直连",
            "outbounds": [
                "使用节点",
                "直连"
            ]
            },
            {
            "tag": "直连",
            "type": "direct"
            }
        ],
        ' >> "$TEMP_CONFIG"

        # 路由,rule_set是规则集，rule_set中的type:remote指的是远程的文件，和代理无关。注意所有的rules都是顺序过滤，顺序非常重要，最后一个最好是Global,通过clashmode兜底
        echo '
            "route": {
                "auto_detect_interface": true,
                "default_domain_resolver": "Local-DNS",
                "rules": [
                {
                    "action": "sniff",
                    "sniffer": [
                    "http",
                    "tls",
                    "quic",
                    "dns"
                    ],
                    "timeout": "500ms"
                },
                {
                    "type": "logical",
                    "action": "hijack-dns",
                    "mode": "or",
                    "rules": [
                    {
                        "port": 53
                    },
                    {
                        "protocol": "dns"
                    }
                    ]
                },
                {
                    "action": "route",
                    "ip_is_private": true,
                    "outbound": "直连"
                },
                {
                    "action": "route",
                    "domain_suffix": [
                    "bbwwvip.org",
                    "bwbwbw.cc",
                    "haishan.me",
                    "netbird.io",
                    "netbird.cloud",
                    "xn--ngstr-lra8j.com",
                    "ångströ.com",
                    "ntp.org"
                    ],
                    "outbound": "直连"
                },
                {
                    "action": "route",
                    "ip_cidr": [
                    "100.120.0.0/16"
                    ],
                    "outbound": "直连"
                },
                {
                    "action": "route",
                    "rule_set": [
                    "GeoSite-CN",
                    "GeoIP-CN"
                    ],
                    "outbound": "直连"
                },
                {
                    "action": "route",
                    "network": "icmp",
                    "outbound": "直连"
                },
                {
                    "action": "route",
                    "network": "ntp",
                    "outbound": "直连"
                },
                {
                    "action": "reject",
                    "protocol": "quic"
                },
                {
                    "action": "resolve"
                },
                {
                    "action": "route",
                    "rule_set": [
                    "apple_ip",
                    "apple_domain",
                    "google_ip",
                    "google_domain",
                    "netflix_ip",
                    "netflix_domain",
                    "openai_domain",
                    "telegram_ip",
                    "telegram_domain",
                    "youtube_domain"
                    ],
                    "outbound": "使用节点"
                },
                {
                    "action": "route",
                    "clash_mode": "Direct",
                    "outbound": "直连"
                },
                {
                    "action": "route",
                    "clash_mode": "Global",
                    "outbound": "使用节点"
                }
                ],
                "final": "未被规则处理",
                "rule_set": [
                {
                    "tag": "GeoIP-CN",
                    "type": "remote",
                    "url": "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/refs/heads/sing/geo/geoip/cn.srs",
                    "format": "binary",
                    "update_interval": "1d",
                    "download_detour": "直连"
                },
                {
                    "tag": "GeoSite-CN",
                    "type": "remote",
                    "format": "binary",
                    "url": "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/refs/heads/sing/geo-lite/geosite/cn.srs",
                    "update_interval": "1d",
                    "download_detour": "直连"
                },
                {
                    "tag": "apple_ip",
                    "type": "remote",
                    "format": "binary",
                    "url": "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/refs/heads/sing/geo-lite/geoip/apple.srs",
                    "update_interval": "1d",
                    "download_detour": "直连"
                },
                {
                    "tag": "apple_domain",
                    "type": "remote",
                    "format": "binary",
                    "url": "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/refs/heads/sing/geo-lite/geosite/apple.srs",
                    "update_interval": "1d",
                    "download_detour": "直连"
                },
                {
                    "tag": "google_ip",
                    "type": "remote",
                    "format": "binary",
                    "url": "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/refs/heads/sing/geo-lite/geoip/google.srs",
                    "update_interval": "1d",
                    "download_detour": "直连"
                },
                {
                    "tag": "google_domain",
                    "type": "remote",
                    "format": "binary",
                    "url": "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/refs/heads/sing/geo-lite/geosite/google.srs",
                    "update_interval": "1d",
                    "download_detour": "直连"
                },
                {
                    "tag": "netflix_ip",
                    "type": "remote",
                    "format": "binary",
                    "url": "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/refs/heads/sing/geo-lite/geoip/netflix.srs",
                    "update_interval": "1d",
                    "download_detour": "直连"
                },
                {
                    "tag": "netflix_domain",
                    "type": "remote",
                    "format": "binary",
                    "url": "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/refs/heads/sing/geo-lite/geosite/netflix.srs",
                    "update_interval": "1d",
                    "download_detour": "直连"
                },
                {
                    "tag": "openai_domain",
                    "type": "remote",
                    "format": "binary",
                    "url": "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/refs/heads/sing/geo/geosite/openai.srs",
                    "update_interval": "1d",
                    "download_detour": "直连"
                },
                {
                    "tag": "telegram_ip",
                    "type": "remote",
                    "format": "binary",
                    "url": "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/refs/heads/sing/geo-lite/geoip/telegram.srs",
                    "update_interval": "1d",
                    "download_detour": "直连"
                },
                {
                    "tag": "telegram_domain",
                    "type": "remote",
                    "format": "binary",
                    "url": "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/refs/heads/sing/geo-lite/geosite/telegram.srs",
                    "update_interval": "1d",
                    "download_detour": "直连"
                },
                {
                    "tag": "youtube_domain",
                    "type": "remote",
                    "format": "binary",
                    "url": "https://ghfast.top/https://raw.githubusercontent.com/MetaCubeX/meta-rules-dat/refs/heads/sing/geo-lite/geosite/youtube.srs",
                    "update_interval": "1d",
                    "download_detour": "直连"
                },
                {
                    "tag": "Category-Ads",
                    "type": "remote",
                    "format": "binary",
                    "update_interval": "1d",
                    "url": "https://fastly.jsdelivr.net/gh/SagerNet/sing-geosite@rule-set/geosite-category-ads-all.srs",
                    "download_detour": "直连"
                }
                ]
            }
            }
        ' >> "$TEMP_CONFIG"

        ${nixpkgs-default.jq}/bin/jq . "$TEMP_CONFIG" > "$TEMP_CONFIG_JQ"

        # 原子性替换配置文件
        cp "$TEMP_CONFIG_JQ" "$CONFIG_FILE$(date "+%Y%m%d%H%M%S").bak"
        mv -f "$TEMP_CONFIG_JQ" "$CONFIG_FILE"
        chmod 600 "$CONFIG_FILE"

        
        rm -f "$TEMP_CONFIG"
        rm -f "$TEMP_CONFIG_JQ"
        rm -f "$TEMP_FILE"
        rm -f "$TEMP_TAGS"

        echo "Sing-box configuration updated successfully"
    '';
    };

    # Systemd timer to update sing-box configuration every 12 hours
    systemd.timers.singbox-unburn-sub-update = {
     description = "Timer for Sing-box Configuration Update";
     wantedBy = ["timers.target"];

    after = ["network-online.target" "time-synced.target" ];
    requires = ["network-online.target"];
    timerConfig = {
      # 系统启动后 2 分钟首次运行
      OnBootSec = "2min";
      # 之后每 12 小时运行一次
      OnUnitActiveSec = "12h";
      # 如果错过了运行时间，立即运行
      Persistent = true;
      # 添加随机延迟 0-30 分钟，避免所有机器同时请求
      RandomizedDelaySec = "30min";
    };
    };

    # Create systemd system service for sing-box (requires root for TUN interface)
    systemd.services.singbox = {
      description = "Sing-box Proxy Service";
      wantedBy = ["multi-user.target"];
      # 确保配置文件存在后再启动

      after = ["network-online.target" "time-synced.target" "netbird.service"];
      requires = ["network-online.target"];

      serviceConfig = {
        Type = "simple";
        # Fixed configuration path - all machines use /etc/sing-box/config.json
        ExecStart = "${nixpkgs-unstable.sing-box}/bin/sing-box run -c /etc/sing-box/config.json";
        Restart = "always";
        RestartSec = "5s";
        # Security: Required capabilities for TUN interface
        AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE";
        CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_BIND_SERVICE";

        # Run as root (required for TUN interface creation)
        User = "root";

        # Minimal security hardening
        # Note: Cannot use ProtectHome or ProtectSystem=strict as they would
        # prevent reading config from /etc or accessing /home
        NoNewPrivileges = false; # Must be false for capabilities
        PrivateTmp = true;
      };
    };
}
