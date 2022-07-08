/*
 * @Description: 
 * @Author: liyoucheng
 * @Date: 2022-04-13 13:41:20
 * @LastEditTime: 2022-07-08 11:28:39
 * @LastEditors: liyoucheng
 */
// 文件
const fs = require('fs')
// 同步命令
const execSync = require('child_process').execSync

// 包名
const bundleName = "common";

// 打包入口
function buildBundle(platform) {
  console.log('【打包】开始', platform, ' 平台 ', bundleName, ' 基础模块打包',)

  const platformPath = `./dist/${bundleName}/${platform}`;
  // bundle 输出路径
  const bundlePath = `${platformPath}/${bundleName}.${platform}.bundle`
  // assets 输出路径
  const assetsPath = platformPath;

  // 创建目录
  execSync(`mkdir -p ${platformPath}/`, { stdio: [0, 1, 2]})
  // 清空目录下所有文件
  execSync(`rm -rf ${platformPath}/*`, { stdio: [0, 1, 2]})

  // 执行打包命令
  execSync(`node node_modules/react-native/local-cli/cli.js bundle --assets-dest ${assetsPath} --platform ${platform} --dev false --entry-file ${bundleName}.js --bundle-output ${bundlePath} --config common.config.js`, { stdio: [0, 1, 2]})

  if (!fs.existsSync(bundlePath)) {
    console.log(`${bundleName} 编译失败，bundlePath:${bundlePath}`)
    // 退出
    process.exit(1);
  }
  console.log('【打包】完成', platform, ' 平台 ', bundleName, ' 基础模块打包',)
}

buildBundle('ios')
// buildBundle('android')