#!/bin/bash

# 功能选择菜单
echo "请选择功能："
echo "1) 安装 Ocean Node(注意：请根据提示输入 0x 私钥和地址，设置端口为 8999 9990 9991 9992 9993，并填入 VPS 的 IP 地址)"
echo "2) 切换 RPC 配置"
echo "3) 查看实时日志"
read -p "输入选项 (1 2 或 3): " option

# 安装 Ocean Node
if [ "$option" == "1" ]; then
    echo "安装 Ocean Node"
    git clone https://github.com/oceanprotocol/ocean-node.git
    cd ocean-node
    # 执行安装脚本
    ./scripts/ocean-node-quickstart.sh
    docker-compose up -d
    
    echo "安装完成。。"
    exit 0
fi

# 切换 RPC 配置
if [ "$option" == "2" ]; then
    echo "切换 RPC 配置"

    # 定位到 ocean-node 文件夹
    cd ocean-node

    # 停止 Docker 容器
    echo "停止 Docker 容器..."
    docker-compose down

    # 删除已有的 RPCS 配置
    echo "删除旧的 RPCS 配置..."
    sed -i '/RPCS:/d' docker-compose.yml

    # 插入新的 RPCS 配置，确保使用单引号包裹 YAML 字段，双引号包裹 JSON 内容
    echo "插入新的 RPCS 配置..."
    sed -i '/environment:/a\      RPCS: '\''{"1":{"rpc":"https://mainnet.infura.io/v3/b6bf7d3508c941499b10025c0776eaf8","fallbackRPCs":["https://ethereum-rpc.publicnode.com","https://rpc.ankr.com/eth","https://1rpc.io/eth","https://eth.api.onfinality.io/public"],"chainId":1,"network":"mainnet","chunkSize":100},"10":{"rpc":"https://mainnet.optimism.io","fallbackRPCs":["https://optimism-mainnet.public.blastapi.io","https://rpc.ankr.com/optimism","https://optimism-rpc.publicnode.com"],"chainId":10,"network":"optimism","chunkSize":100},"137":{"rpc":"https://polygon-mainnet.infura.io/v3/b6bf7d3508c941499b10025c0776eaf8","fallbackRPCs":["https://polygon-rpc.com/","https://polygon-mainnet.public.blastapi.io","https://1rpc.io/matic","https://rpc.ankr.com/polygon"],"chainId":137,"network":"polygon","chunkSize":100},"23294":{"rpc":"https://sapphire.oasis.io","fallbackRPCs":["https://1rpc.io/oasis/sapphire"],"chainId":23294,"network":"sapphire","chunkSize":100},"23295":{"rpc":"https://testnet.sapphire.oasis.io","chainId":23295,"network":"sapphire-testnet","chunkSize":100},"11155111":{"rpc":"https://sepolia.infura.io/v3/b6bf7d3508c941499b10025c0776eaf8","fallbackRPCs":["https://eth-sepolia.public.blastapi.io","https://1rpc.io/sepolia","https://eth-sepolia.g.alchemy.com/v2/demo"],"chainId":11155111,"network":"sepolia","chunkSize":100},"11155420":{"rpc":"https://sepolia.optimism.io","fallbackRPCs":["https://endpoints.omniatech.io/v1/op/sepolia/public","https://optimism-sepolia.blockpi.network/v1/rpc/public"],"chainId":11155420,"network":"optimism-sepolia","chunkSize":100}}'\''' docker-compose.yml

    echo "RPC 配置修改完成。"

    # 启动 Docker 容器，确保配置更新
    echo "重新启动 Docker 容器..."
    docker-compose up -d

    echo "RPC 配置已成功切换并重新启动 Ocean Node 容器。"
    exit 0
fi

if [ "$option" == "3" ]; then
    cd ocean-node
    docker logs -f ocean-node
    exit 0
fi
echo "无效的选项，请重新运行脚本并选择正确的功能。"
