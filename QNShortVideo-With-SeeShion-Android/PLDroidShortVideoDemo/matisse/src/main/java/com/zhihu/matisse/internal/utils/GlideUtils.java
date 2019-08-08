package com.zhihu.matisse.internal.utils;

import android.net.Uri;
import android.widget.ImageView;

import com.bumptech.glide.Glide;

/**
 * Description:
 * Data：2018/12/13-17:49
 * Author:
 */
public class GlideUtils {

    public static void loadPicNormal(ImageView view, Uri uri) {
        Glide
                .with(view.getContext())
                .load(uri)
                .into(view);
    }
}
