// 宽度表。宽度写成分数就是「占这一行的多少」，一行里所有键加起来必须正好是一整行。
// 没写宽度的键（空格）自动吃掉剩余，不参与手算。
//
// 行首 / 行尾的宽键用 `size` 取触摸宽、`bounds` 取绘制宽：触摸区一直延伸到屏幕边缘，
// 显示区仍与其余键对齐，边缘键因此更好按。
{
  // ===== iPhone：分母 1125 =====
  //   第一 / 二行  10 × 112.5                    = 1125
  //   第三行       168.75 + 8 × 112.5 + 168.75   = 1125（拼音页中间七颗，另两页八颗）
  //   第四行       280 + 空格 + 280              = 1125
  iPhone: {
    unit: { size: { width: '112.5/1125' } },
    // 第二行两端（a / l）：触摸区补到屏幕边缘，显示区维持一颗键宽
    homeRowLeft: { size: { width: '168.75/1125' }, bounds: { width: '111/168.75', alignment: 'right' } },
    homeRowRight: { size: { width: '168.75/1125' }, bounds: { width: '111/168.75', alignment: 'left' } },
    // 第三行两端（Shift / 切页 / 删除）：显示区几乎占满触摸区
    sideLeft: { size: { width: '168.75/1125' }, bounds: { width: '151/168.75', alignment: 'left' } },
    sideRight: { size: { width: '168.75/1125' }, bounds: { width: '151/168.75', alignment: 'right' } },
    bottomSide: { size: { width: '280/1125' } },
  },

  // ===== iPad：分母 16 =====
  //   第一行  13 × 1.1 + 1.7               = 16
  //   第二行  1.7 + 13 × 1.1               = 16
  //   第三行  1.95 + 11 × 1.1 + 1.95       = 16
  //   第四行  2.5 + 10 × 1.1 + 2.5         = 16
  //   第五行  4 × 1.65 + 空格 9.4          = 16
  iPad: {
    unit: { size: { width: '1.1/16' } },
    tab: { size: { width: '1.7/16' } },
    backspace: { size: { width: '1.7/16' } },
    asciiMode: { size: { width: '3.9/32' } },
    enter: { size: { width: '3.9/32' } },
    shift: { size: { width: '2.5/16' } },
    bottom: { size: { width: '1.65/16' } },
  },
}
