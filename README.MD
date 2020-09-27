## 前置条件

假设机器上已经安装了Docker和Docker-Compose。

如果还未安装，请参考Docker官方文档进行安装。

## 安装步骤

可根据[Jenkins官方文档](https://www.jenkins.io/doc/book/installing/)下载部署至服务器上

>**本文档按照docker-compose方式进行Jenkins的部署**

创建Jenkins文件夹，文件夹下存放以下三个文件：
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

访问Jenkins网址http://server_ip:8080，输入上面生成的初始密码，按照提示安装到成功完成。
## 插件安装

- 登录Jenkins
- 点击面板左侧 -> Manage Jenkins -> Manage Plugins -> Available -> 点击上方搜索框 -> 输入想要安装的插件名称
- 勾选对应插件checkbox
- 点击下方Download now and install after restart
- 完成插件安装

## 环境变量

- 登录Jenkins
- 点击面板左侧 -> Manage Jenkins--> Configure System--> Global properties--> **勾选Environment variables**
- 根据所需设置环境变量 *（对应Name和Value）*

- 点击底部**Save按钮保存配置**
- 完成环境变量配置

### Maven环境变量

>根据上述环境变量设置步骤到达Environment variables后，设置如下所示的Name和Value，其中**环境变量地址按实际情况变更**

Maven环境变量配置必须设置JAVA_HOME、M2_HOME和PATH+EXTRA三个字段值，具体如下所示：

- JDK环境变量
  - Name：JAVA_HOME
  - Value：/usr/local/openjdk-8

- Maven环境变量
  - Name：M2_HOME
  - Value：/jenkins_home/maven3
  - Name：PATH+EXTRA
  - $M2_HOME/bin