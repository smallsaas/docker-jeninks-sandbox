## 前置条件

假设机器上已经安装了Docker和Docker-Compose。

如果还未安装，请参考Docker官方文档进行安装。

## 安装步骤

克隆或复制 [jenkins](https://links.jianshu.com/go?to=https%3A%2F%2Fgithub.com%2Fcookcodeblog%2Fdocker-compose-examples%2Ftree%2Fmaster%2Fjenkins) 目录到机器上。

或者创建jenkins文件夹，文件夹下存放以下三个文件：
 **docker-compose.yml：**

```bash
version: '3'
services:
  jenkins:
    image: 'jenkins/jenkins:lts'
    container_name: jenkins
    restart: always
    ports:
      - '8080:8080'
      - '50000:50000'
    volumes:
      - './jenkins_home:/jenkins_home'
```

**docker_run_install_jenkins.sh：**

```bash
#!/bin/bash

docker run --name jenkins \
       -d \
       -p 8080:8080 \
       -p 50000:50000 \
       -v /var/jenkins_home:/var/jenkins_home \
       --restart always \
       jenkins/jenkins:lts
```

**pre_install_jenkins.sh：**

```bash
#!/bin/bash

mkdir -p /var/jenkins_home
chown -R 1000:1000 /var/jenkins_home
```

在jenkins目录运行以下命令：

```bash
# 给脚本授权
chmod u+x *.sh
# 创建Jenkins数据目录（用作持久卷）
./pre_install_jenkins.sh
# 启动Jenkins容器
docker-compose up -d
```

运行 `docker logs -f jenkins` 查看Jenkins日志。

找到Jenkins Initial Password的日志，比如：

```swift
Jenkins initial setup is required. An admin user has been created and a password generated.
Please use the following password to proceed to installation:

<Initial Admin Password>

This may also be found at: /var/jenkins_home/secrets/initialAdminPassword
```

访问Jenkins网址[http://[server_ip\]:8080](https://links.jianshu.com/go?to=http%3A%2F%2F%5Bserver_ip%5D%3A8080%2F)，输入上面生成的初始密码，按照提示安装到成功完成。
## 插件安装

- 登录Jenkins
- 点击面板左侧 -> Manage Jenkins -> Manage Plugins -> Available -> 点击上方搜索框 -> 输入想要安装的插件名称
- 勾选对应插件checkbox
- 点击下方Download now and install after restart
- 完成插件安装
