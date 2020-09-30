# Jenkins使用说明

## 安装步骤

>假设机器上已经安装了Docker和Docker-Compose
>
>如果还未安装，请参考Docker官方文档进行安装

>可根据[Jenkins官方文档](https://www.jenkins.io/doc/book/installing/)下载部署至服务器上

>**本文档按照docker-compose方式进行Jenkins的部署**

创建Jenkins文件夹，文件夹下存放以下文件：
 **docker-compose.yml：**

```bash
version: '2'
services:
  jenkins:
    image: 'jenkins/jenkins:lts'
    container_name: jenkins
    restart: always
    ports:
      - '8000:8000'
    volumes:
      - './jenkins_home:/jenkins_home'
      - './settings.xml/settings.xml:/jenkins_home/maven3/conf/settings.xml'
```

在Jenkins目录运行以下命令：

```bash
# 启动Jenkins
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

## 配置JDK11

- 登录Jenkins
- 点击面板左侧 -> Manage Jenkins -> Global Tool Configuration -> Add JDK (near JDK installations)
- 输入**Name：JAVA11**
- 删除 the java.sun.com installer
- 点击底部 "**Add Installer**" 按钮并选择 "**Extract *.zip/*.tar.gz**"
- 输入以下配置信息
  - **Label**: master
  - **Download URL**: https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_linux-x64_bin.tar.gz
  - **Subdirectory of extracted archive**: jdk-11.0.1
- 后续构建项目时，可在 Project -> Configure ->  General -> JDK -> 选择 "JAVA11" 并**勾选Execute concurrent builds if necessary** 即可使用JDK11

## 自动构建（Git Push触发方式）

### 获取Persional Access Token

- 进入项目所在的GitHub个人主页
- 点击进入右上方GitHub头像中的Settings -> Developer Settings -> Persional access token
- 点击右上方Generate new Token
- 勾选**repo与admin:repo_hook**选项
- 点击Generate token，复制该Token

### 配置Jenkins

- 登录Jenkins
- 点击面板左侧 -> Manage Jenkins -> Configure System -> Github面板
- 点击添加Github服务器 -> GitHub Server
  - **名称**按实际情况填写
  - **API URL** 填写为https://api.github.com
  - **凭据**点击Add -> Jenkins（在弹出面板中做如下配置）
    - **Kind**选择**Secret  text**
    - **Secret**中粘贴上述生成的Token
    - **Description**中按实际情况填写
    - 点击Add按钮完成添加
  - 在**凭据**中选择上述添加的新凭证
  - **勾选管理Hook**
- 点击连接测试按钮确保联通
- 点击下方**Advanced按钮**设置
  - 勾选**覆盖Hook URL中的为 Github 指定另外一个 Hook URL**
  - 在下方地址栏填入Hook URL：http://domain:port/github-webhook/
  - 点击上方给所有任务重新注册hook
- 点击页面下方Save / Apply按钮保存

### 配置Project

- 选择所需配置的Project
- 点击面板左侧 -> Configure -> Build Triggers面板
- **勾选GitHub hook trigger for GITScm polling**
- 进入GitHub网站对应项目位置 -> Settings -> Webhooks -> 左上角Add Webhook
- 在**Payload URL**处填写 http://server_ip:port/github-webhook
- 完成后点击Add webhook

---

至此，完成Git Push触发Jenkins自动构建，在此后Project有代码提交至GitHub时，GitHub将会向该WebHook URL发送POST请求通知Jenkins进行构建。

