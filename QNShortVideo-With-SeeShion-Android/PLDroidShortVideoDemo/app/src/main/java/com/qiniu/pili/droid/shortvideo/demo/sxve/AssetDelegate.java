package com.qiniu.pili.droid.shortvideo.demo.sxve;

import com.qiniu.pili.droid.shortvideo.demo.sxve.model.MediaUiModel;
import com.qiniu.pili.droid.shortvideo.demo.sxve.model.TextUiModel;

public interface AssetDelegate {
    /**
     * 选择图片、视频等媒体文件
     * @param model
     */
    void pickMedia(MediaUiModel model);

    /**
     * 修改插入的文字
     * @param model
     */
    void editText(TextUiModel model);
}
