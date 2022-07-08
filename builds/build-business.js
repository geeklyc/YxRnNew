/*
 * @Description: 
 * @Author: liyoucheng
 * @Date: 2022-04-13 10:00:24
 * @LastEditTime: 2022-07-08 11:28:38
 * @LastEditors: liyoucheng
 */

// 文件
const fs = require('fs')
// 加密
const crypto = require('crypto')
// 同步命令
const execSync = require('child_process').execSync

// 获取 node 命令参数
const argv = process.argv
// 包名
const bundleName = argv[2];

// 模块索引
const moduleIndex = parseInt(argv[3], 10) || 0

// 获取文档 md5
const readFileMD5 = f => new Promise((resolve) => {
  const md5sum = crypto.createHash('md5')
  const stream = fs.createReadStream(f);
  stream.on('data', (chunk) => {
    md5sum.update(chunk)
  })

  stream.on('end', () => {
    const fileMd5 = md5sum.digest('hex');
    resolve(fileMd5)
  })
})

// 编译日期
const builtAt = (() => {
  const now = new Date();
  return (
    `${now.getFullYear()}-${now.getMonth() + 1}-${now.getDate()} ${now.getHours()}:${now.getMinutes()}`
  )
})()

// git 版本
const gitVersion = (() => {
  try {
    return `${execSync('git rev-parse --short HEAD')}`.trim()
  } catch (e) {
    console.log("获取版本号失败", e);
    return ''
  }
})()

// 打包入口
function buildBundle(platform) {
  console.log('【打包】开始', platform, ' 平台 ', bundleName, ' 模块打包',)

  // execSync('rm ./builds/businessIds.json', { stdio: [0, 1, 2]});

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
  execSync(`node node_modules/react-native/local-cli/cli.js bundle --assets-dest ${assetsPath} --platform ${platform} --dev false --entry-file ${bundleName}.js --bundle-output ${bundlePath} --config business.config.js ${moduleIndex}`, { stdio: [0, 1, 2]})

  if (!fs.existsSync(bundlePath)) {
    console.log(`${bundleName} 编译失败，bundlePath:${bundlePath}`)
    // 退出
    process.exit(1);
  }

  // 压缩
  execSync(`cd ${platformPath} && zip -q -r ../${platform}.zip ./ && cd ../../../`, { stdio: [0, 1, 2]})
  // 移除原有文件
  execSync(`rm -rf ${platformPath}`, {stdio: [0, 1, 2]})

  // 生成 json
  const zipPath = `./dist/${bundleName}/${platform}.zip`
  const md5Path = `./dist/${bundleName}/${platform}.json`
  if (!fs.existsSync(zipPath)) {
    console.error('打包文件不存在', error);
    process.exit(1);
  }

  readFileMD5(zipPath).then((hash) => {
    const info = {
      hash,
      builtAt,
      gitVersion,
      bundleName
    }
    fs.writeFileSync(md5Path, JSON.stringify(info, null, 2), 'utf-8')
  })

  console.log('【打包】完成', platform, ' 平台 ', bundleName, ' 模块打包',)
}

buildBundle('ios')
// buildBundle('android')
