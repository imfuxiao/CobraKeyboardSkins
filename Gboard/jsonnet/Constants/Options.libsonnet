// 构建开关。仓库里提交的是默认值（iOS 版），可直接在手机上运行 main.jsonnet。
// make 编译时会在暂存目录里按 GRADIENT 参数重写这份文件，
// 打进 .cskin 的也是重写后的那份，所以纯色版（Android）的包重新编译也还是纯色版。
{
  // true：iOS 版，候选字筛选面板不设底色以透出系统内置背景；
  // false：纯色版（Android），筛选面板铺 Gboard 底板色
  gradient: true,
}
